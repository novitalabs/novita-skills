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
| novita-design-skill | Public-safe Novita AI brand design guide for Web, PPT, landing pages, UI concepts, marketing graphics, and design reviews. Includes official logo SVG assets and brand-level references. | `npx skills add novitalabs/novita-skills --skill novita-design-skill` |
| novita-sandbox | Optional deep reference for Agent Sandbox CLI workflows | `--skill novita-sandbox` |

## Novita Design Skill

Use `novita-design-skill` when you need Novita-branded visual work without exposing internal product structure or publishing an internal design system. It covers:

- brand voice and visual direction;
- official Novita logo SVG assets;
- public brand colors and typography direction;
- PPT, landing page, UI concept, diagram, chart, icon, and marketing graphic patterns;
- public-safe guidance that avoids private routes, sidebar structures, domain JSON, exact component specifications, and internal implementation details.

```bash
npx skills add novitalabs/novita-skills --skill novita-design-skill
```


## Contribution Flow

1. Fork this repository and create a branch.
2. Add or update a skill under `skills/<skill-name>/`.
3. Open a PR with use cases, trigger terms, and validation steps.
4. Merge after review approval.
