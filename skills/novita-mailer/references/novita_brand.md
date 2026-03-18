# Novita AI — Email Brand Guide

Any team member or agent writing emails on behalf of Novita AI should follow this guide. It covers who we are, how to structure an email, and the writing rules that keep our voice consistent.

---

## 1. About Novita AI — Brand Material

This section is a reference library. Pull from it when composing emails — don't memorize it, just come back here when you need to introduce the company or back up a claim.

### Company Overview

Novita AI is an AI infrastructure platform. We provide LLM inference, GPU cloud, and sandboxed code execution services.

### Key Brand Facts

| Fact | Use When |
|------|----------|
| Ranked #1 Inference Provider on Hugging Face and OpenRouter | Every outreach email — this is our strongest signal |
| Partners include SGLang, OpenRouter, and Poe | Showing ecosystem credibility |
| API is fully OpenAI-compatible | Technical recipients — shows easy integration |
| Secure sandboxed containers with multi-language support | Code execution / sandbox use cases |
| Website: [novita.ai](https://novita.ai) | Always in signature, optionally in body |
| HQ: 156 2nd Street, San Francisco, CA 94105 | Signature (optional) — adds legitimacy |

### Brand Colors

| Color | Hex | Use |
|-------|-----|-----|
| Novita Teal | `#016e8f` | Links — use for `novita.ai` and any branded links in HTML emails |
| Novita Green | `#23d57c` | Accent / emphasis — sparingly, not for outreach body text |

### Standard Brand Endorsement Line

When introducing Novita AI in outreach emails, use this as the baseline:

```
A bit about us: we partner with SGLang, OpenRouter, and Poe, and are ranked #1 Inference Provider on Hugging Face and OpenRouter.
```

You can append one additional fact from the table above when it's relevant to the recipient. Never stack more than two.

---

## 2. Email Structure

Every email follows this order. Each section maps to a paragraph in the final email.

### Step 1 — Opening (who you are)

Greet, then introduce yourself in one line.

**First contact:**
```
Hi {name},

I'm {sender_name} from Novita AI.
```

If the recipient's name is unknown, use "Hi there,".

For **follow-ups or replies**, skip the introduction — jump straight to the point:
```
Hi {name},

Just following up on [context].
```

### Step 2 — Body (why you're writing)

One or two short paragraphs explaining the purpose. Connect to the recipient's work or project — show you actually looked at what they do.

Good:
```
I just submitted PR #123 to add Novita as an optional LLM provider for {repo}.
I noticed your project supports multiple LLM backends — adding another option felt like a natural fit.
```

Bad:
```
We would like to explore synergies between our organizations and identify mutually beneficial collaboration opportunities.
```

### Step 3 — Brand Endorsement (who Novita AI is)

Place the brand endorsement line **after** the body, not in the opening. The reader already knows what you want — now you're answering "why should I care?"

```
A bit about us: we partner with SGLang, OpenRouter, and Poe, and are ranked #1 Inference Provider on Hugging Face and OpenRouter. Our API is fully OpenAI-compatible, so the integration is lightweight.
```

**When to include:**
- First-contact outreach — always
- PR submission emails — always
- Proposals — always

**When to skip:**
- Follow-ups — they already know
- Thank-you emails — keep it short
- Internal / existing relationship — unnecessary

### Step 4 — Ask (what you want)

End the body with a clear, low-pressure ask:

```
Would you have a chance to take a look?
```

```
Would you be open to a PR? Happy to follow your contribution guidelines.
```

Don't combine the ask with the brand endorsement in the same sentence.

### Step 5 — Signature

Every email ends with this. No exceptions.

**Plain text:**
```
Best,
{sender_name}
{sender_title}
{sender_email} | novita.ai
```

**HTML:**
```html
Best,<br>
{sender_name}<br>
{sender_title}<br>
{sender_email} | <a href="https://novita.ai" style="color:#016e8f;">novita.ai</a><br>
<span style="font-size:11px;color:#999;">156 2nd Street, San Francisco, CA 94105</span>
```

The sender's name, title, and email come from `config.env` (`SENDER_NAME`, `SENDER_TITLE`, `SENDER_EMAIL`).

---

## 3. Writing Rules

### Tone

- **Professional but warm** — write like a person, not a company
- **Concise** — the reader should get the point in under 30 seconds
- **Genuine interest** — a personalized sentence beats a paragraph of generic praise
- **No pressure** — avoid "limited time", "act now", "don't miss out"
- **No buzzwords** — avoid "synergy", "leverage", "cutting-edge", "game-changing"
- **No corporate filler** — avoid "genuinely interested in supporting your project's growth and exploring potential collaboration opportunities down the road"

### Subject Line

- Under 60 characters
- Be specific: "[Proposal] Add Novita AI to {repo}" not "Collaboration Opportunity"
- Replies: "Re: [original subject]"
- No ALL CAPS, no clickbait, no excessive punctuation

### HTML Formatting

Keep it simple — many email clients strip complex HTML:

- Paragraphs: `<br><br>`
- Bold: `<b>text</b>`
- Links: `<a href="url">text</a>`
- Lists: `•` or `<ul>/<li>`
- No CSS, no images, no complex layouts
