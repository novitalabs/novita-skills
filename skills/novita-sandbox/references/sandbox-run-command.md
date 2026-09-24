# Run commands in a sandbox

Run terminal commands with `sandbox.commands.run(...)`. It returns a result whose `stdout` / `stderr` / `exit_code` (Python) / `exitCode` (JS) hold the output.

## Basic

**Python**
```python
sandbox = novita.sandbox.create()
result = sandbox.commands.run("echo hello")
print(result.stdout)   # hello
sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create()
const result = await sandbox.commands.run('echo hello')
console.log(result.stdout) // hello
await sandbox.kill()
```

**CLI**
```bash
# Execute a command in a running sandbox (alias: sandbox ex)
novita sandbox exec <sandboxID> -- echo "hello"

# Background
novita sandbox exec <sandboxID> -b -- long-running-cmd

# Working dir / user / env
novita sandbox exec <sandboxID> -c /home/user -u root -e KEY=VALUE -- ls -la
```

## Run in the background

For long-running processes (e.g. a server), pass the background flag so the call returns immediately instead of blocking.

**Python**
```python
sandbox.commands.run("python3 -m http.server 3000", background=True)
```

**JavaScript / TypeScript**
```typescript
await sandbox.commands.run('python3 -m http.server 3000', { background: true })
```

## Override environment variables per command

`envs` here applies only to this one command (overrides/appends onto the sandbox env).

**Python**
```python
result = sandbox.commands.run("echo $LOG_LEVEL", envs={"LOG_LEVEL": "info"})
print(result.stdout)   # info
```

**JavaScript / TypeScript**
```typescript
const result = await sandbox.commands.run('echo $LOG_LEVEL', {
  envs: { LOG_LEVEL: 'info' },
})
console.log(result.stdout) // info
```

## Stream output

Pass callbacks to receive output as it is produced, instead of waiting for the command to finish. The result still carries the final exit code.

**Python** — `on_stdout` / `on_stderr`:
```python
result = sandbox.commands.run(
    "for i in 1 2 3; do echo line $i; sleep 1; done",
    on_stdout=lambda data: print("OUT:", data, end=""),
    on_stderr=lambda data: print("ERR:", data, end=""),
)
print("exit code:", result.exit_code)
```

**JavaScript / TypeScript** — `onStdout` / `onStderr`:
```typescript
const result = await sandbox.commands.run(
  'for i in 1 2 3; do echo line $i; sleep 1; done',
  {
    onStdout: (data) => process.stdout.write(`OUT: ${data}`),
    onStderr: (data) => process.stderr.write(`ERR: ${data}`),
  },
)
console.log('exit code:', result.exitCode)
```

## Options

| Option (Python / JS) | Description |
|----------------------|-------------|
| `background` | `True`/`true` to start without blocking; returns a handle instead of a finished result. |
| `envs` | Env vars for this command only. |
| `cwd` | Working directory (defaults to the user's home). |
| `user` | User to run as (defaults to the template's user). |
| `on_stdout` / `onStdout`, `on_stderr` / `onStderr` | Streaming output callbacks. |
| `timeout` / `timeoutMs` | Command timeout — Python seconds (default 60, `0` = unlimited); JS milliseconds. |

Related: [create.md](sandbox-create.md) · [connect.md](sandbox-connect.md)


## CLI parameters

### `novita sandbox exec <sandboxID> <command...>` (`ex`)

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Target sandbox. |
| `<command...>` | required | Shell command and arguments. Put `--` before a command beginning with `-`. |
| `-b, --background` | false | Return immediately with a process handle/result. |
| `-c, --cwd <dir>` | user home | Working directory. |
| `-u, --user <user>` | template default | OS user. |
| `-e, --env <key=value>` | repeatable | Per-command environment override. |

No command-specific timeout or output options are registered.

## SDK parameter tables

### `sandbox.commands.run(cmd, ...)`

JS: `run(cmd, opts?)`; Python: `run(cmd, ...)`. Callbacks are optional. Do not infer extra connection options from the sandbox create table.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `cmd` | `cmd` | string | Required | Shell command to execute. |
| `background` | `background` | boolean | false | Return a CommandHandle instead of waiting for CommandResult. |
| `envs` | `envs` | string map | Empty | Per-command environment overrides. |
| `user` | `user` | string | Template default user | OS user for this operation. |
| `cwd` | `cwd` | string | User home | Working directory inside sandbox. |
| `timeout` | `timeoutMs` | number | 60 s / 60000 ms | Command/stream deadline; `0` disables. Not sandbox lifetime. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |
| `on_stdout` | `onStdout` | callback(string) | Unset | Stdout chunks; Python sync foreground only, background uses handle.wait. |
| `on_stderr` | `onStderr` | callback(string) | Unset | Stderr chunks; Python sync foreground only, background uses handle.wait. |
| `stdin` | `stdin` | boolean | false / Python None | Keep standard input open for send_stdin/sendStdin. |

### `sandbox.commands.list(...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `sandbox.commands.connect(pid, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `pid` | `pid` | integer | Required | Running process ID. |
| `timeout` | `timeoutMs` | number | 60 s / 60000 ms | Deadline for receiving command output; `0` disables. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |
| — | `onStdout` | callback(string) | Unset | JS stdout handler; Python sync passes it to handle.wait. |
| — | `onStderr` | callback(string) | Unset | JS stderr handler; Python sync passes it to handle.wait. |

### `sandbox.commands.send_stdin(pid, data, ...)` / `sendStdin(pid, data, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `pid` | `pid` | integer | Required | Running process ID. |
| `data` | `data` | string | Required | Text to write to command stdin; start command with stdin enabled. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `sandbox.commands.kill(pid, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `pid` | `pid` | integer | Required | Running process ID. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `handle.wait(...)`

JS `handle.wait()` has **no parameters**; returns the completed result.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `on_stdout` | — | callback(string) | Unset | Python sync stdout handler; JS sets onStdout on run/connect. |
| `on_stderr` | — | callback(string) | Unset | Python sync stderr handler; JS sets onStderr on run/connect. |
| `on_pty` | — | callback(bytes) | Unset | Python sync PTY output handler; JS sets onData on PTY create/connect. |

### `handle.kill()`

Terminates the command represented by the handle.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |

### `handle.disconnect()`

Disconnects the local output stream; does not kill the remote process.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |
