# Info, metrics, and events

## Get sandbox info

Returns the sandbox's current state and metadata. Instance method, or namespace method by ID.

**Python**
```python
info = sandbox.get_info()
print(info.state, info.sandbox_id, info.template_id, info.metadata)

# By ID:
# info = novita.sandbox.get_info(sandbox_id)
```

**JavaScript / TypeScript**
```typescript
const info = await sandbox.getInfo()
console.log(info.state, info.sandboxId, info.templateId, info.metadata)

// By ID:
// const info = await novita.sandbox.getInfo(sandboxId)
```

Common fields: `sandboxId`/`sandbox_id`, `templateId`/`template_id`, `state`, `metadata`, `startedAt`/`started_at`, `endAt`/`end_at`.

## Metrics

CPU / memory / disk usage samples for a sandbox.

**Python**
```python
metrics = sbx.get_metrics()
# By ID: metrics = novita.sandbox.get_metrics(sbx.sandbox_id)
print("Metrics:", metrics)
```

**JavaScript / TypeScript**
```typescript
const metrics = await sbx.getMetrics()
// By ID: const metrics = await novita.sandbox.getMetrics(sbx.sandboxId)
console.log('Metrics:', metrics)
```

**CLI**
```bash
novita sandbox metrics <sandboxID>            # alias: sandbox mt
novita sandbox metrics <sandboxID> --follow   # stream
```

## Events

A queryable timeline of lifecycle operations (create, pause, resume, connect, timeout, delete) — useful for troubleshooting, auditing, and billing reconciliation. Paginated with `limit` / `offset`; check `has_more` / `hasMore`.

**Python**
```python
result = novita.sandbox.get_events(
    sandbox_id="iq721h44siv24wmyrh5oc",
    events="create,pause,resume,connect,timeout,delete",
    limit=10,
    offset=0,
)
print("Events:", result.items)

if result.has_more:
    next_page = novita.sandbox.get_events(sandbox_id="iq721h44siv24wmyrh5oc", limit=10, offset=10)
    print("Next page:", next_page.items)
```

**JavaScript / TypeScript**
```typescript
const result = await novita.sandbox.getEvents({
  sandboxID: 'iq721h44siv24wmyrh5oc',
  events: 'create,pause,resume,connect,timeout,delete',
  limit: 10,
  offset: 0,
})
console.log('Events:', result.items)

if (result.hasMore) {
  const nextPage = await novita.sandbox.getEvents({ sandboxID: 'iq721h44siv24wmyrh5oc', limit: 10, offset: 10 })
  console.log('Next page:', nextPage.items)
}
```

**CLI**
```bash
novita sandbox events <sandboxID>
novita sandbox events <sandboxID> --events create,pause,resume --state success
```

## Reach a service running in the sandbox

A background server inside the sandbox is exposed via the sandbox host URL. `get_host(port)` / `getHost(port)` returns the host string; prefix with `https://`. Choose public or token-protected service access separately from controller authentication, and check server readiness before sending requests; see [network access](sandbox-network.md).

```python
sandbox.commands.run("python3 -m http.server 3000", background=True)
host = sandbox.get_host(3000)
print(f"https://{host}")
```

```typescript
await sandbox.commands.run('python3 -m http.server 3000', { background: true })
const host = sandbox.getHost(3000)
console.log(`https://${host}`)
```

Related: [list.md](sandbox-list.md) · [run-command.md](sandbox-run-command.md) · [pause-resume.md](sandbox-pause-resume.md)


## CLI parameters

### `novita sandbox info <sandboxID>` (`in`)

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Sandbox whose state and metadata are displayed. |
| `-o, --output`, `-f, --format`, `--json` | pretty / deprecated | Output format. |

### `novita sandbox metrics <sandboxID>` (`mt`)

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Target sandbox. |
| `-f, --follow` | false | Stream metrics until closed. |
| `-o, --output <format>` | pretty | Output format. |
| `--format <format>` | deprecated; long form only | Deprecated output alias; `-f` belongs to follow. |
| `--json` | not registered | Do not use; use `--output json`. |

### `novita sandbox events [sandboxID]`

| Parameter | Required / default | Purpose |
|---|---|---|
| `[sandboxID]` | optional | Filter by sandbox ID. |
| `--template-id <templateID>` | unset | Filter by template ID. |
| `--events <events>` | server key set | Comma-separated event names. |
| `--state <state>` | unset | Event status, e.g. `success`. |
| `--start-time <timestamp>` | end minus 30 days | Unix timestamp in seconds. |
| `--end-time <timestamp>` | current time | Unix timestamp in seconds. |
| `--order-asc` | false | Sort by record time ascending. |
| `--offset <offset>` | `0` | Number of events to skip. |
| `--limit <limit>` | `100` CLI default | Maximum events (API max 100). |
| `-o, --output <format>`, `--json` | pretty / deprecated | `--format` is not registered. |

## SDK parameter tables

### `get_info(...)` / `getInfo(...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox_id` | `sandboxId` | string | Required for namespace call; omit on instance | Sandbox ID, not template name. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

### `get_metrics(...)` / `getMetrics(...)`

Namespace form takes ID first; JS instance form takes `{ start, end, ... }`.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `sandbox_id` | `sandboxId` | string | Required for namespace call; omit on instance | Sandbox ID, not template name. |
| `start` | `start` | datetime / Date | Sandbox start | Beginning of metric window. |
| `end` | `end` | datetime / Date | Current time | End of metric window. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

### `novita.sandbox.get_events(...)` / `getEvents(opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `start_time` | `startTime` | integer | Server: end minus 30 days | Inclusive Unix timestamp in **seconds**; maximum query span 60 days. |
| `end_time` | `endTime` | integer | Server: now | Unix timestamp in seconds; greater than start. |
| `sandbox_id` | `sandboxID` | string | Unset | Filter sandbox ID; partial matching supported. |
| `template_id` | `templateID` | string | Unset | Filter template ID; partial matching supported. |
| `events` | `events` | string | Server: key event set | Comma-separated names, e.g. `create,pause,resume,connect,timeout,delete`; not an array. |
| `state` | `state` | string | Unset | Event status such as `success`; not sandbox running/paused state. |
| `order_asc` | `orderAsc` | boolean | Server: false | Sort by record time ascending when true. |
| `offset` | `offset` | integer | Server: 0; min 0 | Number of records to skip. |
| `limit` | `limit` | integer | Server: 10; 1–100 | Maximum records; CLI default is 100. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |

### `sandbox.get_host(port)` / `sandbox.getHost(port)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `port` | `port` | integer | Required | Listening port inside sandbox; returns hostname, without URL scheme. |
