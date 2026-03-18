#!/bin/bash
#
# Send email via Gmail OAuth
#
# Usage:
#   ./send_email.sh --to "recipient@example.com" --subject "Subject" --body "Body text" --draft
#   ./send_email.sh --to "recipient@example.com" --subject "Subject" --body-file /path/to/body.html --html --draft
#   ./send_email.sh --to "recipient@example.com" --subject "Subject" --body "text" --dry-run
#   ./send_email.sh --to "recipient@example.com" --subject "Subject" --body "text"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pre-parse flags before dispatching
DRY_RUN=""
DRAFT_MODE=""
for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && DRY_RUN="1"
    [[ "$arg" == "--draft" ]] && DRAFT_MODE="1"
done

# If not dry-run, dispatch directly to OAuth script
if [[ -z "$DRY_RUN" ]]; then
    exec "$SCRIPT_DIR/send_email_oauth.sh" "$@"
fi

# ===== Dry-run: parse args, preview, and exit =====

HTML_MODE=""
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
        --draft) shift ;; # already captured
        --dry-run) shift ;; # already captured
        *) echo "Error: Unknown option: $1" >&2; exit 1 ;;
    esac
done

if [[ -z "$TO" ]]; then echo "Error: --to is required" >&2; exit 1; fi
if [[ -z "$SUBJECT" ]]; then echo "Error: --subject is required" >&2; exit 1; fi

if [[ -n "$BODY_FILE" ]]; then
    [[ ! -f "$BODY_FILE" ]] && echo "Error: body file not found: $BODY_FILE" >&2 && exit 1
    BODY=$(cat "$BODY_FILE")
elif [[ -z "$BODY" ]]; then
    echo "Error: --body or --body-file is required" >&2; exit 1
fi

FROM_NAME="${SENDER_NAME:-}"
CONTENT_TYPE=$([[ -n "$HTML_MODE" ]] && echo "text/html; charset=UTF-8" || echo "text/plain; charset=UTF-8")

if [[ -n "$DRAFT_MODE" ]]; then
    MODE_LABEL="DRAFT"
else
    MODE_LABEL="SEND"
fi

echo "=== DRY RUN — email will NOT be sent ==="
echo "Mode: $MODE_LABEL"
echo ""
[[ -n "$FROM_NAME" ]] && echo "From: $FROM_NAME"
echo "To: $TO"
[[ -n "$CC" ]] && echo "Cc: $CC"
[[ -n "$BCC" ]] && echo "Bcc: $BCC"
echo "Subject: $SUBJECT"
echo "Content-Type: $CONTENT_TYPE"
echo ""
echo "$BODY"
echo ""
echo "=== END DRY RUN ==="
