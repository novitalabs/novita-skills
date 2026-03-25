# Novita Skills

Official Novita Skills repository.
This repo hosts reusable skills (`SKILL.md`) for agent ecosystems that support skill-based workflows.

## Quick Start

```bash
npx skills add novitalabs/novita-skills --skill novita-ai
```

This installs the **novita-ai** skill — direct API access to all Novita AI services: LLM (OpenAI-compatible), image generation & editing, video generation, audio (TTS/ASR), GPU cloud, and serverless endpoints. Works with Claude Code, Cursor, Codex, GitHub Copilot, and other agent clients.

## Install Other Skills

```bash
npx skills add novitalabs/novita-skills --skill <skill-name>
```

After installation, restart your agent runtime if needed.

## Available Skills

| Skill | Description | Install |
|-------|-------------|---------|
| **novita-ai** | Full Novita AI API — LLM, image, video, audio, GPU cloud, serverless | `npx skills add novitalabs/novita-skills --skill novita-ai` |
| novita-docs | Platform documentation and integration reference | `--skill novita-docs` |
| novita-mailer | Draft and send branded emails via Gmail OAuth | `--skill novita-mailer` |
| novita-sandbox | Agent Sandbox CLI — build templates, manage sandboxes, deploy agents | `--skill novita-sandbox` |


## Contribution Flow

1. Fork this repository and create a branch.
2. Add or update a skill under `skills/<skill-name>/`.
3. Open a PR with use cases, trigger terms, and validation steps.
4. Merge after review approval.
