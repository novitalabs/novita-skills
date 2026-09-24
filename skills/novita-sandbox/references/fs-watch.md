# Watch a directory for events

Watch a directory for filesystem events (create, write, remove, rename, chmod). JS/TS and Python-async use a **callback** model; Python-sync uses a **polling** model. Both return a `WatchHandle` you stop with `stop()`.

## Event object & types

Each event is a `FilesystemEvent` with `name` (relative path) and `type` (a `FilesystemEventType`):

| Constant | Value | Meaning |
|----------|-------|---------|
| `FilesystemEventType.CHMOD` | `'chmod'` | Permissions changed |
| `FilesystemEventType.CREATE` | `'create'` | Created |
| `FilesystemEventType.REMOVE` | `'remove'` | Removed |
| `FilesystemEventType.RENAME` | `'rename'` | Renamed |
| `FilesystemEventType.WRITE` | `'write'` | Written to |

## JavaScript / TypeScript — callback

`watchDir(path, onEvent, opts?)` → `WatchHandle`. Options: `recursive` (default false), `timeoutMs` (default 60000, `0` disables), `onExit`, `user`.

```typescript
const sandbox = await novita.codeInterpreter.create()

const handle = await sandbox.files.watchDir(
  '/tmp',
  (event) => {
    console.log(`[${event.type}] ${event.name}`)
  },
  { recursive: true }
)

// ... trigger some file changes ...

await handle.stop()
await sandbox.kill()
```

## Python (sync) — polling

`watch_dir(path, recursive=False)` → `WatchHandle`; pull events with `get_new_events()` (events since the last call). Stop with `stop()`.

```python
import time

sandbox = novita.code_interpreter.create()
watcher = sandbox.files.watch_dir('/tmp', recursive=True)

try:
    while True:
        for e in watcher.get_new_events():
            print(f'[{e.type.value}] {e.name}')
        time.sleep(1)
except KeyboardInterrupt:
    watcher.stop()
    sandbox.kill()
```

Params (Python sync): `path`, `user` (optional), `request_timeout` (seconds, optional), `recursive` (default False).

> The Python **async** SDK uses the callback model like JS: `watch_dir(path, on_event, ...)` returning an async watch handle.

Related: [fs-read-write.md](fs-read-write.md)

## SDK parameter tables

### `sandbox.files.watch_dir(...)` / `files.watchDir(path, onEvent, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `recursive` | `recursive` | boolean | false | Include subdirectories; requires compatible controller. |
| `on_event` (async only) | `onEvent` (positional) | callback(FilesystemEvent) | Required in Python async / JS; absent in Python sync | Consume filesystem events. Sync Python polls get_new_events(). |
| `on_exit` (async only) | `opts.onExit` | callback(error) | Unset | Called when watch ends. |
| `timeout` (async only) | `opts.timeoutMs` | number | 60 s / 60000 ms | Watch deadline; `0` disables. Python sync has no timeout parameter. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### Python sync `handle.get_new_events()`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | Not available | — | No parameters | Return events collected since previous poll. |

### `handle.stop()`

Stop directory watching; await in JS and Python async.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |
