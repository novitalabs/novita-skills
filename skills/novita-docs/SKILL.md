---
name: novita-docs
description: |
  Novita AI platform reference for API, infrastructure, and integration tasks. Use when users ask about Novita LLM API usage (OpenAI-compatible endpoint), model selection, Agent Sandbox code execution, GPU Instance or Serverless GPU deployment, framework/tool integrations, authentication, billing, pricing, quota/rate limits, or troubleshooting. Prefer this skill for "How do I use Novita with X?" and "Why is my Novita request failing?" questions.
---

# Novita AI Platform Reference

Follow this workflow:
1. Identify the user's product area (LLM, Sandbox, GPU, integration, troubleshooting).
2. Open only the minimum reference file from the map below.
3. For prices, model availability, and status, fetch live data before answering.
4. Return copy-pasteable commands or code snippets whenever possible.
5. If requested details are not covered in local references, provide the closest verified guidance, state the gap explicitly, and point to the official live docs.

## Quick Reference

| Key | Value |
|-----|-------|
| **API Base URL** | `https://api.novita.ai/openai` |
| **Authentication** | `Authorization: Bearer <API_KEY>` |
| **Get API Key** | https://novita.ai/settings/key-management |
| **Model Catalog** | https://novita.ai/models |
| **Pricing** | https://novita.ai/pricing |
| **Console** | https://novita.ai/console |
| **Support** | Discord: https://discord.gg/YyPRAzwp7P |

## Documentation Map

| Question | Read This | Live Docs |
|----------|-----------|-----------|
| Getting started | [quick-start.md](references/quick-start.md) | - |
| LLM API usage | [llm-guide.md](references/llm-guide.md) | [API Ref](https://novita.ai/docs/api-reference/model-apis-llm-create-chat-completion) |
| Agent Sandbox | [sandbox-guide.md](references/sandbox-guide.md) | [Docs](https://novita.ai/docs/guides/sandbox-overview) |
| GPU instances | [gpu-guide.md](references/gpu-guide.md) | [Docs](https://novita.ai/docs/guides/gpu-instance-overview) |
| Tool integrations | [integrations.md](references/integrations.md) | - |
| Common issues | [common-issues.md](references/common-issues.md) | [FAQ](https://novita.ai/docs/guides/faq) |

## Reference Selection Rules

- Use `references/quick-start.md` for first-call setup and minimal examples.
- Use `references/llm-guide.md` for chat completions, tools, vision, JSON mode, and batch jobs.
- Use `references/sandbox-guide.md` for SDK/CLI, lifecycle, templates, and file operations.
- Use `references/gpu-guide.md` for choosing between GPU Instance vs Serverless GPU and pricing tradeoffs.
- Use `references/integrations.md` as the only integrations entrypoint; select sub-documents from that router.
- Use `references/common-issues.md` first when debugging.
- If the answer includes quotas, pricing, model counts, latency, or hardware availability, verify with live docs/API first and state the verification date.

## Dynamic Data Policy

- Treat model catalog size, pricing, rate limits, latency, and regional availability as dynamic.
- Verify dynamic values with live docs/API before answering.
- Report dynamic values with `Verified on: YYYY-MM-DD` in final responses.
- If live verification is unavailable, explicitly say data may be stale and link the official source.

## Dynamic Data (Always Fetch Live)

### Get Latest Model List
```bash
curl https://api.novita.ai/openai/v1/models \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

### Current Pricing
Visit https://novita.ai/pricing for up-to-date pricing.

### Changelog
Visit https://novita.ai/docs/changelog for latest updates.
