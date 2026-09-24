# PTY (interactive terminal)

`sandbox.pty.*` creates interactive pseudo-terminal sessions — for REPLs, debuggers, interactive CLIs, or long-running processes you monitor live. A PTY is identified by its process ID (`pid`). Output is delivered to a callback as raw bytes.

| Operation | JS | Python |
|-----------|----|----|
| Create | `sandbox.pty.create(opts)` | `sandbox.pty.create(size, ...)` |
| Connect | `sandbox.pty.connect(pid, opts?)` | `sandbox.pty.connect(pid, ...)` |
| Send input | `sandbox.pty.sendInput(pid, data)` | `sandbox.pty.send_stdin(pid, data)` |
| Resize | `sandbox.pty.resize(pid, size)` | `sandbox.pty.resize(pid, size)` |
| Kill | `sandbox.pty.kill(pid)` | `sandbox.pty.kill(pid)` |

> Note the input method name differs: **`sendInput` (JS)** vs **`send_stdin` (Python)**. Data is `Uint8Array` (JS) / `bytes` (Python).

## Create

In JS, size is `cols`/`rows` in the options with an `onData` callback for output. In Python, size is a `PtySize(cols=…, rows=…)` and output is delivered via `wait(on_pty=...)`.

**JavaScript / TypeScript**
```typescript
const pty = await sandbox.pty.create({
  cols: 120,
  rows: 30,
  cwd: '/home/user',
  envs: { TERM: 'xterm-256color' },
  onData: (data) => process.stdout.write(new TextDecoder().decode(data)),
})
console.log('PTY pid:', pty.pid)
```

**Python**
```python
from novita_sandbox.core.sandbox.commands.command_handle import PtySize

pty = sandbox.pty.create(PtySize(cols=120, rows=30), cwd="/home/user", envs={"TERM": "xterm-256color"})
print("PTY pid:", pty.pid)
```

Options: `cols`/`rows`, `user`, `cwd`, `envs` (`TERM`/`LANG`/`LC_ALL` defaulted), `timeoutMs`/`timeout` (default 60000ms / 60s; `0` = no limit).

## Send input

Raw bytes, keyed by `pid`.
```typescript
const enc = new TextEncoder()
await sandbox.pty.sendInput(pty.pid, enc.encode('echo hello\n'))
await sandbox.pty.sendInput(pty.pid, enc.encode('exit\n'))
```
```python
sandbox.pty.send_stdin(pty.pid, b"echo hello\n")
sandbox.pty.send_stdin(pty.pid, b"exit\n")
```

## Resize

JS takes `{ cols, rows }`; Python takes a `PtySize`.
```typescript
await sandbox.pty.resize(pty.pid, { cols: 150, rows: 40 })
```
```python
sandbox.pty.resize(pty.pid, PtySize(cols=150, rows=40))
```

## Connect / kill

`connect(pid)` reattaches to a running PTY (find running processes via `sandbox.commands.list()`). `kill(pid)` terminates it with SIGKILL — returns `true`/`false` (found / not found).

## Interactive example (Python)

Python streams output through `wait(on_pty=...)` and returns the result.
```python
output = []
terminal = sandbox.pty.create(PtySize(cols=80, rows=24), envs={"ABC": "123"}, cwd="/")
sandbox.pty.send_stdin(terminal.pid, b"echo $ABC\nexit\n")
result = terminal.wait(on_pty=lambda x: output.append(x.decode("utf-8", errors="replace")))
print("exit code:", result.exit_code)
print("".join(output))
```

Related: [run-command.md](sandbox-run-command.md) · [tools-log-streaming.md](tools-log-streaming.md)

## SDK parameter tables

### `sandbox.pty.create(size, ...)` / `pty.create(opts)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `size.cols`, `size.rows` | `opts.cols`, `opts.rows` | integers | Required | Terminal columns and rows. Python passes PtySize as first argument. |
| — | `opts.onData` | callback(Uint8Array) | Required in JS | Raw PTY output; Python sync uses handle.wait(on_pty=...). |
| `envs` | `envs` | string map | Empty | Per-command environment overrides. |
| `user` | `user` | string | Template default user | OS user for this operation. |
| `cwd` | `cwd` | string | User home | Working directory inside sandbox. |
| `timeout` | `timeoutMs` | number | 60 s / 60000 ms | Command/stream deadline; `0` disables. Not sandbox lifetime. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `sandbox.pty.connect(pid, ...)` / `pty.connect(pid, opts)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `pid` | `pid` | integer | Required | Running process ID. |
| — | `opts.onData` | callback(Uint8Array) | Required in JS | Raw terminal output. |
| `timeout` | `timeoutMs` | number | 60 s / 60000 ms | Output-stream deadline; `0` disables. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `sandbox.pty.send_stdin(pid, data, ...)` / `sendInput(pid, data, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `pid` | `pid` | integer | Required | Running process ID. |
| `data` | `data` | bytes / Uint8Array | Required | Raw bytes written to terminal; include newline to submit a shell command. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `sandbox.pty.resize(pid, size, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `pid` | `pid` | integer | Required | Running process ID. |
| `size` | `size` | PtySize / object | Required | Both integer `cols` and `rows` required. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `sandbox.pty.kill(pid, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `pid` | `pid` | integer | Required | Running process ID. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |
