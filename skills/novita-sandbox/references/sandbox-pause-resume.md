# Pause & resume a sandbox

Pausing preserves the sandbox's filesystem **and** in-memory state (running processes, variables) so you can resume later. Network connections are interrupted while paused. A paused sandbox stays stored until you resume-then-kill it, or kill it while paused.

There is **no `resume()` method** — you resume by **connecting** to the paused sandbox (`novita.sandbox.connect(id)`), which auto-resumes it. The CLI exposes an explicit `resume` verb that wraps connect.

## Manual pause / resume

**Python**
```python
sandbox = novita.sandbox.create()
sandbox.commands.run("echo hello > /tmp/message.txt")
sandbox_id = sandbox.sandbox_id

sandbox.pause()
print("Sandbox paused", sandbox_id)

# Resume by connecting
resumed = novita.sandbox.connect(sandbox_id)
print(resumed.commands.run("cat /tmp/message.txt").stdout)
resumed.kill()
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create()
await sandbox.commands.run('echo hello > /tmp/message.txt')
const sandboxId = sandbox.sandboxId

await sandbox.pause()
console.log('Sandbox paused', sandboxId)

// Resume by connecting
const resumed = await novita.sandbox.connect(sandboxId)
console.log((await resumed.commands.run('cat /tmp/message.txt')).stdout)
await resumed.kill()
```

**CLI**
```bash
novita sandbox pause <sandboxID>    # alias: sandbox ps
novita sandbox resume <sandboxID>   # alias: sandbox rs (wraps connect)
```

## Auto-pause on timeout + auto-resume on activity

Use `lifecycle` at creation to pause (instead of kill) when the max-lifetime timeout expires, and optionally auto-resume when activity is detected. `autoResume`/`auto_resume` is only valid with `onTimeout: 'pause'`.

**Python**
```python
sandbox = novita.sandbox.create(
    timeout=10 * 60,          # seconds
    lifecycle={"on_timeout": "pause", "auto_resume": True},
)
sandbox.files.write("/home/user/hello.txt", "hello from a paused sandbox")
sandbox.pause()

content = sandbox.files.read("/home/user/hello.txt")  # access auto-resumes it
print(content)
print("State after read:", sandbox.get_info().state)
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({
  timeoutMs: 10 * 60 * 1000,
  lifecycle: { onTimeout: 'pause', autoResume: true },
})
await sandbox.files.write('/home/user/hello.txt', 'hello from a paused sandbox')
await sandbox.pause()

const content = await sandbox.files.read('/home/user/hello.txt') // access auto-resumes it
console.log(content)
console.log(`State after read: ${(await sandbox.getInfo()).state}`)
```

## Web server / preview pattern

Auto-resume suits preview environments: start a background server and use its host URL. An authorized request to the URL resumes a paused sandbox. Auto-resume does not change the service's access policy; choose public or token-protected access as described in [network access](sandbox-network.md).

```python
sandbox = novita.sandbox.create(
    timeout=5 * 60,
    lifecycle={"on_timeout": "pause", "auto_resume": True},
)
sandbox.commands.run("python3 -m http.server 3000", background=True)
host = sandbox.get_host(3000)
print(f"Preview URL: https://{host}")
```

```typescript
const sandbox = await novita.sandbox.create({
  timeoutMs: 5 * 60 * 1000,
  lifecycle: { onTimeout: 'pause', autoResume: true },
})
await sandbox.commands.run('python3 -m http.server 3000', { background: true })
const host = sandbox.getHost(3000)
console.log(`Preview URL: https://${host}`)
```

Related: [timeout.md](sandbox-timeout.md) · [idle-timeout.md](sandbox-idle-timeout.md) · [connect.md](sandbox-connect.md)


## CLI parameters

### `novita sandbox pause <sandboxID>` (`ps`) and `resume <sandboxID>` (`rs`)

| Parameter | Pause | Resume |
|---|---|---|
| `<sandboxID>` | required | required |
| `--timeout <duration>` | — | optional lifetime after resume |
| `-o, --output`, `-f, --format`, `--json` | supported | supported |

## SDK parameter tables

### `novita.sandbox.pause(id, ...)` / `sandbox.pause(...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox_id` | `sandboxId` | string | Required for namespace call; omit on instance | Sandbox ID, not template name. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

Resume uses **`connect`**, not a separate SDK `resume` function; use the complete [connect parameter table](sandbox-connect.md#sdk-parameter-tables). CLI `pause` and `resume` have their parameter table below.
