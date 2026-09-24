# List & delete templates

## List templates

`novita.template.list(...)` returns a paginator. Params: `template_type`/`templateType` (`"template_build"` default, or `"snapshot_template"`), `page` (default 1), `limit` (default 20, max 100).

**Python**
```python
res = novita.template.list(template_type="template_build", page=1, limit=20)
for item in res.items:
    print(item.template_id, item.aliases, item.cpu_count, item.memory_mb)
```

**JavaScript / TypeScript**
```typescript
const paginator = novita.template.list({ templateType: 'template_build', limit: 20 })
const page = await paginator.nextItems()
for (const item of page) {
  console.log(item.templateId, item.aliases, item.cpuCount, item.memoryMB)
}
```

**CLI**
```bash
novita template list                       # alias: template ls
novita template list --output json         # JSON output
novita template list --output yaml         # YAML output
```
> `-o/--output` values: `pretty` (default), `json`, `yaml`. The old `--format json` and `--json` are deprecated aliases.

## Delete a template

`novita.template.delete(id)` → boolean: `true`/`True` if deleted, `false`/`False` if not found. Deleting is permanent.

**Python**
```python
deleted = novita.template.delete("tpl_123")
print(deleted)   # True if deleted, False if not found
```

**JavaScript / TypeScript**
```typescript
const deleted = await novita.template.delete('tpl_123')
console.log(deleted) // true if deleted, false if not found
```

**CLI** (asks for confirmation unless `-y`; also removes local `novita.toml`):
```bash
novita template delete <templateID>      # alias: template dl
novita template delete -y                # skip confirmation
novita template delete --select --team <teamID>  # pick interactively
```

Related: [template-define.md](template-define.md) · [template-build.md](template-build.md) · [template-tags.md](template-tags.md)


## CLI examples

```bash
novita template publish <templateID>
novita template unpublish --select --team <teamID>
novita template migrate --language typescript  # or python-sync / python-async
```

## CLI parameters

### `novita template list` (`ls`)

| Parameter | Required / default | Purpose |
|---|---|---|
| `-a, --all` | false | Fetch all pages. |
| `-t, --team <team-id>` | selected team | Team filter. |
| `-p, --page <page>` | `1` | Starting page. |
| `-l, --limit <limit>` | `20`; max `100` | Page size. |
| `-o, --output`, `-f, --format` | pretty / deprecated | Output format; `--json` is not registered. |

### `novita template delete [templates...]` / `publish [template]` / `unpublish [template]`

| Parameter | Delete | Publish / unpublish |
|---|---|---|
| template argument | optional with `--select`; one or more IDs otherwise | optional; `--select` prompts |
| `--path`, `--config`, `--select`, `--team` | supported | supported |
| `-y, --yes` | skip delete confirmation | skip publish confirmation |
| output wrappers | none | none |

### `novita template migrate`

| Parameter | Required / default | Purpose |
|---|---|---|
| `-d, --dockerfile <file>` | `novita.Dockerfile` | Legacy Dockerfile to migrate. |
| `--config <novita-toml>` | discovers config | Legacy config path. |
| `-l, --language <language>` | prompt if omitted | Generated SDK: `typescript`, `python-sync`, or `python-async`. |
| `--path <path>` | current directory | Migration root. |

No output wrapper is registered.

## SDK parameter tables

### `novita.template.list(...)`

Python returns a response with `.items`; JS returns a TemplatePaginator. They do not share the sandbox paginator interface.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `template_type` | `templateType` | string | `template_build` | `template_build` or `snapshot_template`. |
| `page` | `page` | integer | 1 | Starting page, one-based. |
| `limit` | `limit` | integer | 20; maximum 100 | Page size. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### JS `paginator.nextPage()`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| Not available | — | — | No parameters | Fetch next TemplateListResponse; records are response.items. Check paginator.hasNext. |

### JS `paginator.reset()`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| Not available | — | — | No parameters | Reset pagination to configured starting page. |

### `novita.template.delete(template_id, ...)` / `delete(templateId, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `template_id` | `templateId` | string | Required | ID of template to permanently delete. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |
