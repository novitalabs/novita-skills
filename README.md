# Novita Skills

Official Novita Skills repository.
This repo hosts reusable skills (`SKILL.md`) for agent ecosystems that support skill-based workflows.

## Quick Start

```bash
npx skills add novitalabs/novita-skills --skill novita-ai
```

This installs the **novita-ai** skill for Novita AI, the AI-Native Cloud for builders and agents: run models, scale GPUs, and build AI agents. It covers APIs, integrations, GPU, Sandbox, and troubleshooting in one skill without assuming a default model.

## Install Other Skills

```bash
npx skills add novitalabs/novita-skills --skill <skill-name>
```

After installation, restart your agent runtime if needed.

## Available Skills

| Skill | Description | Install |
|-------|-------------|---------|
| **novita-ai** | One Novita skill for models, GPUs, agents, integrations, Sandbox, troubleshooting | `npx skills add novitalabs/novita-skills --skill novita-ai` |
| novita-sandbox | Optional deep reference for Agent Sandbox CLI workflows | `--skill novita-sandbox` |


## Contribution Flow

1. Fork this repository and create a branch.
2. Add or update a skill under `skills/<skill-name>/`.
3. Open a PR with use cases, trigger terms, and validation steps.
4. Merge after review approval.
