# Upload & download data

## Direct upload (from SDK)

Uploading is just `files.write(...)` — read the local content and write it into the sandbox.

**Python**
```python
sandbox = novita.code_interpreter.create()

with open("../local-test-file", "rb") as f:
    result = sandbox.files.write("/tmp/test-file", f)
    print(result)

sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
import fs from 'fs'

const sandbox = await novita.codeInterpreter.create()

const content = fs.readFileSync('../local-test-file', 'utf8')
const result = await sandbox.files.write('/tmp/test-file', content)
console.log(result)

await sandbox.kill()
```

Multiple files: use `files.write_files([...])` (Python) / `files.write([...])` (JS) — see [fs-read-write.md](fs-read-write.md).

## Direct download (from SDK)

Downloading is `files.read(...)`.

```python
content = sandbox.files.read("/tmp/test-file")
```
```typescript
const content = await sandbox.files.read('/tmp/test-file')
```

## Pre-signed URLs (upload/download without SDK credentials)

Pre-signed URLs let a browser or other untrusted environment upload/download **without** Novita credentials. Create the sandbox with `secure: true` on your trusted backend, generate the URL, and hand it out with a short expiration — it acts as a temporary bearer credential until it expires.

### Pre-signed upload URL

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.codeInterpreter.create({ secure: true })

const publicUploadUrl = await sandbox.uploadUrl('/tmp/test-file', {
  useSignatureExpiration: 120, // seconds, optional
})

// From the browser: POST the file to publicUploadUrl as multipart form-data
const form = new FormData()
form.append('file', new Blob(['file content']), 'test-file')
await fetch(publicUploadUrl, { method: 'POST', body: form })

// Verify from the SDK
console.log(await sandbox.files.read('/tmp/test-file'))
await sandbox.kill()
```

**Python**
```python
sandbox = novita.code_interpreter.create(secure=True)

signed_url = sandbox.upload_url(
    "/tmp/test-file",
    use_signature_expiration=120,  # seconds, optional
)
# Hand signed_url to the client; they POST the file to it as multipart form-data.
```

### Pre-signed download URL

```typescript
const sandbox = await novita.codeInterpreter.create({ secure: true })
const publicDownloadUrl = await sandbox.downloadUrl('/tmp/test-file', {
  useSignatureExpiration: 120,
})
// Hand publicDownloadUrl to the client; they GET it to download the file.
```
```python
sandbox = novita.code_interpreter.create(secure=True)
signed_url = sandbox.download_url("/tmp/test-file", use_signature_expiration=120)
```

Related: [fs-read-write.md](fs-read-write.md) · [fs-watch.md](fs-watch.md)

## SDK parameter tables

### `sandbox.upload_url(path, ...)` / `uploadUrl(path, opts?)`

These methods generate URLs locally; they do not accept request-timeout or API connection options.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Python required; JS optional | Target file path inside sandbox. |
| `user` | `user` | string | Template default user | OS user for this operation. |
| `use_signature_expiration` | `useSignatureExpiration` | integer | Unset: no expiration bound | Signature lifetime in **seconds in both SDKs**. Explicit expiration requires secured controller. |

### `sandbox.download_url(path, ...)` / `downloadUrl(path, opts?)`

These methods generate URLs locally; they do not accept request-timeout or API connection options.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Python required; JS required | Target file path inside sandbox. |
| `user` | `user` | string | Template default user | OS user for this operation. |
| `use_signature_expiration` | `useSignatureExpiration` | integer | Unset: no expiration bound | Signature lifetime in **seconds in both SDKs**. Explicit expiration requires secured controller. |
