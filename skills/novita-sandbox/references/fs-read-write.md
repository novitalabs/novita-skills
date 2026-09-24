# Read, write & inspect files

Filesystem operations live on `sandbox.files.*`. In the docs the sandbox is created with `novita.codeInterpreter.create()` (JS) / `novita.code_interpreter.create()` (Python), which gives the fullest filesystem surface; the same `files` methods work on a sandbox object.

## Read a file

`files.read(path)` returns the file content.

**Python**
```python
sandbox = novita.code_interpreter.create()

sandbox.files.write("/tmp/test-file", "test-file-content")
content = sandbox.files.read("/tmp/test-file")
print(content)

sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.codeInterpreter.create()

await sandbox.files.write('/tmp/test-file', 'test-file-content')
const content = await sandbox.files.read('/tmp/test-file')
console.log(content)

await sandbox.kill()
```

## Write a single file

`files.write(path, data)`.

```python
result = sandbox.files.write("/tmp/test-file", "test-file-content")
print(result)
```
```typescript
const result = await sandbox.files.write('/tmp/test-file', 'test-file-content')
console.log(result)
```

## Write multiple files

JS: `files.write([...])` with `{ path, data }` items. Python: `files.write_files([...])`.

**Python**
```python
result = sandbox.files.write_files([
    {"path": "/tmp/test-file-1", "data": "file content 1"},
    {"path": "/tmp/test-file-2", "data": "file content 2"},
])
```

**JavaScript / TypeScript**
```typescript
const result = await sandbox.files.write([
  { path: '/tmp/test-file-1', data: 'file content 1' },
  { path: '/tmp/test-file-2', data: 'file content 2' },
])
```

## File & directory metadata

`files.getInfo(path)` / `files.get_info(path)` returns metadata about a file or directory.

**Python** — returns an `EntryInfo`:
```python
sandbox.files.write("/tmp/test-file", "test-file-content")
info = sandbox.files.get_info("/tmp/test-file")
# EntryInfo(name='test-file', type=<FileType.FILE: 'file'>, path='/tmp/test-file',
#           size=17, mode=420, permissions='-rw-r--r--', owner='user',
#           modified_time=datetime.datetime(...))
```

**JavaScript / TypeScript**:
```typescript
const info = await sandbox.files.getInfo('/tmp/test-file')
// { name: 'test-file', type: 'file', path: '/tmp/test-file', size: 17,
//   mode: 420, permissions: '-rw-r--r--', owner: 'user', modifiedTime: ... }
```

Fields: `name`, `type` (`'file'` / `'dir'`), `path`, `size`, `mode`, `permissions`, `owner`, `modifiedTime` / `modified_time`.

Related: [fs-watch.md](fs-watch.md) · [fs-upload-download.md](fs-upload-download.md)

## SDK parameter tables

### `sandbox.files.read(path, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `format` | `format` | string | `text` | Python: text/bytes/stream; JS additionally blob. Controls return type. |
| `gzip` | — | boolean | false | Python compressed transfer. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.write(path, data, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `data` | `data` | Python str/bytes/IO; JS string/ArrayBuffer/Blob/ReadableStream | Required | Content to write; overwrites existing target file. |
| `gzip` | — | boolean | false | Python compressed upload. |
| `use_octet_stream` | — | boolean | false | Python raw binary upload path when supported by controller. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.write_files(files, ...)` / `files.write(files, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `files` | `files` | WriteEntry array | Required | Each item requires `path` and `data` with the same types as single-file write. |
| `gzip` | — | boolean | false | Python compressed upload. |
| `use_octet_stream` | — | boolean | false | Python raw binary upload path when supported by controller. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.get_info(path, ...)` / `files.getInfo(path, opts?)`

Return entry metadata.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.make_dir(path, ...)` / `files.makeDir(path, opts?)`

Create directory including parents.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.exists(path, ...)` / `files.exists(path, opts?)`

Check whether path exists.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.remove(path, ...)` / `files.remove(path, opts?)`

Remove file or directory.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.list(path, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Path inside the sandbox. |
| `depth` | `depth` | integer | 1 | Directory traversal depth. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

### `sandbox.files.rename(old_path, new_path, ...)` / `rename(oldPath, newPath, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `old_path` | `oldPath` | string | Required | Existing path. |
| `new_path` | `newPath` | string | Required | Destination path. |
| `user`, `request_timeout` | `opts.user`, `opts.requestTimeoutMs` | File options | Optional | [File request options](common-parameters.md#file-request-options); no other connection fields. |

## Code Interpreter creation parameters

`novita.code_interpreter.create(...)` / `novita.codeInterpreter.create(opts?)` uses the sandbox creation options. See the complete [sandbox create parameter table](sandbox-create.md#sdk-parameter-tables); the code interpreter namespace mainly changes the default template/runtime and exposes the same `files` methods documented here.
