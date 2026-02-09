# Integrations Guide

Use this file as the integrations router. Open exactly one category file based on user intent.

Last verified: 2026-02-09

## Universal Setup (All Integrations)

- **Base URL**: `https://api.novita.ai/openai`
- **API Key**: Get from https://novita.ai/settings/key-management
- **Model**: Use Novita model names (example: `deepseek/deepseek-r1`)

## Category Map

- Frameworks and SDKs: [integrations-frameworks.md](integrations-frameworks.md)
- Clients and platforms: [integrations-clients.md](integrations-clients.md)
- Observability, agents, and training: [integrations-observability-agents.md](integrations-observability-agents.md)

## Tool-to-Category Map

- `LangChain`, `LlamaIndex`, `OpenAI Agents SDK` -> `integrations-frameworks.md`
- `Cursor`, `Continue`, `Claude Code`, `Dify`, `LobeChat` -> `integrations-clients.md`
- `LiteLLM`, `Portkey`, `Langfuse`, `Browser Use`, `Skyvern`, `Axolotl` -> `integrations-observability-agents.md`

## Full Integration Docs

For detailed guides: https://novita.ai/docs/guides/langchain
