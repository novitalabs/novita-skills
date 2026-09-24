# CLI reference

The `novita` CLI covers auth, sandbox, template, snapshot, secret, and volume operations. Every command reference keeps its positional arguments, flags, defaults, units, output options, and mutual exclusions beside its examples. Install with `npm i -g novita-sandbox-cli`. Commands that register `--output <format>` (`-o`) accept `pretty` (default), `json`, or `yaml`. The old `--format` and `--json` are deprecated aliases for `--output`. Sandbox and template commands are shown inline in the module references (create.md, kill.md, list.md, template-*.md, …); this file documents the **auth** command group and gives a command index.

## CLI parameter conventions

Every command also accepts `-h, --help`. Global connection options may be placed on the command line and are inherited by subcommands.

| Option | Type / default | Purpose |
|---|---|---|
| `--api-key <api-key>` | string; `NOVITA_API_KEY` fallback | API-key authentication. `auth login` also accepts this as a login source. |
| `--api-url <api-url>` | URL; derived from domain | API endpoint override; CLI adds `https://` when omitted. |
| `--domain <domain>` | string; `NOVITA_DOMAIN` or `us-phx-1.sandbox.novita.ai` | Region / sandbox domain. |
| `--request-timeout <duration>` | duration; SDK default | HTTP request deadline. Suffix `ms`, `s`, `m`, or `h`; unitless values mean seconds; `0` disables. |
| `-o, --output <format>` | `pretty` | Structured output: `pretty`, `json`, or `yaml`; supported only by commands that list it in their local table. |
| `-f, --format <format>` | deprecated alias | Same values as `--output` where registered; some commands use `-f` for another option. |
| `--json` | deprecated alias for JSON | Supported only by commands that list it in their local table. |
| `-p, --path <path>` | current directory | Root directory for template/config commands. |
| `--config <novita-toml>` | discovers `./novita.toml` | Config file for legacy template commands. |
| `-s, --select` | false | Interactive template picker; single or multiple selection depends on command. |
| `-t, --team <team-id>` | selected team | Team associated with the operation. |

Output flags are command-specific; passing an option absent from a command's local table is an unknown-option error.

## Authentication (`auth`)

Credentials are stored locally at `~/.novita/config.json`.

```bash
novita auth login        # browser-based sign-in; captures token, selects default team
novita auth logout       # sign out (deletes ~/.novita/config.json)
novita auth info         # show current user (email) and selected team
novita auth configure    # switch the active team for the current session
```

- `login` opens a browser authorization page; if already logged in it reports the current session. To sign in as a different user, `logout` first.
- `configure` requires being logged in; it lists your teams and saves the chosen team's name/ID/API key.

### `novita auth login`

| Parameter | Required / default | Purpose |
|---|---|---|
| `--api-key <key>` | exactly one key source; optional | Login with a literal API key. |
| `--api-key-env <name>` | mutually exclusive | Read the API key from the named environment variable. |
| `--api-key-stdin` | mutually exclusive | Read a trimmed API key from stdin. |

With no key source, the CLI uses an existing config, headless `NOVITA_API_KEY`, or browser login.

| Command | Parameters | Purpose |
|---|---|---|
| `novita auth logout` | none | Delete the local CLI config and sign out. |
| `novita auth info` | none | Show the current user and selected team. |
| `novita auth configure` | none; interactive prompt | Select and save the active team. |

## Additional sandbox/template commands

The command examples and parameter tables live with their resource references: [network](sandbox-network.md), [hotplug memory](sandbox-timeout.md), and [template management](template-list-delete.md).

## Command index

| Area | Command | Reference |
|------|---------|-----------|
| Auth | `auth login/logout/info/configure` | above |
| Region | `NOVITA_DOMAIN` (default `us-phx-1`, v2) | [region.md](region.md) |
| Sandbox — create | `sandbox create [template]` (alias `cr`) | [create.md](sandbox-create.md) |
| Sandbox — list | `sandbox list` (alias `ls`) | [list.md](sandbox-list.md) |
| Sandbox — connect (remote shell) | `sandbox connect <id>` (alias `cn`) | [connect.md](sandbox-connect.md) |
| Sandbox — exec | `sandbox exec <id> -- <cmd>` (alias `ex`) | [run-command.md](sandbox-run-command.md) |
| Sandbox — pause/resume | `sandbox pause/resume <id>` | [pause-resume.md](sandbox-pause-resume.md) |
| Sandbox — kill | `sandbox kill <id>` / `-a` | [kill.md](sandbox-kill.md) |
| Sandbox — metrics/events | `sandbox metrics/events <id>` | [info-metrics-events.md](sandbox-info-metrics-events.md) |
| Sandbox — network egress | `sandbox network <id> --allow-out/--deny-out` | [sandbox-network.md](sandbox-network.md) |
| Sandbox — controller authentication | `sandbox create <template> --secure` / `--no-secure` | [sandbox-secured-access.md](sandbox-secured-access.md) |
| Sandbox — hotplug memory | `sandbox hotplug-memory <id> <size-mib>` (alias `hp`) | [sandbox-timeout.md](sandbox-timeout.md) |
| Snapshot | `snapshot create/list/delete` | [snapshot.md](snapshot.md) |
| Secret | `secret create/get/list/update/delete` | [secret.md](secret.md) |
| Volume | `volume create/list/get/delete/mount/unmount` | [volume.md](volume.md) |
| Volume — mount at sandbox creation | `sandbox create <template> --volume-mount /mnt/data=my-data` (repeatable) | [volume.md](volume.md#mount-at-sandbox-creation) |
| Template — build | `template create <name>` (alias `ct`) | [template-build.md](template-build.md) |
| Template — list/delete | `template list` / `template delete` | [template-list-delete.md](template-list-delete.md) |
| Template — publish/unpublish | `template publish/unpublish [template]` | [template-list-delete.md](template-list-delete.md) |
| Template — migrate | `template migrate` | [template-list-delete.md](template-list-delete.md) |
