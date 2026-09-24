# Secrets

Secrets securely store sensitive values (API keys, tokens, passwords) for use inside a sandbox **without ever exposing the real value to the sandbox**. The sandbox env var holds an opaque **placeholder** (e.g. `novita_secret_<random>`); the outbound proxy substitutes the real value only in **HTTPS request header values** sent to hosts on the Secret's allow list. The real value is never in the sandbox's env, filesystem, or process args.

Secrets are team-scoped and managed via the `Secret` class. All CLI commands are under the `novita secret` group (modern domains only) — set `NOVITA_API_KEY` in the environment first.

```python
from novita_sandbox import Sandbox, Secret   # Python
```
```typescript
import { Sandbox, Secret } from 'novita-sandbox'  // JS / TS
```

> **API shape differs:** Python `create`/`update` take keyword args (`name=`, `value=`, `hosts=`); JS `create`/`update` take a single params object (`{ name, value, hosts, description }`). Both return `SecretBinding` metadata (fields: `name`, `hosts`, `description`) — never the real value. `get`/`delete` take the name string. `Secret` has async variants (`AsyncSecret` in Python).

## Create

Creates a team-scoped Secret and its first immutable version. `hosts` is the allow list — hostname only (no protocol/path/port/query); wildcards support the `*.` prefix only. Duplicate active name → `409 Conflict`.

**Python**
```python
binding = Secret.create(
    name="openai-prod",
    value="sk-example",
    hosts=["api.openai.com"],
    description="Example API key",
)
```

**JavaScript / TypeScript**
```typescript
const binding = await Secret.create({
  name: 'openai-prod',
  value: 'sk-example',
  hosts: ['api.openai.com'],
  description: 'Example API key',
})
```

**CLI**
```bash
# Key/value sources: --from-env (read a local env var), --from-stdin, or --from-value.
novita secret create openai-prod --host api.openai.com --from-env OPENAI_API_KEY
echo "sk-example" | novita secret create openai-prod --host api.openai.com --from-stdin
novita secret create openai-prod --host api.openai.com --from-value sk-example \
  --description "Example API key"    # --from-value is visible in shell history
```

## Use in a sandbox

Reference the Secret by name via `secret_envs` (Python) / `secretEnvs` (JS) when creating the sandbox. The env var holds a placeholder; the proxy swaps in the real value for allow-listed hosts.

**Python**
```python
sandbox = Sandbox.create(secret_envs={"OPENAI_API_KEY": "openai-prod"})
try:
    result = sandbox.commands.run(
        'curl -s https://api.openai.com/v1/models '
        '-H "Authorization: Bearer $OPENAI_API_KEY"'
    )
    print(result.stdout)
finally:
    sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
const sandbox = await Sandbox.create({ secretEnvs: { OPENAI_API_KEY: 'openai-prod' } })
try {
  const result = await sandbox.commands.run(
    'curl -s https://api.openai.com/v1/models -H "Authorization: Bearer $OPENAI_API_KEY"'
  )
  console.log(result.stdout)
} finally {
  await sandbox.kill()
}
```

**CLI**
```bash
# Map a sandbox env var to a stored secret name (repeatable).
novita sandbox create base --secret-env OPENAI_API_KEY=openai-prod
```

> `envs` and `secretEnvs`/`secret_envs` cannot define the same env var name.

### Substitution boundaries

| Where the placeholder is sent | Replaced with the real value? |
|-------------------------------|-------------------------------|
| HTTPS request header value, allow-listed host (e.g. `Authorization: Bearer ...`) | Yes |
| HTTPS request body, including JSON/form fields | No |
| URL query parameter | No |
| Plain HTTP request | No |
| WebSocket content | No |
| Request to a host outside the allow list | No |

The non-replaced content is forwarded as-is. Use an upstream API that accepts the credential in an HTTPS header; a placeholder cannot serve as a local signing key or a credential an application must read in plaintext. If authentication fails, check the destination hostname, protocol, and where the application places the credential before changing the Secret. A Secret's host allow list controls substitution; it does not replace the sandbox's [network egress rules](sandbox-network.md).

`secret_envs` values are **Secret names**, not raw credentials. An unresolved Secret name causes sandbox creation to fail. Killing the sandbox does not delete the reusable Secret.

## Get

`Secret.get(name)` fetches an active Secret's metadata (`SecretBinding`, no real value).
```python
got = Secret.get("openai-prod")
```
```typescript
const got = await Secret.get('openai-prod')
```
```bash
novita secret get openai-prod
```

## List

`Secret.list()` returns metadata for all active Secrets in the team (no values).
```python
for binding in Secret.list():
    print(binding.name, binding.hosts)
```
```typescript
const secrets = await Secret.list()
for (const b of secrets) console.log(b.name, b.hosts)
```
```bash
novita secret list                 # alias: secret ls
novita secret list --all           # all pages, no pagination
novita secret list --limit 50 --page 1
novita secret list --output json   # JSON output (--output takes pretty|json|yaml)
```

## Update

Creates a new immutable version and makes it active. Running executions keep the version/policy they started with; new/resumed/cloned executions use the latest active version.
```python
Secret.update(name="openai-prod", value="sk-new", hosts=["api.openai.com"])
```
```typescript
await Secret.update({ name: 'openai-prod', value: 'sk-new', hosts: ['api.openai.com', '*.openai.com'] })
```
```bash
novita secret update openai-prod --host api.openai.com --from-env OPENAI_API_KEY
```

## Delete

`Secret.delete(name)` deletes an active Secret and returns the deleted name. Already-running sandboxes are not rewritten, but the Secret can no longer be referenced by new create / resume / clone operations.
```python
deleted_name = Secret.delete("openai-prod")
```
```typescript
const deletedName = await Secret.delete('openai-prod')
```
```bash
novita secret delete openai-prod -y                 # alias: secret rm; -y skips confirmation
novita secret delete openai-prod my-other-secret -y # delete several at once
```

> `create`/`update` CLI require **exactly one** value source (`--from-env`, `--from-stdin`, or `--from-value`), and `--host <host>` is required (repeatable). The CLI never prints the real secret value — only metadata (`hosts`, `placeholder`, `status`). Old `--format json` / `--json` are deprecated aliases for `--output json`.

Related: [sandbox-create.md](sandbox-create.md) (sandbox `secret_envs`/`secretEnvs`) · [sandbox-run-command.md](sandbox-run-command.md)

Source for substitution boundaries: [Use Secrets in a Sandbox](https://docs.novita.ai/guides/sandbox-secret-sandbox-use). Reviewed 2026-09-17.


## CLI parameters

### `novita secret create|update <name>`

| Parameter | Required / default | Purpose |
|---|---|---|
| `<name>` | required | Secret name. |
| `--host <host>` | required, repeatable | Allowed HTTPS hostname; no scheme/path/port; wildcard prefix supported. |
| exactly one of `--from-env <env>`, `--from-stdin`, `--from-value <value>` | required | Secret value source. |
| `--description <description>` | optional | Secret description. |
| `-o, --output`, `-f, --format`, `--json` | pretty / deprecated | Output format. |

### `novita secret list`

| Parameter | Required / default | Purpose |
|---|---|---|
| `-a, --all` | false | Fetch all pages. |
| `--limit <limit>` | `20`; positive | Page size. |
| `--page <page>` | `1` | One-based page. |
| `-o, --output`, `-f, --format`, `--json` | pretty / deprecated | Output format. |

### `novita secret get <name>`

`<name>` is required. Supports `-o`, `-f`, and `--json`; the value is never printed by the API.

### `novita secret delete <names...>`

`<names...>` is required; `-y, --yes` skips confirmation. Supports `-o`, `-f`, and `--json`.

## SDK parameter tables

### `novita.secret.create(...)` / `Secret.create(...)`

Python fields are **keyword-only**. JS: `create(params, opts?)` / `update(params, opts?)`, with all four fields in params. Update requires the full name/value/hosts payload, not a partial patch.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Secret name; identifies entry being created. |
| `value` | `value` | string | Required | Real credential value. Not returned by get/list. |
| `hosts` | `hosts` | string array | Required | Allowed HTTPS destination hostnames, no scheme/path/port; supports leading wildcard. |
| `description` | `description` | string | Unset | Human-readable description. |
| Connection keyword args | Separate `opts` object | Connection options | Optional | [Secret API options](common-parameters.md#secret-api-options); Python subset is smaller than other resources. |

### `novita.secret.update(...)` / `Secret.update(...)`

Python fields are **keyword-only**. JS: `create(params, opts?)` / `update(params, opts?)`, with all four fields in params. Update requires the full name/value/hosts payload, not a partial patch.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Secret name; identifies entry being updated. |
| `value` | `value` | string | Required | Real credential value. Not returned by get/list. |
| `hosts` | `hosts` | string array | Required | Allowed HTTPS destination hostnames, no scheme/path/port; supports leading wildcard. |
| `description` | `description` | string | Unset | Human-readable description. |
| Connection keyword args | Separate `opts` object | Connection options | Optional | [Secret API options](common-parameters.md#secret-api-options); Python subset is smaller than other resources. |

### `novita.secret.get(name, ...)` / `Secret.get(name, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Secret name. |
| Connection keyword args | Separate `opts` object | Connection options | Optional | [Secret API options](common-parameters.md#secret-api-options); Python subset is smaller than other resources. |

### `novita.secret.delete(name, ...)` / `Secret.delete(name, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Secret name. |
| Connection keyword args | Separate `opts` object | Connection options | Optional | [Secret API options](common-parameters.md#secret-api-options); Python subset is smaller than other resources. |

### `novita.secret.list(...)` / `Secret.list(opts?)`

No filter, page, or limit parameters in the SDK. CLI pagination is separate.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| Connection keyword args | Separate `opts` object | Connection options | Optional | [Secret API options](common-parameters.md#secret-api-options); Python subset is smaller than other resources. |
