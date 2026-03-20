---
name: novita-sandbox
version: 1.0.0
description: |
  Novita Agent Sandbox CLI wrapper — build templates, manage sandboxes, and deploy agents via `novita-sandbox-cli`.
  Use when user asks to "create a sandbox", "build a template", "deploy an agent", "list sandboxes",
  "kill sandbox", "sandbox logs", "clone sandbox", "commit sandbox", "template build",
  "novita-sandbox-cli", "novita sandbox", or any Novita Sandbox CLI operation.
keywords:
  - novita
  - sandbox
  - agent sandbox
  - novita-sandbox-cli
  - template build
  - deploy agent
---

# Novita Agent Sandbox CLI

`novita-sandbox-cli` wraps the Novita Agent Sandbox platform. Use it to build templates from Dockerfiles, manage sandbox lifecycles, and deploy agents.

---

## Installation

If this skill is not yet installed locally, `[AGENT]` follow these steps to install it.

### Detect agent platform

```bash
# Claude Code
if [ -d "$HOME/.claude/skills" ]; then
  echo "CLAUDE_CODE"
# Gemini CLI
elif [ -d "$HOME/.gemini/skills" ]; then
  echo "GEMINI_CLI"
# OpenClaw
elif command -v openclaw >/dev/null 2>&1; then
  echo "OPENCLAW"
else
  echo "UNKNOWN"
fi
```

### Install by platform

**Claude Code:**

```bash
SKILL_DIR="$HOME/.claude/skills/novita-sandbox"
mkdir -p "$SKILL_DIR/references"
curl -sL "https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/SKILL.md" \
  -o "$SKILL_DIR/SKILL.md"
curl -sL "https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/references/cli-reference.md" \
  -o "$SKILL_DIR/references/cli-reference.md"
echo "Installed to $SKILL_DIR"
```

**Gemini CLI:**

```bash
SKILL_DIR="$HOME/.gemini/skills/novita-sandbox"
mkdir -p "$SKILL_DIR/references"
curl -sL "https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/SKILL.md" \
  -o "$SKILL_DIR/SKILL.md"
curl -sL "https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/references/cli-reference.md" \
  -o "$SKILL_DIR/references/cli-reference.md"
echo "Installed to $SKILL_DIR"
```

**Other agents / manual install:**

```bash
SKILL_DIR="<your-agent-skills-directory>/novita-sandbox"
mkdir -p "$SKILL_DIR/references"
curl -sL "https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/SKILL.md" \
  -o "$SKILL_DIR/SKILL.md"
curl -sL "https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/references/cli-reference.md" \
  -o "$SKILL_DIR/references/cli-reference.md"
```

### Definition of Done (Installation)

Installation is NOT complete until all of the following are true:

1. SKILL.md is saved to the local skill directory
2. `references/cli-reference.md` is saved alongside it
3. The CLI is installed and up-to-date (Step 0 below passes)
4. Authentication is verified
5. `[AGENT]` sends the user a confirmation message:

```
✅ novita-sandbox skill installed.

What you can do now:
- "create a sandbox" — spin up a sandbox from a template
- "build a template" — build from Dockerfile
- "deploy an agent" — deploy and invoke agents
- "list sandboxes" — see running sandboxes

CLI version: <version>
Docs: https://novita.ai/docs/guides/sandbox-overview
```

---

## Step 0: Ensure CLI is installed and up-to-date

**Run this check every time the skill is triggered.**

```bash
if ! command -v node >/dev/null 2>&1; then
  echo "NO_NODE"
elif ! command -v novita-sandbox-cli >/dev/null 2>&1; then
  echo "NOT_INSTALLED"
else
  _LOCAL=$(novita-sandbox-cli --version)
  _LATEST=$(npm view novita-sandbox-cli@beta version 2>/dev/null)
  if [ -n "$_LATEST" ] && [ "$_LOCAL" != "$_LATEST" ]; then
    echo "OUTDATED local=$_LOCAL latest=$_LATEST"
  else
    echo "OK $_LOCAL"
  fi
fi
```

Act on result:

- **NO_NODE** → Install Node.js first:
  - macOS: `brew install node`
  - Linux: `curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt-get install -y nodejs`
- **NOT_INSTALLED** → `npm install -g novita-sandbox-cli@beta`
- **OUTDATED** → `npm install -g novita-sandbox-cli@beta`
- **OK** → Proceed.

After install or upgrade, verify authentication:

```bash
novita-sandbox-cli auth info 2>&1 || echo "NOT_LOGGED_IN"
```

If NOT_LOGGED_IN, run `novita-sandbox-cli auth login` (opens browser).

Set `NOVITA_API_KEY` environment variable for SDK usage.

## Quick Reference

| Key | Value |
|-----|-------|
| **CLI name** | `novita-sandbox-cli` |
| **Docs** | https://novita.ai/docs/guides/sandbox-overview |
| **Console** | https://novita.ai/console |
| **NPM** | https://www.npmjs.com/package/novita-sandbox-cli |

## Command Overview

```
novita-sandbox-cli
├── auth          # login, logout, info, configure (switch team)
├── template      # build, list, init, delete, publish, unpublish, version
├── sandbox       # create, list, connect, kill, logs, metrics, clone, commit
└── agent         # configure, launch (deploy), invoke
```

## Common Workflows

### 1. Build a Template from Dockerfile

```bash
# Initialize a starter Dockerfile
novita-sandbox-cli template init

# Build and push (auto-detects novita.Dockerfile)
novita-sandbox-cli template build -n my-template

# Rebuild an existing template
novita-sandbox-cli template build <template-id>
```

### 2. Create and Use a Sandbox

```bash
# Create sandbox without connecting terminal (for non-interactive / agent use)
novita-sandbox-cli sandbox create <template-id> --detach

# Create sandbox and connect interactive terminal (TTY required)
novita-sandbox-cli sandbox create <template-id>

# List running sandboxes
novita-sandbox-cli sandbox list

# Connect to an existing sandbox
novita-sandbox-cli sandbox connect <sandbox-id>

# View logs (streaming)
novita-sandbox-cli sandbox logs <sandbox-id> -f

# View metrics (CPU, memory, disk)
novita-sandbox-cli sandbox metrics <sandbox-id> -f

# Kill a sandbox
novita-sandbox-cli sandbox kill <sandbox-id>

# Kill all running sandboxes
novita-sandbox-cli sandbox kill --all
```

**Important:** When running inside an AI agent (Claude Code, Gemini CLI, etc.), always use `--detach` (`-d`) with `sandbox create`. These environments do not have a real TTY, so the interactive terminal will fail. Create with `--detach`, then use `sandbox connect` from a real terminal if needed.

### 3. Clone and Snapshot

```bash
# Clone a sandbox (create identical copies)
novita-sandbox-cli sandbox clone <sandbox-id> --count 3

# Commit sandbox state as a snapshot template
novita-sandbox-cli sandbox commit <sandbox-id> --alias my-snapshot
```

### 4. Deploy an Agent

```bash
# Configure agent project (creates Dockerfile + config)
novita-sandbox-cli agent configure -n my-agent -e app.py

# Deploy to Novita Sandbox
novita-sandbox-cli agent launch

# Invoke deployed agent (pass env vars the sandbox needs)
novita-sandbox-cli agent invoke '{"prompt": "hello"}' --stream --env NOVITA_API_KEY=$NOVITA_API_KEY
```

### 5. Template Management

```bash
# List templates
novita-sandbox-cli template list

# Publish (make public)
novita-sandbox-cli template publish <template-id>

# Unpublish (make private)
novita-sandbox-cli template unpublish <template-id>

# List versions and rollback
novita-sandbox-cli template version <template-id>
novita-sandbox-cli template version <template-id> --rollback <build-id>

# Delete
novita-sandbox-cli template delete <template-id>
```

## Security

- **API Key**: Set `NOVITA_API_KEY` env var for SDK usage. When invoking agents, pass it explicitly with `--env NOVITA_API_KEY=$NOVITA_API_KEY` — sandbox environments do not inherit local env vars. Never commit it to git — use `.env` or your shell profile.
- **Auth tokens**: Stored locally by `novita-sandbox-cli auth login`. Run `auth logout` to revoke.
- **Registry credentials**: `-u`/`-w` flags in `template build` are for private Docker registries. Prefer env vars over CLI flags to avoid leaking secrets in shell history.

## Understanding Output

| Command | Output | Key fields |
|---------|--------|------------|
| `template build` | Build progress → template ID | Template ID (use for `sandbox create`) |
| `template list` | Table of templates | `ID`, `Name`, `Status`, `Type` |
| `sandbox create` | Sandbox ID (with `--detach`) or interactive terminal | Sandbox ID (use for connect/kill/logs) |
| `sandbox list` | Table of running sandboxes | `ID`, `Template`, `State`, `Created` |
| `sandbox logs` | Streaming log lines | Timestamp, level, message |
| `sandbox metrics` | CPU/memory/disk stats | Percentage and absolute values |
| `sandbox clone` | List of new sandbox IDs | One ID per clone |
| `sandbox commit` | New snapshot template ID | Template ID (reusable like build templates) |
| `agent launch` | Build progress → deployment URL | Agent ID (`agent_name-template_id`) |
| `agent invoke` | Agent response (JSON or stream) | Depends on agent implementation |

## Gotchas

- Template names: lowercase letters, numbers, dashes, and underscores only.
- `--memory-mb` must be an even number (default: 512).
- `--cpu-count` default is 2.
- `sandbox create` without `--detach` auto-connects a terminal session — use Ctrl+D or `exit` to detach.
- In non-TTY environments (AI agents, CI/CD), always use `sandbox create --detach`.
- `agent invoke` runs in a fresh sandbox — local environment variables are NOT available. Use `--env KEY=VALUE` to pass them explicitly.
- `agent launch` timeout defaults to 300s; increase with `--timeout` for large images.
- Config is stored in `novita.toml` in the project root after `template build`.

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `Error: not logged in` | No auth token | Run `novita-sandbox-cli auth login` |
| `Error: template not found` | Wrong ID or deleted | Run `template list` to verify; check `--team` flag |
| `Error: sandbox not found` | Sandbox killed or expired | Run `sandbox list` to check; sandboxes auto-expire after timeout |
| `setRawMode is not a function` | Running `sandbox create` without `--detach` in a non-TTY environment | Use `sandbox create <template-id> --detach` |
| `EACCES` on `npm install -g` | No global npm permission | Use `sudo npm install -g` or fix npm prefix (`npm config set prefix ~/.npm-global`) |
| Build timeout | Large image or slow network | Increase `--timeout`; use `--no-cache` to skip stale layers |
| `--memory-mb` validation error | Odd number provided | Use an even number (e.g., 512, 1024, 2048) |
| `connect` hangs | Sandbox still starting | Wait for readiness; check `sandbox logs` for startup errors |
| `agent invoke` returns 404 | Agent not deployed or wrong ID | Verify with `agent launch --dry-run`; check agent ID format: `name-templateId` |

## Full CLI Reference

For complete options on every command, see [cli-reference.md](https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/references/cli-reference.md).

If raw GitHub fetch is unavailable, fall back to local `references/cli-reference.md` in this skill.

---

## Update

To update this skill to the latest version:

```bash
curl -sL "https://raw.githubusercontent.com/novitalabs/novita-skills/main/skills/novita-sandbox/SKILL.md" \
  -o "$(dirname "$0")/SKILL.md" 2>/dev/null || echo "Update manually from https://github.com/novitalabs/novita-skills"
```

Only update when the user explicitly requests it.
