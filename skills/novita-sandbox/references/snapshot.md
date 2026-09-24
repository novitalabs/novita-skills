# Snapshots

A **snapshot** is a reusable saved state of a sandbox — it captures the filesystem and memory state so you can spawn new sandboxes from that point later. Snapshots are persistent and survive deletion of the source sandbox.

Snapshot vs. template: a **template** is *built* from a Docker image with declared steps (a clean blueprint); a **snapshot** is *captured* from a running sandbox at a moment in time, including anything created at runtime.

Snapshot operations live under `novita.sandbox.*` (create is also an instance method on a sandbox). The CLI exposes them under the `novita snapshot` group (modern domains only) — set `NOVITA_API_KEY` in the environment first.

## Create a snapshot

`sandbox.create_snapshot()` / `createSnapshot()` captures the current state and returns snapshot info with a `snapshot_id` / `snapshotId`. The sandbox is paused while the snapshot is created.

**Python**
```python
sandbox = novita.sandbox.create("base")

# Prepare state you want to preserve
sandbox.commands.run("pip install requests")

snapshot = sandbox.create_snapshot()
print("Snapshot ID:", snapshot.snapshot_id)

sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
const sandbox = await novita.sandbox.create('base')

// Prepare state you want to preserve
await sandbox.commands.run('pip install requests')

const snapshot = await sandbox.createSnapshot()
console.log('Snapshot ID:', snapshot.snapshotId)

await sandbox.kill()
```

**CLI**
```bash
novita snapshot create <sandboxID>
```

## Create a new sandbox from a snapshot

Pass the snapshot ID to `novita.sandbox.create(...)`. The new sandbox starts from the captured filesystem and runtime state, so setup work from the origin sandbox is already present.

**Python**
```python
new_sandbox = novita.sandbox.create(snapshot_id)
result = new_sandbox.commands.run("python -c 'import requests; print(requests.__version__)'")
print(result.stdout)
new_sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
const newSandbox = await novita.sandbox.create(snapshotId)
const result = await newSandbox.commands.run("python -c 'import requests; print(requests.__version__)'")
console.log(result.stdout)
await newSandbox.kill()
```

**CLI**
```bash
novita sandbox create <snapshotID>
```

## List snapshots

`novita.sandbox.list_snapshots(...)` / `listSnapshots(...)` returns a paginator — iterate with `has_next`/`hasNext` and `next_items()`/`nextItems()`. Pass `sandbox_id`/`sandboxId` to list only snapshots from a specific sandbox.

**Python**
```python
paginator = novita.sandbox.list_snapshots(limit=20)
while paginator.has_next:
    for s in paginator.next_items():
        print(s.snapshot_id)

# Filter by source sandbox
paginator = novita.sandbox.list_snapshots(sandbox_id="<sandboxID>")
```

**JavaScript / TypeScript**
```typescript
const paginator = novita.sandbox.listSnapshots({ limit: 20 })
while (paginator.hasNext) {
  const snapshots = await paginator.nextItems()
  for (const s of snapshots) console.log(s.snapshotId)
}

// Filter by source sandbox
const p2 = novita.sandbox.listSnapshots({ sandboxId: '<sandboxID>' })
```

**CLI**
```bash
novita snapshot list                  # alias: snapshot ls
novita snapshot list --sandbox-id <sandboxID>   # filter by source sandbox
novita snapshot list --all            # all snapshots, no pagination
novita snapshot list --limit 50 --page 1
novita snapshot list --output json    # JSON output (--output takes pretty|json|yaml)
```

## Delete a snapshot

`novita.sandbox.delete_snapshot(id)` / `deleteSnapshot(id)` → boolean: `true`/`True` if deleted, `false`/`False` if not found. Deleting is permanent.

> A snapshot may not be deletable while running sandboxes still use it as their source — kill those sandboxes first.

**Python**
```python
deleted = novita.sandbox.delete_snapshot("<snapshotID>")
print("deleted" if deleted else "not found")
```

**JavaScript / TypeScript**
```typescript
const deleted = await novita.sandbox.deleteSnapshot('<snapshotID>')
console.log(deleted ? 'deleted' : 'not found')
```

**CLI**
```bash
novita snapshot delete <snapshotID> -y                 # alias: snapshot rm; -y skips confirmation
novita snapshot delete <snapshotID1> <snapshotID2> -y  # delete several at once
```

Related: [create.md](sandbox-create.md) (create-from-snapshot) · [pause-resume.md](sandbox-pause-resume.md)


## CLI parameters

### `novita snapshot create <sandboxID>`

`<sandboxID>` is required. Supports `-o, --output`, deprecated `-f, --format`, and `--json`.

### `novita snapshot list`

| Parameter | Required / default | Purpose |
|---|---|---|
| `-a, --all` | false | Fetch all pages. |
| `--sandbox-id <sandbox-id>` | unset | Filter by source sandbox. |
| `-l, --limit <limit>` | `20`; `0` means no limit | Page size. |
| `-p, --page <page>` | `1` | One-based page. |
| output wrappers | pretty / deprecated | `-o`, `-f`, `--json`. |

### `novita snapshot delete <snapshotIDs...>`

`<snapshotIDs...>` is required; `-y, --yes` skips confirmation. Supports `-o`, `-f`, and `--json`.

## SDK parameter tables

### `create_snapshot(...)` / `createSnapshot(...)`

Instance form: `sandbox.create_snapshot()` / `sandbox.createSnapshot()`. Namespace form takes sandbox ID.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox_id` | `sandboxId` | string | Required for namespace call; omit on instance | Sandbox ID, not template name. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

### `novita.sandbox.list_snapshots(...)` / `listSnapshots(opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox_id` | `sandboxId` | string | Unset | Filter snapshots by source sandbox. |
| `limit` | `limit` | integer | 100 | Entries per API page. |
| `next_token` | `nextToken` | string | Unset | Pagination cursor. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

### `paginator.next_items()` / `paginator.nextItems()`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |

### `novita.sandbox.delete_snapshot(snapshot_id, ...)` / `deleteSnapshot(snapshotId, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `snapshot_id` | `snapshotId` | string | Required | Snapshot ID to delete. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |
