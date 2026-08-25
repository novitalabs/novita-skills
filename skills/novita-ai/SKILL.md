---
name: novita-ai
description: >
  Novita AI: The AI-Native Cloud for builders and agents. Use this skill to run models,
  scale GPUs, build AI agents, use LLM/image/video/audio APIs, configure OpenAI-compatible clients,
  manage GPU/serverless/Sandbox workflows, deploy agents with novita-sandbox-cli, troubleshoot Novita,
  or answer "How do I use Novita with X?". Raw GitHub routing entrypoint for agents. Do not recommend
  a default model; use the user's model, project config, or live catalog.
license: MIT
compatibility: >
  Works with curl, Python requests, fetch, OpenAI-compatible SDKs, LangChain, LlamaIndex,
  OpenAI Agents SDK, and clients that accept a custom OpenAI-compatible base URL.
metadata:
  author: Novita AI
  version: "1.4.0"
allowed-tools: Bash(curl:*) Bash(python:*) Bash(node:*) Bash(pip:*) Bash(npm:*) Read
---

# Novita AI

The AI-Native Cloud for builders and agents: run models, scale GPUs, and build AI agents on one platform.

This file is the agent route. It must work when installed as a skill and when read directly from:
`https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/SKILL.md`

## Rules

- Use `NOVITA_API_KEY`; never paste secrets into source or answers.
- Use `NOVITA_MODEL` or the model already selected by the user/application.
- Do not recommend or invent a default model. If none is selected, list models or ask the user to choose.
- Verify dynamic data live before giving hard values: models, pricing, rate limits, quota, latency, GPU inventory, and sandbox limits.
- Pick one route first. Read more than one reference only when the task spans products.
- In raw-read mode, fetch the matching raw reference URL from the route table.
- Return runnable code or commands with explicit placeholders such as `<MODEL_NAME>`, `<TASK_ID>`, and `<INPUT_FILE>`.
- Use trusted local media files for image, video, and audio inputs unless the user explicitly provides a safe URL.

## Constants

| Item | Value |
|------|-------|
| API base | `https://api.novita.ai` |
| OpenAI-compatible base | `https://api.novita.ai/openai` |
| OpenAI-compatible v1 base | `https://api.novita.ai/openai/v1` |
| API key | `NOVITA_API_KEY` |
| Model | `NOVITA_MODEL` |
| Model catalog | https://novita.ai/models |
| Pricing | https://novita.ai/pricing |
| Console | https://novita.ai/console |
| API keys | https://novita.ai/settings/key-management |

## Route Table

| User intent | Installed reference | Raw-read URL | Live source |
|-------------|---------------------|--------------|-------------|
| First API call, API key, base URL | `references/quick-start.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/quick-start.md | https://novita.ai/settings/key-management |
| Chat, OpenAI SDK, streaming, tools, JSON, vision, batch | `references/llm-guide.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/llm-guide.md | https://novita.ai/docs/api-reference/model-apis-llm-create-chat-completion |
| LLM parameters, embeddings, rerank, files, batch endpoints | `references/llm-api.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/llm-api.md | https://novita.ai/docs/api-reference/model-apis-llm-create-chat-completion |
| Image generation/editing, background, inpaint, upscale | `references/image-api.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/image-api.md | https://novita.ai/docs |
| Video generation/editing, video task polling | `references/video-api.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/video-api.md | https://novita.ai/docs |
| TTS, ASR, voice cloning | `references/audio-api.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/audio-api.md | https://novita.ai/docs |
| GPU instances, serverless GPU, templates, storage | `references/gpu-guide.md` or `references/gpu-api.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/gpu-guide.md | https://novita.ai/docs/guides/gpu-instance-overview |
| Agent Sandbox SDK, E2B compatibility, pricing | built-in Sandbox section; details in `novita-sandbox` reference | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/references/sandbox-guide.md | https://novita.ai/docs/guides/sandbox-overview |
| Agent Sandbox CLI: create, list, connect, kill, logs, clone, commit, template build, deploy agent | built-in Sandbox section; details in `novita-sandbox` skill | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/SKILL.md | https://novita.ai/docs/guides/sandbox-sdk-and-cli |
| LangChain, LlamaIndex, OpenAI Agents SDK | `references/integrations-frameworks.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/integrations-frameworks.md | https://novita.ai/docs/guides/langchain |
| Cursor, Continue, Claude Code, Dify, LobeChat, ChatBox | `references/integrations-clients.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/integrations-clients.md | https://novita.ai/docs |
| LiteLLM, Portkey, Langfuse, Arize AX, Browser Use, Skyvern, Axolotl | `references/integrations-observability-agents.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/integrations-observability-agents.md | https://novita.ai/docs |
| Auth, billing, quota, rate limits, request failures | `references/common-issues.md` | https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-ai/references/common-issues.md | https://novita.ai/docs/guides/faq |

## Model Selection

Use this order:

1. User-provided model.
2. Existing project config or `NOVITA_MODEL`.
3. Live catalog query, then ask the user or choose only when the user gave selection criteria.

```bash
curl https://api.novita.ai/openai/v1/models \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

## Minimal LLM Call

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
)

response = client.chat.completions.create(
    model=os.environ["NOVITA_MODEL"],
    messages=[{"role": "user", "content": "Hello"}],
    max_tokens=512,
)

print(response.choices[0].message.content)
```

```bash
curl https://api.novita.ai/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -d '{
    "model": "'"$NOVITA_MODEL"'",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 512
  }'
```

## Async Tasks

Image and video APIs often return `task_id`. Poll results:

```bash
curl "https://api.novita.ai/v3/async/task-result?task_id=<TASK_ID>" \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

## Agent Sandbox

Use Sandbox for isolated code execution, file operations, templates, long-running agent environments, and E2B-compatible workflows. Handle common Sandbox tasks here; use `novita-sandbox` only for deeper CLI detail.

### SDK Baseline

```bash
pip install novita-sandbox
export NOVITA_API_KEY=<YOUR_API_KEY>
```

```python
from novita_sandbox.code_interpreter import Sandbox

sandbox = Sandbox.create()
execution = sandbox.run_code("print('hello world')")
print(execution.logs)
sandbox.kill()
```

Generate JavaScript/TypeScript equivalents when the user is working in Node.js.

### CLI Baseline

Check Node.js and install or update the CLI:

```bash
if ! command -v node >/dev/null 2>&1; then
  echo "Install Node.js first"
elif ! command -v novita-sandbox-cli >/dev/null 2>&1; then
  npm install -g novita-sandbox-cli@beta
else
  novita-sandbox-cli --version
fi
```

Authenticate when needed:

```bash
novita-sandbox-cli auth info || novita-sandbox-cli auth login
```

### CLI Workflows

```bash
# Template
novita-sandbox-cli template init
novita-sandbox-cli template build -n <TEMPLATE_NAME>
novita-sandbox-cli template list

# Sandbox lifecycle. Use --detach inside AI agents; interactive terminals usually fail there.
novita-sandbox-cli sandbox create <TEMPLATE_ID> --detach
novita-sandbox-cli sandbox list
novita-sandbox-cli sandbox logs <SANDBOX_ID> -f
novita-sandbox-cli sandbox metrics <SANDBOX_ID> -f
novita-sandbox-cli sandbox clone <SANDBOX_ID> --count <N>
novita-sandbox-cli sandbox commit <SANDBOX_ID> --alias <ALIAS>
novita-sandbox-cli sandbox kill <SANDBOX_ID>

# Deploy and invoke an agent. Pass env vars explicitly; sandbox processes do not inherit local shell env.
novita-sandbox-cli agent configure -n <AGENT_NAME> -e <ENTRYPOINT>
novita-sandbox-cli agent launch
novita-sandbox-cli agent invoke '{"prompt":"hello"}' --stream --env NOVITA_API_KEY=$NOVITA_API_KEY
```

For exact flags, template versioning, E2B compatibility, pricing, and quota behavior, read the Sandbox route in the table above.

## Error Defaults

- `401` / `403`: check key, account status, and `Authorization: Bearer ...`.
- `404` / model not found: verify exact model ID from the live catalog.
- `429`: reduce concurrency, back off, inspect rate limits and account tier.
- Insufficient credits: check billing and balance.
- Long-running media: use async polling or webhooks.
