# Connect to a running sandbox

Reconnect to an existing sandbox by its ID — useful for reusing a sandbox across serverless invocations, restoring a session, or resuming long-running work. Get the ID from `novita.sandbox.list()`, then `novita.sandbox.connect(id)`.

**Python**
```python
from novita_sandbox import Novita, SandboxQuery, SandboxState

novita = Novita()

# Find a running sandbox's ID
paginator = novita.sandbox.list(query=SandboxQuery(state=[SandboxState.RUNNING]))
running = paginator.next_items()
if not running:
    raise Exception("No running sandboxes found")
sandbox_id = running[0].sandbox_id

# Connect and use it as usual
sandbox = novita.sandbox.connect(sandbox_id)
print("connected to sandbox:", sandbox.sandbox_id)
print(sandbox.commands.run("echo hi").stdout)
```

**JavaScript / TypeScript**
```typescript
import { Novita, SandboxState } from 'novita-sandbox'

const novita = new Novita()

// Find a running sandbox's ID
const paginator = await novita.sandbox.list({ query: { state: [SandboxState.RUNNING] } })
const running = await paginator.nextItems()
if (running.length === 0) {
  throw new Error('No running sandboxes found')
}
const sandboxId = running[0].sandboxId

// Connect and use it as usual
const sandbox = await novita.sandbox.connect(sandboxId)
console.log('connected to sandbox:', sandbox.sandboxId)
console.log((await sandbox.commands.run('echo hi')).stdout)
```

**CLI**
```bash
# Attach an interactive terminal to a running sandbox (alias: sandbox cn)
novita sandbox connect <sandboxID>
```

> Connecting to a paused sandbox resumes it. See [pause-resume.md](sandbox-pause-resume.md).

Related: [list.md](sandbox-list.md) · [run-command.md](sandbox-run-command.md)


## CLI parameters

### `novita sandbox connect <sandboxID>` (`cn`)

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Sandbox to attach to. |
| `--timeout <duration>` | SDK default | Lifetime applied when connecting. |

This command has no output wrapper; it opens the remote terminal.

## SDK parameter tables

### `novita.sandbox.connect(sandbox_id, ...)` / `connect(sandboxId, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox_id` | `sandboxId` | string | Required for namespace call; omit on instance | Sandbox ID, not template name. |
| `timeout` | `timeoutMs` | integer | 300 s / 300000 ms | Lifetime after connect/resume. A running sandbox is extended only if requested timeout is longer. |
| `secure` | `secure` | boolean | Unset | Controller access setting; modern secured flow described in [secured access](sandbox-secured-access.md). |
| `allow_public_traffic` | `allowPublicTraffic` | boolean | Unset | Update public service URL access. |
| `network` | `network` | object | Unset; deprecated | Legacy connection-time network configuration; prefer `allow_public_traffic` / `allowPublicTraffic` for visibility, `set_network` / `setNetwork` for egress. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |
