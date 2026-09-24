# Timeout (maximum lifetime)

Every sandbox has a **maximum lifetime** set by `timeout`. It counts down from creation regardless of activity, and always fires when it expires. Default is **5 minutes**.

`timeout` is effective for **at most 1 hour** — any larger value is capped. To go beyond that (up to your plan's session limit), enable long-running mode at creation; see [long-running.md](sandbox-long-running.md).

> **Timeout vs. idle timeout:** timeout is the hard max lifetime (always fires). Idle timeout only fires when no client is connected for a while — see [idle-timeout.md](sandbox-idle-timeout.md).

> **Units:** Python `timeout` is **seconds**; JS `timeoutMs` is **milliseconds**.

## Set at creation

**Python**
```python
sandbox = novita.sandbox.create(timeout=60)   # 60 seconds
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({ timeoutMs: 60_000 }) // 60 seconds
```

## Update the timeout

Reset how much longer the sandbox should stay alive (can extend or shorten).

**Python**
```python
sandbox.set_timeout(300)   # now 300 seconds from now
```

**JavaScript / TypeScript**
```typescript
await sandbox.setTimeout(300_000) // now 300 seconds from now
```

## Lifecycle: pause or kill on timeout

By default the sandbox is **killed** when the timeout expires. Pass `lifecycle` to pause instead (and optionally auto-resume on later activity). `auto_resume`/`autoResume` is only valid with `on_timeout: "pause"`.

**Python**
```python
sandbox = novita.sandbox.create(
    timeout=300,
    lifecycle={"on_timeout": "pause", "auto_resume": True},
)
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({
  timeoutMs: 300_000,
  lifecycle: { onTimeout: 'pause', autoResume: true },
})
```

| Lifecycle field (Python / JS) | Values | Meaning |
|-------------------------------|--------|---------|
| `on_timeout` / `onTimeout` | `"kill"` (default) or `"pause"` | What happens when the timeout expires. |
| `auto_resume` / `autoResume` | `bool` (default false) | Auto-resume on activity; only with `pause`. |

Related: [pause-resume.md](sandbox-pause-resume.md) · [idle-timeout.md](sandbox-idle-timeout.md) · [long-running.md](sandbox-long-running.md)


## CLI example

```bash
novita sandbox hotplug-memory <sandboxID> <size-mib>  # alias: hp; size is additional MiB
```

## CLI parameters

### `novita sandbox hotplug-memory <sandboxID> <size-mib>` (`hp`, deprecated)

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Target sandbox. |
| `<size-mib>` | required, non-negative integer | Additional hotplug memory in MiB; `0` clears the hotplug amount. It is an increment, not total memory. |

Current CLI also contains lower-level `attach-memory` / `detach-memory` commands; they are not part of this skill's documented surface.

## SDK parameter tables

### `set_timeout(timeout, ...)` / `setTimeout(timeoutMs, opts?)`

Instance form omits ID. Namespace form: `novita.sandbox.set_timeout(id, timeout, ...)` / `setTimeout(id, timeoutMs, opts?)`. Creation-time lifecycle fields are listed in [create](sandbox-create.md#sdk-parameter-tables).

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox_id` | `sandboxId` | string | Required for namespace call; omit on instance | Sandbox ID, not template name. |
| `timeout` | `timeoutMs` | integer | Required | Remaining lifetime from now, Python seconds / JS milliseconds; can shorten or extend. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

## Hot-plug memory parameter table

| Python / JS method | Parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox.resize` / `sandbox.resize` | `memory_mib` / `memoryMiB` | positive integer MiB | required | Add memory to a running sandbox. The value is an increment; it is not the target total. |
