# Create a sandbox

Entry point: `novita.sandbox.create(...)`. Returns a sandbox object. With no arguments it uses the `base` template.

## Basic

**Python**
```python
from novita_sandbox import Novita

novita = Novita()
sandbox = novita.sandbox.create()
print("Sandbox ID:", sandbox.sandbox_id)

sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
import { Novita } from 'novita-sandbox'

const novita = new Novita()
const sandbox = await novita.sandbox.create()
console.log('Sandbox ID:', sandbox.sandboxId)

await sandbox.kill()
```

**CLI**
```bash
# Create from the base template and connect a terminal (alias: sandbox cr)
novita sandbox create base

# Detached (no terminal): prints the new sandbox ID
novita sandbox create base -d
```

## From a template

Pass the template name or ID as the first argument.

**Python**
```python
sandbox = novita.sandbox.create(
    "my-python-app",          # template name or ID
    timeout=300,               # seconds, optional (max lifetime)
    metadata={"env": "demo"},
    envs={"KEY": "value"},
)
result = sandbox.commands.run("python3 --version")
print(result.stdout)
sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create('my-python-app', {
  timeoutMs: 300_000,        // milliseconds, optional (max lifetime)
  metadata: { env: 'demo' },
  envs: { KEY: 'value' },
})
const result = await sandbox.commands.run('python3 --version')
console.log(result.stdout)
await sandbox.kill()
```

**CLI**
```bash
novita sandbox create <template>
novita sandbox create <template> -d   # detached, prints sandbox ID

# Keep it alive past the 1-hour timeout cap (writes long_running=true to metadata)
novita sandbox create <template> --long-running --timeout 24h -d
```

> **Time units:** Python `timeout` is in **seconds**; JS `timeoutMs` is in **milliseconds**.

## Automatic cleanup (Python context manager)

Prefer this when the sandbox is scoped to a block of work — it is killed automatically.

```python
from novita_sandbox import Novita

novita = Novita()

with novita.sandbox.create("my-python-app") as sandbox:
    print(sandbox.commands.run("echo hello").stdout)
# Automatically killed when leaving the with block.
```

## Environment variables

Set env vars at creation; they are available to every command in the sandbox. You can also override/append per command (see run-command.md).

**Python**
```python
sandbox = novita.sandbox.create(
    "my-python-app",
    envs={"API_HOST": "https://api.example.com", "LOG_LEVEL": "debug"},
)
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create('my-python-app', {
  envs: { API_HOST: 'https://api.example.com', LOG_LEVEL: 'debug' },
})
```

## From a snapshot

To start from a previously captured snapshot, pass the snapshot ID where you would pass a template — `novita.sandbox.create(snapshotId)`. The new sandbox starts from the captured filesystem and memory state.

## Key options

| Option (Python / JS) | Description |
|----------------------|-------------|
| first arg (`template` / template) | Template name or ID, or a snapshot ID. Defaults to `base`. |
| `timeout` / `timeoutMs` | Max lifetime (seconds / milliseconds). Capped at 1 hour unless `long_running` is set; see timeout.md and long-running.md. |
| `metadata` | Arbitrary key/value labels; filterable in `list`. Also how `idle_timeout` and `long_running` are configured. |
| `envs` | Environment variables inside the sandbox. |
| `secret_envs` / `secretEnvs` | Env var name → stored Secret name; substitutes only in allowed HTTPS header values. See [secret.md](secret.md). |
| `volume_mounts` / `volumeMounts` | Mount path → existing Volume instance or volume **name** (not ID). See [volume.md](volume.md#mount-at-sandbox-creation) for creation-time mounts and persistent reuse. |
| `secure` | Controller authentication; defaults to enabled in the documented v2 flow. See [secured access](sandbox-secured-access.md). |
| `allow_internet_access` / `allowInternetAccess` | Outbound internet access (default enabled). |
| `network` | Egress allow/deny lists, service public access, and forwarded Host mask; see [network access](sandbox-network.md) for Python/JS field names. |
| `lifecycle` | Behavior on timeout (`pause`/`kill`) + auto-resume. See timeout.md. |

Related: [run-command.md](sandbox-run-command.md) · [timeout.md](sandbox-timeout.md) · [long-running.md](sandbox-long-running.md) · [idle-timeout.md](sandbox-idle-timeout.md) · [kill.md](sandbox-kill.md)


## CLI parameters

### `novita sandbox create [template]` (`cr`)

| Parameter | Required / default | Purpose |
|---|---|---|
| `[template]` | `base` | Template or snapshot ID/name. |
| `--idle-timeout <duration>` | unset | Store idle timeout in metadata as seconds (the CLI preserves the supplied duration string). |
| `--long-running` | false | Store `long_running=true` metadata marker. |
| `--timeout <duration>` | SDK default 5m | Sandbox lifetime; duration accepts `ms`, `s`, `m`, `h`, unitless seconds. |
| `--env <key=value>` | repeatable | Runtime environment variable. |
| `--metadata <key=value>` | repeatable | Runtime metadata label. |
| `--secret-env <env=secret>` | repeatable | Map env name to stored Secret name. |
| `--volume-mount <path=volume>` | repeatable | Mount existing volume **name** at an absolute sandbox path. |
| `--secure` / `--no-secure` | modern default secure | Controller authentication toggle. |
| `--no-internet` | false | Disable outbound internet access. |
| `--allow-out <cidrs>` | repeatable, comma-separated | Outbound allow list. |
| `--deny-out <cidrs>` | repeatable, comma-separated | Outbound deny list. |
| `--public-traffic` | false | Allow service URLs without traffic token. |
| `--on-timeout <kill\|pause>` | `kill` | Lifecycle action at timeout. |
| `--auto-resume` | false | Resume a paused sandbox on activity; valid only with `--on-timeout pause`. |
| `--node-id <node-id>` | unset | Schedule on a specific node. |
| `--snapshot <snapshot-id>` | unset | Create from snapshot instead of template. |
| `-d, --detach` | false | Do not attach terminal; print sandbox ID. |
| `-o, --output`, `-f, --format`, `--json` | pretty / deprecated | Output wrappers for create result. |

Also supports shared `--path`, `--config`, and connection options.

## SDK parameter tables

### `novita.sandbox.create(template?, ...)`

JS: `create(template, opts?)` or `create(opts?)`; Python: `create(template=None, ..., **opts)`. The JS `opts` field names below belong to that object.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `template` | `template` | string | `base`; `mcp-gateway` with MCP | Template name/ID or snapshot ID. JS also allows `opts.template`; mutually exclusive with `image`. |
| `image` | `image` | string | Unset | OCI image converted to a reusable template before creation; current-source extension. |
| `build` | `build` | object | Unset | Image-build settings below; used only with `image`. |
| `timeout` | `timeoutMs` | integer | 300 s / 300000 ms | Sandbox lifetime; see [timeout](sandbox-timeout.md) and plan/long-running limits. |
| `metadata` | `metadata` | string map | Empty | Labels; includes string `idle_timeout` and `long_running` markers. |
| `envs` | `envs` | string map | Empty | Sandbox environment variables; per-command envs can override. |
| `secure` | `secure` | boolean | true on modern regions; legacy differs | Controller token authentication, separate from service URL visibility. |
| `allow_internet_access` | `allowInternetAccess` | boolean | true | Allow outbound internet; false adds deny-all IPv4 egress. |
| `network` | `network` | object | Unset | [Network fields](sandbox-network.md#sdk-parameter-tables), including egress and public traffic. |
| `lifecycle` | `lifecycle` | object | Kill on timeout | `on_timeout` / `onTimeout`: required when providing lifecycle, `kill` or `pause`; `auto_resume` / `autoResume`: false, valid only with pause. |
| `secret_envs` | `secretEnvs` | string map | Unset | Environment name → stored secret name. Keys cannot overlap `envs`. |
| `volume_mounts` | `volumeMounts` | map of Volume or string | Unset | Absolute mount path → Volume object or volume **name**, not ID. |
| `node_id` | `nodeId` | string | Unset | Schedule on a particular node. |
| `mcp` | `mcp` | McpServer config | Unset | MCP server configuration; server-specific fields depend on chosen server. |
| `auto_pause` | — (`betaCreate` only) | boolean | false; deprecated | Use `lifecycle` in new code; JS regular create does not declare `autoPause`. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `create(..., build=...)` / `create({ image, build })` fields

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `registry` | `registry` | object | Unset | Both `username` and `password` strings required together for private registry authentication. |
| `cmd` | `cmd` | string | Image command | Custom startup command; pair with ready command. |
| `ready_cmd` | `readyCmd` | string | Unset | Readiness shell command. |
| `cpu_count` | `cpuCount` | integer | 2 | Template vCPU count. |
| `memory_mb` | `memoryMB` | integer | 1024 | Template memory in MB. |
| `patch_cmd` | `patchCmd` | string | Unset | Preboot patch for Debian image provisioning; ignored for dind/from-template. |
| `no_cache` | `noCache` | boolean | false | Alias for skipping template build cache. |
| `skip_cache` | `skipCache` | boolean | false | Skip cache; prefer using just one of skip/no-cache. |
| `tags` | `tags` | string array | Unset | Tags for generated template. |
| `on_build_logs` | `onBuildLogs` | callback | Default logger when enabled | Receives build log entries. |
| `build_logs` | `buildLogs` | boolean | true | Enable default build logger when callback omitted. |
| — | `timeoutMs` | number | Optional | JS template-build completion deadline in milliseconds; Python image build does not declare this field. |
