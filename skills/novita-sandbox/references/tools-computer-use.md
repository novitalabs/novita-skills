# Computer Use (virtual desktop)

Novita Desktop gives an AI agent a secure, isolated virtual desktop it can interact with. Create a desktop sandbox with `novita.desktop.create()`, start the stream, and hand out a browser-accessible VNC URL.

Streaming methods live on `desktop.stream.*`. `getUrl()` / `get_url()` returns an interactive URL; pass `viewOnly: true` / `view_only=True` for a read-only (monitoring) URL.

## Get a virtual desktop VNC URL

**JavaScript / TypeScript**
```typescript
import { Novita } from 'novita-sandbox'

async function main() {
  const novita = new Novita()
  const desktop = await novita.desktop.create()

  await desktop.stream.start()

  // Interactive URL
  const url = desktop.stream.getUrl()
  console.log(url)

  // Read-only (view-only) URL
  const viewOnlyUrl = desktop.stream.getUrl({ viewOnly: true })
  console.log(viewOnlyUrl)

  // Keep running until interrupted, then clean up
  const cleanup = async () => {
    await desktop.stream.stop()  // stop streaming
    await desktop.kill()         // deallocate the sandbox
    process.exit(0)
  }
  process.on('SIGINT', cleanup)
  process.on('SIGTERM', cleanup)
  setInterval(() => {}, 1000)
}

main().catch(console.error)
```

**Python**
```python
from novita_sandbox import Novita

novita = Novita()
desktop = novita.desktop.create()

desktop.stream.start()

# Interactive URL
url = desktop.stream.get_url()
print(url)

# Read-only (view-only) URL
view_only_url = desktop.stream.get_url(view_only=True)
print(view_only_url)

try:
    input("Desktop stream started, press Enter to stop...\n")
finally:
    desktop.stream.stop()  # stop streaming
    desktop.kill()         # deallocate the sandbox
```

The URL is a browser-accessible VNC endpoint, e.g. `https://<host>/vnc.html?autoconnect=true&resize=scale` (view-only adds `&view_only=true`).

## Prerequisites
- `export NOVITA_API_KEY=<your key>`
- `npm i novita-sandbox` / `pip install novita-sandbox`

Related: [create.md](sandbox-create.md) · [pause-resume.md](sandbox-pause-resume.md)

## SDK parameter tables

### `novita.desktop.create(template?, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `template` | `template` | string | `desktop` | Desktop-capable template name/ID; JS also opts.template. |
| `resolution` | `resolution` | integer pair | [1024, 768] | Screen width and height in pixels. |
| `dpi` | `dpi` | integer | 96 | Display dots per inch. |
| `display` | `display` | string | `:0` | X display identifier. |
| `timeout` | `timeoutMs` | integer | 300 s / 300000 ms | Sandbox lifetime. |
| `metadata` | `metadata` | string map | Empty | Sandbox metadata. |
| `envs` | `envs` | string map | Empty | Sandbox environment variables. |
| `secure` | `secure` | boolean | Python false; JS inherits sandbox default | Controller authentication; pass explicitly to align languages. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |
| — | Other SandboxOpts fields | Sandbox options | Optional | JS DesktopOpts extends SandboxOpts; see [create table](sandbox-create.md#sdk-parameter-tables). Python desktop create does not declare these extra fields. |

### `desktop.stream.start(...)` / `start(opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `vnc_port` | `vncPort` | integer | 5900 | VNC server port. |
| `port` | `port` | integer | 6080 | noVNC web proxy port. |
| `require_auth` | `requireAuth` | boolean | false | Require generated VNC password; separate from controller/service authentication. |
| `window_id` | `windowId` | string | Unset: entire desktop | Restrict VNC stream to this X window ID. |

### `desktop.stream.get_url(...)` / `getUrl(opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `auto_connect` | `autoConnect` | boolean | true | Automatically connect browser viewer. |
| `view_only` | `viewOnly` | boolean | false | Disable keyboard/mouse interaction in viewer. |
| `resize` | `resize` | string | `scale` | Viewer resize policy: off, scale, remote. |
| `auth_key` | `authKey` | string | Unset | Embed VNC password in viewer URL. |

### `desktop.stream.get_auth_key()` / `getAuthKey()`

Requires stream authentication enabled; returns generated password.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |

### `desktop.stream.stop()`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |
