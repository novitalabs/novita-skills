# Volumes

A **volume** is team-scoped persistent storage with a lifecycle independent of a sandbox. Files written under its mount path remain available after the sandbox is killed. Files elsewhere in the sandbox remain part of that sandbox's own filesystem.

Use `novita.volume.*` on an initialized `Novita` client. Volumes require a [v2 region](region.md); use the same team credentials and region for the volume and its sandboxes. Set `NOVITA_API_KEY` for SDK and CLI calls. The separately imported `Volume` class also provides static methods, but does not inherit connection options from a `Novita` client.

## Lifecycle and identifiers

| Operation | Identifier / effect |
|-----------|---------------------|
| `novita.volume.create(name, ...)` | Creates a new volume; returns a `Volume` instance. |
| `novita.volume.connect(id)` | Looks up an existing volume by **ID**; returns an instance, without creating or mounting anything. |
| `get_info(id)` / `getInfo(id)` | Retrieves metadata and token by **ID**. |
| `list()` | Lists metadata for accessible team volumes; no ID argument and no tokens. |
| `update_quota(id, ...)` / `updateQuota(id, ...)` | Updates capacity quota by **ID**. |
| Sandbox creation with `volume_mounts` / `volumeMounts` | Mapping of **mount path → Volume instance or volume name**, not volume ID. |
| `sandbox.mount_volume(name, path)` / `mountVolume(name, path)` | Mounts by **name** on a running sandbox. |
| `sandbox.unmount_volume(path)` / `unmountVolume(path)` | Detaches by **mount path**; does not delete the volume. |
| `sandbox.kill()` | Deletes the sandbox; does not delete the volume. |
| `novita.volume.destroy(id)` | Permanently deletes the volume and its data by **ID**. |

Persist the returned volume ID in your application's state so another process can reconnect later. Keep volume deletion separate from routine sandbox cleanup when the data needs to survive.

## Create

`quota_size_gib` / `quotaSizeGiB` is an optional capacity quota in **GiB**. The returned `Volume` instance contains `volume_id` / `volumeId`, `name`, and `token`. Treat the token as a credential; log only identifiers and usage fields.

**Python**
```python
from novita_sandbox import Novita

novita = Novita()
vol = novita.volume.create("my-data", quota_size_gib=5)
print(vol.volume_id, vol.name)
```

**JavaScript / TypeScript**
```typescript
import { Novita } from 'novita-sandbox'

const novita = new Novita()
const vol = await novita.volume.create('my-data', { quotaSizeGiB: 5 })
console.log(vol.volumeId, vol.name)
```

**CLI**
```bash
novita volume create --name my-data --quota-size 5
```

## Connect to an existing volume

Use `connect` when a previous session or service already created the volume. It returns an instance carrying the ID, name, and token; it does not attach the volume to a sandbox.

```python
vol = novita.volume.connect("<volumeID>")
print(vol.volume_id, vol.name)
```

```typescript
const vol = await novita.volume.connect('<volumeID>')
console.log(vol.volumeId, vol.name)
```

A missing ID raises a not-found error (`404`). Check the ID, team, and region before creating a replacement: a newly created volume will not recover the old data. There is no `novita volume connect` CLI command; use `volume get` to inspect it and `volume mount` to attach it.

## List and inspect

The SDK `list()` returns a list/array, not a paginator. Entries contain `volume_id` / `volumeId`, `name`, `quota_size_gib` / `quotaSizeGiB`, and `used_size_bytes` / `usedSizeBytes`. Usage is in **bytes**, not GiB. `get_info` / `getInfo` additionally returns the token.

```python
for item in novita.volume.list():
    print(item.volume_id, item.name, item.quota_size_gib, item.used_size_bytes)

info = novita.volume.get_info(vol.volume_id)
print(info.quota_size_gib, info.used_size_bytes)
```

```typescript
const volumes = await novita.volume.list()
for (const item of volumes) {
  console.log(item.volumeId, item.name, item.quotaSizeGiB, item.usedSizeBytes)
}
const info = await novita.volume.getInfo(vol.volumeId)
console.log(info.quotaSizeGiB, info.usedSizeBytes)
```

```bash
novita volume list                       # alias: volume ls
novita volume list --all                 # all results
novita volume list --limit 50 --page 1    # CLI pagination
novita volume list --output json
novita volume get <volumeID>             # alias: volume info
```

The current CLI can fall back to an unambiguous volume name for `volume get`; the SDK lookup methods take **IDs**. Do not generalize the CLI fallback to SDK calls. SDK info results and structured CLI `get` output can contain the token; avoid dumping them into logs.

## Mount at sandbox creation

Pass a mapping from an absolute mount path to a `Volume` instance or an existing volume **name**. Connecting by ID first supplies the instance for the mapping.

```python
vol = novita.volume.connect("<volumeID>")
sandbox = novita.sandbox.create(
    volume_mounts={"/mnt/data": vol},
)
```

```typescript
const vol = await novita.volume.connect('<volumeID>')
const sandbox = await novita.sandbox.create({
  volumeMounts: { '/mnt/data': vol },
})
```

To use the name directly, replace `vol` with `"my-data"` / `'my-data'`. Multiple mapping entries mount volumes at different paths. A mapping value is not a local directory to upload or a request to create a volume.

```bash
# Existing volume name; flag can be repeated for additional mounts.
novita sandbox create base --volume-mount /mnt/data=my-data -d
```

## Mount and unmount at runtime

Mount an existing volume by **name** on a running sandbox. Both operations return updated sandbox information.

```python
sandbox.mount_volume(vol.name, "/mnt/data")
```

```typescript
await sandbox.mountVolume(vol.name, '/mnt/data')
```

```bash
novita volume mount <sandboxID> --name my-data --path /mnt/data
```

Stop processes using the mount and finish writes before unmounting. Use a normal unmount first; `force` is an explicit option for a busy mount, not the default cleanup path.

```python
sandbox.unmount_volume("/mnt/data")
# If a forced unmount is intended:
# sandbox.unmount_volume("/mnt/data", force=True)
```

```typescript
await sandbox.unmountVolume('/mnt/data')
// If a forced unmount is intended:
// await sandbox.unmountVolume('/mnt/data', { force: true })
```

```bash
novita volume unmount <sandboxID> --path /mnt/data
# Force only when intended:
novita volume unmount <sandboxID> --path /mnt/data --force
```

Unmounting does not erase data. Stop using that path for persistent writes after detaching; mount the volume again before accessing its data.

## Reuse data across sandbox lifecycles

These complete examples create a uniquely named volume, write and unmount it, kill the first sandbox, then reconnect to the volume by ID and read from a second sandbox. The volume is intentionally retained after both sandboxes are cleaned up.

**Python**
```python
from uuid import uuid4
from novita_sandbox import Novita

novita = Novita()
vol = novita.volume.create(f"volume-demo-{uuid4().hex[:12]}", quota_size_gib=5)
volume_id = vol.volume_id
print("Save this volume ID for future sessions:", volume_id)

first = novita.sandbox.create(volume_mounts={"/mnt/data": vol})
try:
    first.files.write("/mnt/data/note.txt", "hello from the first sandbox")
    first.unmount_volume("/mnt/data")
finally:
    first.kill()

# In a later process, initialize Novita with the same team/region and load volume_id.
existing = novita.volume.connect(volume_id)
second = novita.sandbox.create(volume_mounts={"/mnt/data": existing})
try:
    print(second.files.read("/mnt/data/note.txt"))
    second.unmount_volume("/mnt/data")
finally:
    second.kill()
# Volume and note.txt remain available; destroy only when no longer needed.
```

**JavaScript / TypeScript**
```typescript
import { randomUUID } from 'node:crypto'
import { Novita } from 'novita-sandbox'

const novita = new Novita()
const vol = await novita.volume.create(`volume-demo-${randomUUID().slice(0, 12)}`, {
  quotaSizeGiB: 5,
})
const volumeId = vol.volumeId
console.log('Save this volume ID for future sessions:', volumeId)

const first = await novita.sandbox.create({ volumeMounts: { '/mnt/data': vol } })
try {
  await first.files.write('/mnt/data/note.txt', 'hello from the first sandbox')
  await first.unmountVolume('/mnt/data')
} finally {
  await first.kill()
}

// In a later process, initialize Novita with the same team/region and load volumeId.
const existing = await novita.volume.connect(volumeId)
const second = await novita.sandbox.create({
  volumeMounts: { '/mnt/data': existing },
})
try {
  console.log(await second.files.read('/mnt/data/note.txt'))
  await second.unmountVolume('/mnt/data')
} finally {
  await second.kill()
}
// Volume and note.txt remain available; destroy only when no longer needed.
```

## Update capacity quota (current SDK)

The current repository exposes `novita.volume.update_quota` / `updateQuota`. Set the desired quota in GiB; this is a capacity setting, not an increment or a sandbox memory resize. Inspect usage first and handle server rejection rather than assuming every quota change is permitted.

```python
info = novita.volume.update_quota(vol.volume_id, quota_size_gib=10)
print(info.quota_size_gib, info.used_size_bytes)
```

```typescript
const info = await novita.volume.updateQuota(vol.volumeId, { quotaSizeGiB: 10 })
console.log(info.quotaSizeGiB, info.usedSizeBytes)
```

Returns updated info including the token; a missing ID raises a not-found error. This extension was checked against the current SDK source, not a dedicated guide page; verify availability in the installed version. The current CLI has no volume quota-update command.

## Delete when the data is no longer needed

Stop consumers and unmount the volume from sandboxes before deleting it. `novita.volume.destroy(id)` permanently deletes the volume **and all its data**; unmounting or killing a sandbox does not do this. Use the volume **ID**, not its name.

```python
deleted = novita.volume.destroy(vol.volume_id)
print("deleted" if deleted else "not found")
```

```typescript
const deleted = await novita.volume.destroy(vol.volumeId)
console.log(deleted ? 'deleted' : 'not found')
```

`true` / `True` means deleted; `false` / `False` means not found. Other failures raise errors rather than returning a success value.

```bash
novita volume delete <volumeID> -y                  # alias: volume rm
novita volume delete <volumeID1> <volumeID2> -y     # delete several
```

`-y` skips the CLI confirmation and is required for non-interactive deletion. Keep these commands out of cleanup flows that should retain application data.

Sources: [Create](https://docs.novita.ai/guides/sandbox-volume-create), [Connect](https://docs.novita.ai/guides/sandbox-volume-connect), [Get & List](https://docs.novita.ai/guides/sandbox-volume-get-list), [Mount & Unmount](https://docs.novita.ai/guides/sandbox-volume-mount-unmount), [Delete](https://docs.novita.ai/guides/sandbox-volume-delete). Reviewed 2026-09-17; namespace methods, quota updates, return fields, and CLI behavior cross-checked against the current repository. Examples have not been run against the live API.

Related: [sandbox-create.md](sandbox-create.md) · [sandbox-connect.md](sandbox-connect.md) · [fs-read-write.md](fs-read-write.md)


## CLI parameters

### `novita volume create`

| Parameter | Required / default | Purpose |
|---|---|---|
| `-n, --name <name>` | required | New volume name. |
| `--quota-size <size>` | optional; positive integer GiB | Capacity quota. |

No output wrapper is registered for create.

### `novita volume list`

| Parameter | Required / default | Purpose |
|---|---|---|
| `-a, --all` | false | Fetch all pages. |
| `--limit <limit>` | `20`; positive | Page size. |
| `--page <page>` | `1` | One-based page. |
| `-o, --output`, `-f, --format`, `--json` | pretty / deprecated | Output format. |

### `novita volume get <volumeID>` (`info`)

`<volumeID>` is required. Current CLI may resolve an unambiguous volume **name** as a convenience fallback. Supports `-o`, `-f`, and `--json`.

### `novita volume delete <volumeIDs...>` (`rm`)

`<volumeIDs...>` is required; `-y, --yes` skips confirmation. Supports `-o`, `-f`, and `--json`.

### `novita volume mount <sandboxID>`

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Target sandbox. |
| `-n, --name <volume>` | required | Existing volume name. |
| `-p, --path <path>` | required | Absolute mount path. |
| output wrappers | pretty / deprecated | `-o`, `-f`, `--json`. |

### `novita volume unmount <sandboxID>`

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Target sandbox. |
| `-p, --path <path>` | required | Mount path. |
| `-f, --force` | false | Force busy unmount. Here `-f` is **not** output format; use long `--format` only if available in a future CLI. |
| output wrappers | pretty / deprecated | `-o`, `--format`, `--json` as registered; avoid short `-f`. |

## SDK parameter tables

### `novita.volume.create(name, ...)` / `create(name, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Name for new volume. |
| `quota_size_gib` | `quotaSizeGiB` | integer | Unset: server policy | Capacity quota in GiB. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `novita.volume.connect(volume_id, ...)` / `connect(volumeId, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `volume_id` | `volumeId` | string | Required | Persistent volume ID, not its name. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `novita.volume.get_info(volume_id, ...)` / `getInfo(volumeId, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `volume_id` | `volumeId` | string | Required | Persistent volume ID, not its name. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `novita.volume.destroy(volume_id, ...)` / `destroy(volumeId, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `volume_id` | `volumeId` | string | Required | Persistent volume ID, not its name. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `novita.volume.list(...)` / `list(opts?)`

Returns an array/list; no SDK pagination arguments.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `novita.volume.update_quota(volume_id, ...)` / `updateQuota(volumeId, params, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `volume_id` | `volumeId` | string | Required | Persistent volume ID, not its name. |
| `quota_size_gib` | `params.quotaSizeGiB` | integer | Optional in type; supply a value to change quota | Desired capacity in GiB, not an increment. No supported independent inode quota parameter. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `sandbox.mount_volume(name, path, ...)` / `mountVolume(name, path, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Existing volume name, not ID. |
| `path` | `path` | string | Required | Absolute mount path inside sandbox. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

### `sandbox.unmount_volume(path, ...)` / `unmountVolume(path, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Existing mount path inside sandbox. |
| `force` | `force` | boolean | false | Force detachment of a busy mount. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |
