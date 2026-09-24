# Long-running sandboxes

By default a sandbox's `timeout` is effective for **at most 1 hour** — a larger value is capped. Long-running mode lifts that cap so `timeout` can exceed an hour, for persistent services, long-running agent jobs, and background workers.

It is not a separate API: long-running is a **metadata marker** set at creation. Key `long_running`, value the string `"true"`.

`long_running` works **together with** `timeout` — set the timeout you actually need. Setting the marker without a `timeout` still leaves the sandbox on the 5-minute default.

> **Units:** Python `timeout` is **seconds**; JS `timeoutMs` is **milliseconds**.

## Basic

**Python**
```python
sandbox = novita.sandbox.create(
    metadata={"long_running": "true"},
    timeout=86_400,            # 24 hours
)
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({
  metadata: { long_running: 'true' },
  timeoutMs: 86_400_000, // 24 hours
})
```

**CLI**
```bash
# --long-running writes long_running=true to the metadata
novita sandbox create base --long-running --timeout 24h -d
```

## A 7-day sandbox

**Python**
```python
sandbox = novita.sandbox.create(
    metadata={"long_running": "true"},
    timeout=7 * 24 * 60 * 60,   # 604_800 seconds
)
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({
  metadata: { long_running: 'true' },
  timeoutMs: 7 * 24 * 60 * 60 * 1000, // 604_800_000
})
```

**CLI**
```bash
novita sandbox create base --long-running --timeout 168h -d
```

## Scope and inheritance

| Operation | Behavior |
|-----------|----------|
| `create` | The only operation that accepts the marker. |
| `resume` (including auto-resume) | A sandbox created this way keeps the behavior after being resumed. |
| `clone` | Inherits the marker. |
| `reset` | The sandbox keeps it while it continues running. |

## Combine with idle timeout

Long-running mode does **not** disable [idle timeout](sandbox-idle-timeout.md). By default the sandbox is killed (or paused, with `auto_pause`) when no client is connected for `idle_timeout` seconds — even if its `timeout` is still days away. Both keys live in the same `metadata` object, so set them together.

**Python**
```python
sandbox = novita.sandbox.create(
    metadata={
        "long_running": "true",
        "idle_timeout": "1800",   # 30 minutes of inactivity still ends it
    },
    timeout=604_800,              # 7 days
)
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({
  metadata: { long_running: 'true', idle_timeout: '1800' },
  timeoutMs: 604_800_000,
})
```

**CLI**
```bash
novita sandbox create base --long-running --idle-timeout 1800 --timeout 168h -d
```

Omit `idle_timeout` (or set it to `"0"`) to let the sandbox run until its `timeout`.

## Notes

- **Account-tier ceiling still applies.** `long_running` removes the 1-hour cap, but how far beyond it you can go depends on your plan's maximum session duration — see <https://docs.novita.ai/guides/sandbox-quota-limit>. Check what your account allows before requesting a multi-day timeout.
- **The marker is a string.** `long_running: "true"` (Python `"true"`, JS `'true'`) — not a boolean. In the CLI the `--long-running` flag writes the metadata key for you, and it wins over an explicit `--metadata long_running=...` passed alongside it.

Related: [timeout.md](sandbox-timeout.md) · [idle-timeout.md](sandbox-idle-timeout.md) · [create.md](sandbox-create.md) · [pause-resume.md](sandbox-pause-resume.md)

## SDK parameter table

| Python / JS parameter | Type | Required / default | Purpose |
|---|---|---|---|
| `metadata["long_running"]` | string | unset | Set to `"true"` to request long-running lifetime limits. |
| `timeout` / `timeoutMs` | number | 300 s / 300000 ms | Maximum lifetime; plan limits still apply. |
| `metadata["idle_timeout"]` | string seconds | unset | Independent inactivity timeout; it still applies in long-running mode. |
