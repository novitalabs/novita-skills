# Novita Sandbox CLI — Full Command Reference

## auth

### `auth login`
Log in via browser OAuth. Stores credentials locally.

### `auth logout`
Delete stored credentials.

### `auth info`
Show current user email, team name, and team ID.

### `auth configure`
Interactive prompt to switch between available teams.

---

## template (alias: tpl)

### `template build [template-id]` (alias: bd)
Build sandbox template from Dockerfile.

| Option | Description | Default |
|--------|-------------|---------|
| `-p, --path <path>` | Root directory | `.` |
| `-d, --dockerfile <file>` | Path to Dockerfile | auto-detect |
| `-n, --name <name>` | Template name (lowercase, letters/numbers/dashes/underscores) | — |
| `-c, --cmd <command>` | Start command for sandbox | — |
| `--ready-cmd <command>` | Readiness check (must exit 0) | — |
| `-i, --image <image>` | Use pre-built image instead of Dockerfile | — |
| `-u, --username <user>` | Registry username | — |
| `-w, --password <pass>` | Registry password | — |
| `--team <team-id>` | Team ID | — |
| `--config <file>` | Config file path | — |
| `--cpu-count <n>` | Number of CPUs | `2` |
| `--memory-mb <n>` | Memory in MB (must be even) | `512` |
| `--build-arg <K=V...>` | Docker build arguments | — |
| `--no-cache` | Skip build cache | — |

If `[template-id]` is provided, rebuilds that template. Otherwise creates a new one.

### `template list` (alias: ls)

| Option | Description | Default |
|--------|-------------|---------|
| `--team <team-id>` | Filter by team | — |
| `-ty, --type <type>` | `template_build` or `snapshot_template` | `template_build` |
| `-p, --page <n>` | Page number (1-based) | `1` |
| `-l, --limit <n>` | Items per page | `10` |

### `template init` (alias: it)
Create starter `novita.Dockerfile` in current or specified directory.

| Option | Description | Default |
|--------|-------------|---------|
| `-p, --path <path>` | Root directory | `.` |

### `template delete [template-id]` (alias: dl)

| Option | Description | Default |
|--------|-------------|---------|
| `-p, --path <path>` | Root directory | — |
| `--config <file>` | Config file path | — |
| `-s, --select` | Interactive selection mode | — |
| `--team <team-id>` | Team ID | — |
| `-y, --yes` | Skip confirmation | — |

### `template publish [template-id]` (alias: pb)
Make template public. Same options as `delete`.

### `template unpublish [template-id]` (alias: upb)
Make template private. Same options as `delete`.

### `template version [template-id]` (alias: vn)
List all builds or rollback to a specific version.

| Option | Description | Default |
|--------|-------------|---------|
| `-p, --path <path>` | Root directory | — |
| `--config <file>` | Config file path | — |
| `-r, --rollback <build-id>` | Rollback to specific build | — |

---

## sandbox (alias: sbx)

### `sandbox create [template-id]` (alias: cr)
Create sandbox and connect terminal.

| Option | Description | Default |
|--------|-------------|---------|
| `-p, --path <path>` | Root directory | — |
| `--config <file>` | Config file path | — |

Uses `novita.toml` if template ID not specified.

### `sandbox list` (alias: ls)

| Option | Description | Default |
|--------|-------------|---------|
| `-s, --state <states>` | Filter by state (comma-separated: running, paused) | `running` |
| `-m, --metadata <k=v>` | Filter by metadata | — |
| `-l, --limit <n>` | Max results | — |

### `sandbox connect <sandboxID>` (alias: cn)

| Option | Description | Default |
|--------|-------------|---------|
| `--timeout <seconds>` | Connection timeout | `300` |

### `sandbox kill [sandboxID]` (alias: kl)

| Option | Description |
|--------|-------------|
| `-a, --all` | Kill all running sandboxes |

Mutually exclusive: specify sandbox ID or use `--all`.

### `sandbox logs <sandboxID>` (alias: lg)

| Option | Description | Default |
|--------|-------------|---------|
| `--level <level>` | DEBUG, INFO, WARN, ERROR | `INFO` |
| `-f, --follow` | Stream logs | — |
| `--format <fmt>` | `pretty` or `json` | `pretty` |
| `--loggers [names]` | Filter by logger (comma-separated) | — |

### `sandbox metrics <sandboxID>` (alias: mt)

| Option | Description | Default |
|--------|-------------|---------|
| `-f, --follow` | Stream metrics | — |
| `--format <fmt>` | `pretty` or `json` | `pretty` |

Reports CPU, memory, and disk usage.

### `sandbox clone <sandboxID>` (alias: cl)

| Option | Description | Default |
|--------|-------------|---------|
| `-c, --count <n>` | Number of clones | `1` |
| `-t, --timeout <seconds>` | Timeout for clones | inherits parent |
| `-n, --nodeid <id>` | Schedule on specific node | — |
| `-s, --strict` | Require exact count or fail | — |

### `sandbox commit <sandboxID>` (alias: cm)
Create snapshot template from current sandbox state.

| Option | Description |
|--------|-------------|
| `-a, --alias <alias>` | Alias for created template |

---

## agent

### `agent configure`
Set up agent project configuration, creates Dockerfile and docker-ignore.

| Option | Description | Default |
|--------|-------------|---------|
| `-n, --name <name>` | Agent name | auto-detect |
| `-e, --entrypoint <file>` | Entry point file | auto-detect or `app.py` |
| `--agent-version <ver>` | Agent version | `1.0.0` |
| `-a, --author <email>` | Author email | from env or prompt |
| `-rf, --requirements-file <file>` | Dependency file path | — |
| `--no-interactive` | Skip interactive prompts | — |
| `--force` | Force overwrite config | — |
| `--verbose` | Verbose output | — |

### `agent launch` (alias: deploy)
Build and deploy agent to Novita Sandbox.

| Option | Description | Default |
|--------|-------------|---------|
| `--timeout <seconds>` | Deployment timeout | `300` |
| `--no-cache` | Disable build cache | — |
| `--dry-run` | Dry run without deployment | — |
| `--update-existing` | Update existing template | — |
| `--verbose` | Verbose output | — |

### `agent invoke <payload>`
Invoke deployed agent with JSON payload or prompt text.

| Option | Description | Default |
|--------|-------------|---------|
| `--agentId <id>` | Agent ID (`agent_name-template_id`) | — |
| `--stream` | Enable streaming response | — |
| `--timeout <seconds>` | Request timeout | `60` |
| `--env <key=value>` | Environment variables (repeatable) | — |
| `--verbose` | Verbose output | — |
