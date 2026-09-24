# Template tags

Tags label template builds for releases (e.g. `latest`, `stable`, `production`). All methods accept a single tag string or a list of tags.

## Assign tags

`novita.template.assignTags` / `assign_tags` — assign one or more tags to an existing build. Returns tag info.

**Python**
```python
novita.template.assign_tags("my-template:v1.0", "production")
novita.template.assign_tags("my-template:v1.0", ["production", "stable"])
```

**JavaScript / TypeScript**
```typescript
await novita.template.assignTags('my-template:v1.0', 'production')
await novita.template.assignTags('my-template:v1.0', ['production', 'stable'])
```

## Assign tags at build time

Via the `tags` option of `novita.template.build` (see [template-build.md](template-build.md)):

```python
template = novita.template.new().from_python_image("3.12")
build = novita.template.build(template, "my-template", tags=["latest", "stable"])
```
```typescript
const template = novita.template.new().fromPythonImage('3.12')
const build = await novita.template.build(template, 'my-template', { tags: ['latest', 'stable'] })
```

## Remove tags

`novita.template.removeTags` / `remove_tags` — remove one or more tags by template name. Returns nothing.

**Python**
```python
novita.template.remove_tags("my-template", "production")
novita.template.remove_tags("my-template", ["production", "staging"])
```

**JavaScript / TypeScript**
```typescript
await novita.template.removeTags('my-template', 'production')
await novita.template.removeTags('my-template', ['production', 'staging'])
```

## Get tags

`novita.template.getTags` / `get_tags` returns the tags on a template.

```python
tags = novita.template.get_tags("my-template")
```
```typescript
const tags = await novita.template.getTags('my-template')
```

Related: [template-build.md](template-build.md) · [template-list-delete.md](template-list-delete.md)

## SDK parameter tables

### `novita.template.assign_tags(...)` / `assignTags(name, tags, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `target_name` | `targetName` | string | Required | Existing build selector, e.g. my-template:v1. |
| `tags` | `tags` | string or string array | Required | One or more tag names. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `novita.template.remove_tags(...)` / `removeTags(name, tags, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Template name whose tags will be removed. |
| `tags` | `tags` | string or string array | Required | One or more tag names. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |

### `novita.template.get_tags(template_id, ...)` / `getTags(templateId, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `template_id` | `templateId` | string | Required | Template identifier accepted by tags endpoint. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |
