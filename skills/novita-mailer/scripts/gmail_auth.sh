#!/bin/bash
#
# Gmail OAuth one-time authentication
#
# Steps:
#   1. Fill GMAIL_CLIENT_ID and GMAIL_CLIENT_SECRET in config.env
#   2. Run: ./scripts/gmail_auth.sh
#   3. Authorize in the browser
#   4. Copy the REFRESH_TOKEN into config.env
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/config.env"

if [[ -z "$GMAIL_CLIENT_ID" || -z "$GMAIL_CLIENT_SECRET" ]]; then
    echo "Error: GMAIL_CLIENT_ID and GMAIL_CLIENT_SECRET must be set in config.env" >&2
    exit 1
fi

REDIRECT_URI="http://localhost:8085"
SCOPE_ENCODED="https://www.googleapis.com/auth/gmail.send%20https://www.googleapis.com/auth/gmail.compose"

AUTH_URL="https://accounts.google.com/o/oauth2/v2/auth?client_id=${GMAIL_CLIENT_ID}&redirect_uri=${REDIRECT_URI}&response_type=code&scope=${SCOPE_ENCODED}&access_type=offline&prompt=consent"

echo "============================================"
echo "Gmail OAuth Setup"
echo "============================================"
echo ""
echo "Step 1: Open this URL in your browser:"
echo ""
echo "$AUTH_URL"
echo ""

# Try to auto-open browser
if command -v xdg-open &> /dev/null; then
    xdg-open "$AUTH_URL" 2>/dev/null &
elif command -v open &> /dev/null; then
    open "$AUTH_URL" 2>/dev/null &
fi

echo "Step 2: After authorizing, you'll be redirected to a page that won't load."
echo "        Copy the full URL from the address bar and paste it below."
echo ""
read -p "Paste the redirect URL: " REDIRECT_RESPONSE

AUTH_CODE=$(echo "$REDIRECT_RESPONSE" | sed -n 's/.*code=\([^&]*\).*/\1/p' | head -1)

if [[ -z "$AUTH_CODE" ]]; then
    echo "Error: Could not extract authorization code from URL" >&2
    echo "Expected format: http://localhost:8085/?code=4/xxx&scope=..." >&2
    exit 1
fi

echo ""
echo "Step 3: Exchanging for tokens..."

RESPONSE=$(curl -s -X POST "https://oauth2.googleapis.com/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=${GMAIL_CLIENT_ID}" \
    -d "client_secret=${GMAIL_CLIENT_SECRET}" \
    -d "code=${AUTH_CODE}" \
    -d "grant_type=authorization_code" \
    -d "redirect_uri=${REDIRECT_URI}")

if echo "$RESPONSE" | grep -q '"error"'; then
    echo "Error: Token exchange failed" >&2
    echo "$RESPONSE" >&2
    exit 1
fi

REFRESH_TOKEN=$(echo "$RESPONSE" | sed -n 's/.*"refresh_token" *: *"\([^"]*\)".*/\1/p')

if [[ -z "$REFRESH_TOKEN" ]]; then
    echo "Error: No refresh_token in response" >&2
    echo "$RESPONSE" >&2
    exit 1
fi

echo ""
echo "============================================"
echo "Success!"
echo "============================================"
echo ""
echo "Add this to config.env:"
echo ""
echo "export GMAIL_REFRESH_TOKEN=\"${REFRESH_TOKEN}\""
echo ""
echo "============================================"
