# PR Outreach Templates

Example templates for reaching out to open-source maintainers about Novita AI integration PRs. Customize for each recipient — these are starting points, not scripts.

**These are reference docs for the agent, not files to pass to `--body-file`.** Extract and customize the HTML body before sending.

Replace placeholders: `{name}`, `{repo}`, `{pr_url}`, `{pr_number}`, `{personalized_note}`, `{sender_name}`, `{sender_title}`, `{sender_email}`

---

## PR Submitted — Requesting Review

Use when a PR has already been submitted and CI is passing. Lead with the PR, not the company intro.

**Subject**: [Proposal] Add Novita AI as LLM provider to {repo}

**Body (HTML)**:
```html
Hi {name},<br><br>

I'm {sender_name} from Novita AI. I just submitted <a href="{pr_url}">PR #{pr_number}</a> to add Novita as an optional LLM provider for {repo}.<br><br>

{personalized_note}<br><br>

A bit about us: we partner with SGLang, OpenRouter, and Poe, and are ranked #1 Inference Provider on Hugging Face and OpenRouter. Our API is fully OpenAI-compatible, so the change is minimal and non-breaking.<br><br>

Would you have a chance to take a look?<br><br>

Best,<br>
{sender_name}<br>
{sender_title}<br>
{sender_email} | <a href="https://novita.ai" style="color:#016e8f;">novita.ai</a><br>
<span style="font-size:11px;color:#999;">156 2nd Street, San Francisco, CA 94105</span>
```

**Personalized note examples:**
- "I noticed your project supports multiple LLM backends — adding another option felt like a natural fit."
- "Your RAG pipeline is really well-designed. We think having more affordable inference options could help your users."
- "Given {repo}'s focus on cost efficiency for long-running agents, provider flexibility seemed especially relevant here."

---

## Proposal — No PR Yet

Use when reaching out before submitting a PR. Focus on the value to the project, not on Novita credentials.

**Subject**: Quick question about contributing to {repo}

**Body (HTML)**:
```html
Hi {name},<br><br>

I'm {sender_name} from Novita AI. I've been looking at {repo} and would love to contribute by adding Novita as an LLM provider option.<br><br>

{personalized_note}<br><br>

A bit about us: we partner with SGLang, OpenRouter, and Poe, and are ranked #1 Inference Provider on Hugging Face and OpenRouter. Our API is fully OpenAI-compatible, so the integration would be lightweight.<br><br>

Would you be open to a PR? Happy to follow your contribution guidelines.<br><br>

Best,<br>
{sender_name}<br>
{sender_title}<br>
{sender_email} | <a href="https://novita.ai" style="color:#016e8f;">novita.ai</a><br>
<span style="font-size:11px;color:#999;">156 2nd Street, San Francisco, CA 94105</span>
```

---

## PR Merged — Thank You

Use after a PR has been merged. Keep it short and genuine — don't pitch.

**Subject**: Thanks for merging the Novita AI PR in {repo}

**Body (HTML)**:
```html
Hi {name},<br><br>

Thanks for merging <a href="{pr_url}">PR #{pr_number}</a> — really appreciate it.<br><br>

If there's anything we can do to support {repo} (testing credits, bug fixes, etc.), just let us know.<br><br>

Best,<br>
{sender_name}<br>
{sender_title}<br>
{sender_email} | <a href="https://novita.ai" style="color:#016e8f;">novita.ai</a><br>
<span style="font-size:11px;color:#999;">156 2nd Street, San Francisco, CA 94105</span>
```
