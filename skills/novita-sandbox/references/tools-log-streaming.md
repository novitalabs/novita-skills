# Log streaming

A command's `stdout`/`stderr` can be consumed two ways: **streamed in real time** through callbacks (for long-running / background commands), or **retrieved in full** after it finishes (for short, predictable commands). This is the streaming side of `sandbox.commands.run(...)` — see [run-command.md](sandbox-run-command.md) for the basics.

## Stream with callbacks

Pass `onStdout`/`onStderr` (JS) or `on_stdout`/`on_stderr` (Python foreground) to `commands.run(...)`. For a Python background command, pass callbacks to `handle.wait(...)`; JS keeps callbacks on `run(...)`. Each callback fires as soon as output is produced; stdout and stderr are delivered separately.

**Python**
```python
result = sandbox.commands.run(
    "for i in 1 2 3; do echo out $i; sleep 1; done",
    on_stdout=lambda data: print("OUT:", data, end=""),
    on_stderr=lambda data: print("ERR:", data, end=""),
)
print("exit code:", result.exit_code)
```

**JavaScript / TypeScript**
```typescript
const result = await sandbox.commands.run(
  'for i in 1 2 3; do echo out $i; sleep 1; done',
  {
    onStdout: (data) => process.stdout.write(`OUT: ${data}`),
    onStderr: (data) => process.stderr.write(`ERR: ${data}`),
  },
)
console.log('exit code:', result.exitCode)
```

## Stream a background command

Start with `background: true` / `background=True` to get a `CommandHandle` immediately (without waiting). Attach the same callbacks, do other work, then call `wait()` to block until it finishes and get the `CommandResult`.

**JavaScript / TypeScript**
```typescript
const handle = await sandbox.commands.run('python3 -m http.server 3000', {
  background: true,
  onStdout: (data) => process.stdout.write(data),
  onStderr: (data) => process.stderr.write(data),
})

// ... continue with other work ...

const result = await handle.wait()  // blocks until the command finishes
console.log('exit code:', result.exitCode)
```

**Python**
```python
handle = sandbox.commands.run(
    "python3 -m http.server 3000",
    background=True,
)

# ... continue with other work ...

result = handle.wait(
    on_stdout=lambda data: print(data, end=""),
    on_stderr=lambda data: print(data, end=""),
)  # blocks until the command finishes
print("exit code:", result.exit_code)
```

Related: [run-command.md](sandbox-run-command.md) · [tools-pty.md](tools-pty.md)

## SDK parameter table

| Parameter | Type | Required / default | Purpose |
|---|---|---|---|
| `cmd` | string | required | Command to execute. |
| `background` | boolean | false | Return a handle immediately. |
| `on_stdout` / `onStdout` | callback | optional | Receive stdout chunks; for Python background commands pass to `handle.wait()`. |
| `on_stderr` / `onStderr` | callback | optional | Receive stderr chunks; for Python background commands pass to `handle.wait()`. |
| `timeout` / `timeoutMs` | number | 60 s / 60000 ms | Command deadline; `0` disables. |
| `request_timeout` / `requestTimeoutMs` | number | inherited | HTTP/RPC request deadline. |
