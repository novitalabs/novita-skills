# Idle timeout

Automatically stop or pause a sandbox when no active connections are detected for a while. Configured through the **`metadata`** field at creation: key `idle_timeout`, value = seconds **as a string**.

This differs from [timeout.md](sandbox-timeout.md) (the hard max lifetime): idle timeout only fires when the sandbox has been idle (no client connected).

Idle timeout applies even on a [long-running](sandbox-long-running.md) sandbox — a sandbox with a 7-day `timeout` is still stopped after `idle_timeout` seconds of inactivity. Set both keys together when you want both behaviors.

## Basic — auto-kill after inactivity

**Python**
```python
# Killed after 60 seconds of inactivity
sandbox = novita.sandbox.create(metadata={"idle_timeout": "60"})
```

**JavaScript / TypeScript**
```typescript
// Killed after 60 seconds of inactivity
const sandbox = await novita.sandbox.create({ metadata: { idle_timeout: '60' } })
```

## Pause instead of kill

Add `auto_pause` / `autoPause` so the sandbox is paused (resumable) instead of killed.

**Python**
```python
sandbox = novita.sandbox.create(
    metadata={"idle_timeout": "60"},
    auto_pause=True,
)
# After 60s of inactivity, the sandbox is paused.
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({
  metadata: { idle_timeout: '60' },
  autoPause: true,
})
// After 60s of inactivity, the sandbox is paused.
```

## Combine with other metadata

`idle_timeout` is just one metadata key; keep your own alongside it.

**Python**
```python
sandbox = novita.sandbox.create(
    metadata={"idle_timeout": "120", "env": "production", "user_id": "user-123"},
)
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create({
  metadata: { idle_timeout: '120', env: 'production', userId: 'user-123' },
})
```

## Disable

Omit `idle_timeout`, or set it to `"0"` — the sandbox then runs until its maximum lifetime.

```python
sandbox = novita.sandbox.create(metadata={"idle_timeout": "0"})
sandbox2 = novita.sandbox.create()  # or just omit it
```

```typescript
const sandbox = await novita.sandbox.create({ metadata: { idle_timeout: '0' } })
const sandbox2 = await novita.sandbox.create() // or just omit it
```

Related: [timeout.md](sandbox-timeout.md) · [long-running.md](sandbox-long-running.md) · [pause-resume.md](sandbox-pause-resume.md)

## SDK parameter table

| Python / JS parameter | Type | Required / default | Purpose |
|---|---|---|---|
| `metadata["idle_timeout"]` | string seconds | unset | Idle period after which an inactive sandbox is stopped or paused. |
| `auto_pause` / `autoPause` | boolean | false | Pause instead of kill when idle timeout fires; prefer `lifecycle` for the hard timeout. |
