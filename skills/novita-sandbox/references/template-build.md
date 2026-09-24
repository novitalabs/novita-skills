# Building a template

Once a definition is ready (see [template-define.md](template-define.md)), build it with `novita.template.build(...)`. It returns a build whose `templateId` / `template_id` you pass to `sandbox.create(...)`.

## Build

**Python**
```python
template = novita.template.new().from_image("python:3.12")

build = novita.template.build(
    template,
    "my-python-template",   # template name
    cpu_count=2,
    memory_mb=1024,
)

sandbox = novita.sandbox.create(build.template_id)
print(sandbox.sandbox_id)
sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
const template = novita.template.new().fromImage('python:3.12')

const build = await novita.template.build(template, 'my-python-template', {
  cpuCount: 2,
  memoryMB: 1024,
})

const sandbox = await novita.sandbox.create(build.templateId)
console.log(sandbox.sandboxId)
await sandbox.kill()
```

**CLI** — the CLI builds from a Dockerfile (alias `template ct`):
```bash
# Reads ./novita.Dockerfile (or Dockerfile) by default
novita template create my-python-template

# The image must contain app.py and curl; /health must return success when ready.
novita template create my-python-template \
  --dockerfile ./novita.Dockerfile --cpu-count 2 --memory-mb 1024 \
  --cmd "python app.py" --ready-cmd "curl -fsS http://127.0.0.1:8000/health"
```

In the current CLI, `--cmd` requires `--ready-cmd`. For SDK builds, set startup and readiness on the builder before `build`; see the [complete service example](template-define.md#startup-and-readiness). Do not assume a completed package installation means the runtime service is ready.

### Build options

| Option (Python / JS) | Description |
|----------------------|-------------|
| `cpu_count` / `cpuCount` | vCPU cores for sandboxes from this template. |
| `memory_mb` / `memoryMB` | Memory in MiB. |
| `tags` | Tags to attach to this build (see [template-tags.md](template-tags.md)). |
| `skip_cache` / `skipCache` | Ignore the build cache (see below). |

## Build cache

Builds cache completed layers so repeated builds don't rerun every instruction. Caching is on by default. Skip it only to force a fresh build (it makes builds slower). Three levels:

**Whole build** — ignore all cache:
```python
build = novita.template.build(t, "my-template-no-cache", skip_cache=True)
```
```typescript
const build = await novita.template.build(t, 'my-template-no-cache', { skipCache: true })
```

**From a layer onward** — chained `.skip_cache()` / `.skipCache()` in the definition forces **that instruction and all following layers** to rebuild. Placed on a `from*` call, it invalidates the whole template. The earlier you place it, the more is invalidated.
```python
template = novita.template.new().from_python_image("3.12").skip_cache().run_cmd("pip install -U pip")
```
```typescript
const template = novita.template.new().fromPythonImage('3.12').skipCache().runCmd('pip install -U pip')
```

**CLI**:
```bash
novita template build --no-cache
```

## Diagnose startup and build failures

- Registry authentication or package installation fails: inspect the failing build step and its credentials, network access, and command output.
- Start command exits: check the executable, working directory, file permissions, and that the command runs the intended service.
- Ready command never succeeds: confirm the service's listening port, health path/status, and required check tool (`curl`, `ss`, or `pgrep`). Run the same check inside the environment when possible; a fixed sleep can hide a startup failure.
- Resource settings are rejected: check the account's [quota and CPU/memory rules](https://docs.novita.ai/guides/sandbox-quota-limit).

Source: [Build Template](https://docs.novita.ai/guides/sandbox-template-build-operations). Startup flags cross-checked against the current CLI on 2026-09-17.

Related: [template-define.md](template-define.md) · [template-tags.md](template-tags.md) · [template-list-delete.md](template-list-delete.md)


## CLI parameters

### `novita template create [template-name]` (`ct`)

| Parameter | Required / default | Purpose |
|---|---|---|
| `[template-name]` | required except `--from-file` | New template name. |
| `--from <image\|dockerfile\|template>` | `dockerfile` | Source mode. |
| `--image <image>` | required with `--from image` | Container image. |
| `--template-id <template-id>` | required with `--from template` | Base template ID/alias. |
| `--from-file <file>` | unset | Build one template per image line; `#` comments ignored. |
| `--prefix <prefix>` | empty | Prefix names derived from `--from-file`. |
| `--workers <count>` | `4` | Concurrent from-file builds. |
| `--manifest <file>` | `novita-templates.json` | Conversion manifest path. |
| `--no-manifest` | false | Do not write manifest. |
| `--force` | false | Rebuild manifest-recorded images. |
| `--registry-username <username>` | env fallback | Private registry username. |
| `--registry-password <password>` | env fallback | Private registry password/token. |
| `-d, --dockerfile <file>` | auto-detect | Dockerfile path. |
| `-c, --cmd <start-command>` | unset | Startup command; requires `--ready-cmd`. |
| `--ready-cmd <ready-command>` | unset | Readiness command, must exit 0. |
| `--cpu-count <cpu-count>` | `2` | vCPU allocation. |
| `--memory-mb <memory-mb>` | `1024`, even | Memory in MB. |
| `--no-cache` | false | Skip build cache. |
| `--patch-cmd <cmd>` | unset | Debian from-image provisioning patch; not for from-template/dind. |
| shared `--path`, `--config` | documented | Working root/config. |

No output wrapper is registered.

### `novita template build [template]` (`bd`, legacy)

| Parameter | Required / default | Purpose |
|---|---|---|
| `[template]` | config-selected | Template ID/name to rebuild. |
| `-d, --dockerfile <file>` | auto-detect | Dockerfile path. |
| `-n, --name <template-name>` | config name | Template name. |
| `-c, --cmd <start-command>` | config value | Startup command. |
| `--ready-cmd <ready-command>` | config value | Readiness command. |
| `--cpu-count <cpu-count>` | `2` or config | vCPU allocation. |
| `--memory-mb <memory-mb>` | `512` or config | Legacy command default memory in MB. |
| `--build-arg <args...>` | unset | Additional `name=value` build arguments. |
| `--no-cache` | false | Skip cache. |
| `--path`, `--config`, `--team` | documented | Root, config, team. |

No output wrapper is registered.

## SDK parameter tables

### `novita.template.build(template, name, ...)`

JS: `build(template, name, opts?)`. No general `timeoutMs` parameter: `requestTimeoutMs` controls individual API requests.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `template` | `template` | Template / TemplateFinal | Required | Builder definition to build and deploy. |
| `name` | `name` | string | Required unless deprecated alias provided | Template name, optionally `name:tag`. |
| `alias` | `alias` | string | Deprecated alternative | Legacy name field; prefer positional name. JS legacy overload takes `{ alias, ... }` as second argument. |
| `tags` | `tags` | string array | Unset | Additional tags assigned to build. |
| `cpu_count` | `cpuCount` | integer | 2 | Sandbox vCPU allocation. |
| `memory_mb` | `memoryMB` | integer | 1024 | Sandbox memory in MB. |
| `skip_cache` | `skipCache` | boolean | false | Force entire template rebuild. |
| `on_build_logs` | `onBuildLogs` | callback(LogEntry) | Unset | Stream build log entries. |
| `**opts` | `opts` fields | Connection options | Optional | [Resource API options](common-parameters.md#resource-api-options); Python `ApiParams`, JS `ConnectionOpts`. |
