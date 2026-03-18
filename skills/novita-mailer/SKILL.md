---
name: novita-mailer
description: Draft, preview, and send emails on behalf of the Novita AI team. Use this skill whenever the user or an agent needs to compose or send an email — outreach to open-source maintainers, follow-ups, thank-you notes, welcome emails, introductions, or any professional email. Also use when you see an email address and the context suggests a message should be sent, or when a workflow produces a "send email" action.
---

# Novita Mailer

Novita AI team's shared email skill. Compose, preview, and send professional emails via Gmail OAuth. Any team member or agent can use this skill.

## IMPORTANT: Draft-First Policy

**By default, always use `--draft` mode.** This saves emails to Gmail drafts instead of sending them directly. The sender reviews and sends manually from their Gmail inbox.

Direct sending (without `--draft`) is allowed only when the user explicitly requests it — for example, "send it directly" or "don't draft, just send". If the user simply says "send an email" or "email them", use `--draft` and tell them to check their Gmail drafts.

This exists because automated emails carry real reputation risk. A human should review every email before it goes out.

## IMPORTANT: Mandatory Preview Before Any Action

**Never call `send_email.sh` (whether `--draft` or direct send) without showing the user a full preview first and getting their explicit confirmation.** No exceptions.

The preview must include:
- **To** (and CC/BCC if any)
- **Subject**
- **Full body** (rendered as the recipient would see it)

Wait for the user to say "OK", "looks good", "send it", "go ahead", or similar before executing. If the user asks for changes, revise and preview again. This applies to both draft and direct send — a draft still lands in the sender's inbox and should be correct.

---

## First-Time Setup

Before using this skill, check if `config.env` exists. If it does not, **stop and walk the user through setup interactively**:

1. Ask: "How should I address you in emails? (Your display name, e.g. 'Alex Yang')"
2. Ask: "What's your title? (e.g. 'GTM, Novita AI')"
3. Ask: "What's your email address? (This will be used as the sender)"
4. Write these values into `config.env` as `SENDER_NAME`, `SENDER_TITLE`, `SENDER_EMAIL`
5. Then guide them through the OAuth setup below

If `config.env` already exists but `SENDER_NAME` is empty, ask the same questions to fill it in.

### Step 1 — Create a Google Cloud OAuth app

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use an existing one)
3. Navigate to **APIs & Services → Library**, search for **Gmail API**, and enable it
4. Go to **APIs & Services → OAuth consent screen**
   - Choose **External** user type
   - Fill in the app name (e.g. "Novita Email Sender")
   - Add your Gmail address as a **test user**
   - Add these scopes: `gmail.send`, `gmail.compose`
5. Go to **APIs & Services → Credentials**
   - Click **Create Credentials → OAuth 2.0 Client ID**
   - Application type: **Desktop app**
   - Note down the **Client ID** and **Client Secret**

### Step 2 — Create config.env

```bash
cp config.env.template config.env
```

Edit `config.env` and fill in:
- `SENDER_NAME` — your display name (e.g. "Alex Yang")
- `SENDER_TITLE` — your title (e.g. "GTM, Novita AI")
- `SENDER_EMAIL` — your email address
- `GMAIL_CLIENT_ID` — from Step 1
- `GMAIL_CLIENT_SECRET` — from Step 1

### Step 3 — Authorize and get refresh token

```bash
bash scripts/gmail_auth.sh
```

This opens your browser for Google authorization. After authorizing:
1. You'll be redirected to a page that won't load — this is normal
2. Copy the full URL from the address bar
3. Paste it back into the terminal
4. The script outputs a `GMAIL_REFRESH_TOKEN`
5. Copy that token into `config.env`

### Step 4 — Verify

```bash
source config.env
./scripts/send_email.sh --to "your-email@example.com" --subject "Test" --body "Hello" --draft
```

Check your Gmail drafts. If the draft appears, you're all set.

---

## When to Use

- Composing any outreach, follow-up, thank-you, or introduction email
- A workflow produces a recipient address and a reason to reach out
- The user says "email them", "send a message to", "draft an email", "reach out to", etc.
- Sending a templated or one-off email through configured credentials

## When NOT to Use

- Internal Slack/Telegram/Discord messages (those are channel messages, not email)
- Reading or fetching emails (this skill only sends)
- Calendar invites (use a calendar skill instead)

## Core Workflow

1. **Check config** — If `config.env` is missing or incomplete, walk the user through First-Time Setup first. Read `SENDER_NAME`, `SENDER_TITLE`, `SENDER_EMAIL` from config.env for composing the email.
2. **Draft** — Write the subject and body. Apply Novita AI brand rules (see below). The scripts only handle delivery — **you are responsible for composing the full body including the signature** using the sender's identity from config.env.
3. **Preview** — Show the exact subject, body, and recipient to the user. Confirm before proceeding.
4. **Save to drafts** — Use `scripts/send_email.sh --draft` (the default). Tell the user: "Draft saved — check your Gmail drafts to review and send."
5. **Direct send** — Only if the user explicitly asks to skip drafts. Use `scripts/send_email.sh` without `--draft`.

## Quick Start

```bash
SKILL_DIR="/path/to/novita-mailer"  # adjust to your install location
source "$SKILL_DIR/config.env"

# Default: save as Gmail draft (recommended)
$SKILL_DIR/scripts/send_email.sh \
  --to "recipient@example.com" \
  --subject "Subject line" \
  --body-file /tmp/email.html \
  --html \
  --draft

# Dry-run (preview in terminal, nothing saved or sent)
$SKILL_DIR/scripts/send_email.sh \
  --to "recipient@example.com" \
  --subject "Subject line" \
  --body "Body text" \
  --dry-run

# Direct send (only when user explicitly requests it)
$SKILL_DIR/scripts/send_email.sh \
  --to "recipient@example.com" \
  --subject "Subject line" \
  --body "Plain text body"

# With CC/BCC
$SKILL_DIR/scripts/send_email.sh \
  --to "recipient@example.com" \
  --cc "colleague@example.com" \
  --subject "Subject line" \
  --body "Body text" \
  --draft
```

## Script Options

| Flag | Description |
|------|-------------|
| `--to` | Recipient address (required) |
| `--subject` | Subject line (required) |
| `--body` | Inline body text |
| `--body-file` | Path to body file (plain text or HTML) |
| `--html` | Send as HTML (default is plain text) |
| `--cc` | CC address |
| `--bcc` | BCC address |
| `--draft` | Save as Gmail draft instead of sending |
| `--dry-run` | Print the full email to stdout without sending |

## Files

| Path | Purpose |
|------|---------|
| `config.env` | Local credentials and sender identity (not committed) |
| `config.env.template` | Template for first-time setup |
| `scripts/send_email.sh` | Main entry point (dry-run handler + dispatches to OAuth) |
| `scripts/send_email_oauth.sh` | Gmail OAuth sender (send or draft) |
| `scripts/gmail_auth.sh` | One-time OAuth authorization helper |
| `references/novita_brand.md` | Novita AI brand rules, intro patterns, and tone guide |
| `references/templates/` | Example email templates |

---

## Novita AI Brand Rules

These rules apply to **every email** sent through this skill. Read `references/novita_brand.md` for the full guide. The essentials:

### Sender Identity

Use the sender's own name and title from `config.env`. The signature always includes the Novita AI brand and website link.

### Opening and Brand Endorsement

Follow the 5-step email structure in `references/novita_brand.md`: Opening → Body → Brand Endorsement → Ask → Signature. The brand endorsement paragraph (including "#1 Inference Provider on Hugging Face and OpenRouter") is required for all first-contact outreach, PR emails, and proposals.

### Signature Block

Every email must end with a signature block that includes the sender's name, title, email, and a link to [novita.ai](https://novita.ai).

Format:
```
Best,
{sender_name}
{sender_title}
{sender_email} | novita.ai
```

For HTML emails, use the brand teal color (`#016e8f`) on the novita.ai link, and include the company address in small text below. See `references/novita_brand.md` Step 5 — Signature for the full HTML format.

### Tone

- Professional but warm, not corporate-stiff
- Concise — respect the reader's time
- Show genuine interest in the recipient's work when relevant
- Avoid salesy language, buzzwords, or pressure tactics

---

## Template Usage

Example templates live in `references/templates/`. They are **starting points**, not copy-paste scripts.

**Templates are reference docs for the agent — do NOT pass them directly to `--body-file`.** The files contain markdown formatting and code blocks around the HTML. Extract the HTML body, replace all placeholders, and write the final content to a temp file before passing it to the script.

Before using a template:
1. Read the template to understand the structure
2. Extract the HTML body from inside the code block
3. Replace all placeholders (`{name}`, `{repo}`, `{sender_name}`, `{sender_title}`, `{sender_email}`, etc.) with actual values from config.env and context
4. Write the final HTML to a temp file (e.g. `/tmp/email.html`)
5. Preview the final result to the user before sending

If no template fits, draft from scratch following the brand rules above.

---

## Common Mistakes

- Sending directly without `--draft` — always default to draft mode
- Sending before previewing — always preview first
- Forgetting `--html` for HTML email bodies
- Leaving placeholder text (`{name}`, `{repo}`) in the final email
- Missing the signature block or the novita.ai link
- Using a stale template without customizing for the recipient
- Not running `source config.env` before calling the send script
