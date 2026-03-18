#!/bin/bash
#
# Send email via Gmail API + OAuth (pure bash/curl)
#
# Required env vars:
#   GMAIL_CLIENT_ID     - OAuth Client ID
#   GMAIL_CLIENT_SECRET - OAuth Client Secret
#   GMAIL_REFRESH_TOKEN - OAuth Refresh Token (obtain via gmail_auth.sh)
#
# Optional (set in config.env):
#   SENDER_NAME       - Sender's display name (used for From header)
#   GMAIL_FROM_EMAIL  - Sender email (defaults to authenticated account)
#
# Usage:
#   ./send_email_oauth.sh --to "recipient@example.com" --subject "Subject" --body "Body text"
#   ./send_email_oauth.sh --to "recipient@example.com" --subject "Subject" --body-file /path/to/body.html --html
#   ./send_email_oauth.sh --to "recipient@example.com" --cc "cc@example.com" --subject "Subject" --body "text"
#   ./send_email_oauth.sh --to "recipient@example.com" --subject "Subject" --body "text" --draft

set -e

# ===== Parse arguments =====

HTML_MODE=""
DRAFT_MODE=""
TO=""
CC=""
BCC=""
SUBJECT=""
BODY=""
BODY_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --to) TO="$2"; shift 2 ;;
        --cc) CC="$2"; shift 2 ;;
        --bcc) BCC="$2"; shift 2 ;;
        --subject) SUBJECT="$2"; shift 2 ;;
        --body) BODY="$2"; shift 2 ;;
        --body-file) BODY_FILE="$2"; shift 2 ;;
        --html) HTML_MODE="1"; shift ;;
        --draft) DRAFT_MODE="1"; shift ;;
        --dry-run) shift ;; # handled by wrapper
        *) echo "Error: Unknown option: $1" >&2; exit 1 ;;
    esac
done

# ===== Validate env =====

for var in GMAIL_CLIENT_ID GMAIL_CLIENT_SECRET GMAIL_REFRESH_TOKEN; do
    if [[ -z "${!var}" ]]; then
        echo "Error: $var is not set. Check config.env and run gmail_auth.sh" >&2
        exit 1
    fi
done

# ===== Validate args =====

if [[ -z "$TO" ]]; then
    echo "Error: --to is required" >&2
    exit 1
fi

if [[ -z "$SUBJECT" ]]; then
    echo "Error: --subject is required" >&2
    exit 1
fi

if [[ -n "$BODY_FILE" ]]; then
    if [[ ! -f "$BODY_FILE" ]]; then
        echo "Error: body file not found: $BODY_FILE" >&2
        exit 1
    fi
    BODY=$(cat "$BODY_FILE")
elif [[ -z "$BODY" ]]; then
    echo "Error: --body or --body-file is required" >&2
    exit 1
fi

# ===== Step 1: Get access token =====

ACCESS_TOKEN_RESPONSE=$(curl -s -X POST "https://oauth2.googleapis.com/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=${GMAIL_CLIENT_ID}" \
    -d "client_secret=${GMAIL_CLIENT_SECRET}" \
    -d "refresh_token=${GMAIL_REFRESH_TOKEN}" \
    -d "grant_type=refresh_token")

ACCESS_TOKEN=$(echo "$ACCESS_TOKEN_RESPONSE" | sed -n 's/.*"access_token" *: *"\([^"]*\)".*/\1/p')

if [[ -z "$ACCESS_TOKEN" ]]; then
    echo "Error: Failed to get access token. Token may be expired — re-run gmail_auth.sh" >&2
    echo "$ACCESS_TOKEN_RESPONSE" >&2
    exit 1
fi

# ===== Step 2: Build RFC 2822 email =====

FROM_EMAIL="${GMAIL_FROM_EMAIL:-me}"

# From header
FROM_HEADER=""
if [[ -n "$SENDER_NAME" ]]; then
    if [[ "$FROM_EMAIL" != "me" ]]; then
        FROM_HEADER="From: \"${SENDER_NAME}\" <${FROM_EMAIL}>"
    else
        FROM_HEADER="From: \"${SENDER_NAME}\""
    fi
fi

# Content-Type
if [[ -n "$HTML_MODE" ]]; then
    CONTENT_TYPE="text/html; charset=UTF-8"
else
    CONTENT_TYPE="text/plain; charset=UTF-8"
fi

# Assemble headers
HEADERS=""
if [[ -n "$FROM_HEADER" ]]; then
    HEADERS="${FROM_HEADER}
"
fi
HEADERS="${HEADERS}To: ${TO}"
if [[ -n "$CC" ]]; then
    HEADERS="${HEADERS}
Cc: ${CC}"
fi
if [[ -n "$BCC" ]]; then
    HEADERS="${HEADERS}
Bcc: ${BCC}"
fi
HEADERS="${HEADERS}
Subject: ${SUBJECT}
Content-Type: ${CONTENT_TYPE}"

EMAIL_RAW="${HEADERS}

${BODY}"

# Base64 URL-safe encode
# Base64 encode (compatible with both GNU and macOS base64)
if base64 --help 2>&1 | grep -q '\-w'; then
    EMAIL_BASE64=$(echo -n "$EMAIL_RAW" | base64 -w 0 | tr '+/' '-_' | tr -d '=')
else
    EMAIL_BASE64=$(echo -n "$EMAIL_RAW" | base64 | tr -d '\n' | tr '+/' '-_' | tr -d '=')
fi

# ===== Step 3: Send or Draft =====

if [[ -n "$DRAFT_MODE" ]]; then
    # Create draft via Gmail API
    RESPONSE=$(curl -s -X POST "https://gmail.googleapis.com/gmail/v1/users/me/drafts" \
        -H "Authorization: Bearer ${ACCESS_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "{\"message\": {\"raw\": \"${EMAIL_BASE64}\"}}")

    if echo "$RESPONSE" | grep -q '"id"'; then
        DRAFT_ID=$(echo "$RESPONSE" | sed -n 's/.*"id" *: *"\([^"]*\)".*/\1/p' | head -1)
        echo "Draft created for ${TO} (Draft ID: ${DRAFT_ID})"
        echo "Open Gmail to review and send: https://mail.google.com/mail/#drafts"
    else
        echo "Error: Failed to create draft" >&2
        echo "$RESPONSE" >&2
        exit 1
    fi
else
    # Send directly
    RESPONSE=$(curl -s -X POST "https://gmail.googleapis.com/gmail/v1/users/me/messages/send" \
        -H "Authorization: Bearer ${ACCESS_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "{\"raw\": \"${EMAIL_BASE64}\"}")

    if echo "$RESPONSE" | grep -q '"id"'; then
        MESSAGE_ID=$(echo "$RESPONSE" | sed -n 's/.*"id" *: *"\([^"]*\)".*/\1/p' | head -1)
        echo "Email sent to ${TO} (Message ID: ${MESSAGE_ID})"
    else
        echo "Error: Failed to send email" >&2
        echo "$RESPONSE" >&2
        exit 1
    fi
fi
