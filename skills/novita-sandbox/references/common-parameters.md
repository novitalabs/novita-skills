# Shared SDK parameters

Parameter tables describe the current repository, checked 2026-09-17. Product semantics are cross-checked with the official guides. Newer source-only options may require a newer installed SDK; these tables do not imply every option existed in 2.1.0.

Python examples use keyword arguments unless a signature shows positional arguments. JS methods take the named positional arguments followed by an options object; option fields are not additional positional arguments. A dash means that language has no corresponding parameter. Optional means omit it (`None` / `undefined`); it does not imply that an empty string, zero, or empty list is equivalent. Defaults marked **server** are not set by the SDK.

Only the shared group explicitly referenced by a method applies to it. In particular, SDK volume/secret lists do not acquire CLI `page`/`limit` flags, and command/file operations do not accept per-call API keys.

## Novita constructor

Python: `Novita(api_key=..., ...)`; JS: `new Novita({ apiKey: ..., ... })`. All arguments are optional; authenticated requests still need valid credentials. Namespace calls inherit client options and may override the subset their method accepts.

### `Novita(...)` / `new Novita(opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `api_key` | `apiKey` | string | `NOVITA_API_KEY` | API credential. |
| `access_token` | `accessToken` | string | `NOVITA_ACCESS_TOKEN` | Account access token. |
| `domain` | `domain` | string | `NOVITA_DOMAIN`, else `us-phx-1.sandbox.novita.ai` | Sandbox region domain; see [regions](region.md). |
| `api_url` | `apiUrl` | string | `NOVITA_API_URL`, else `https://api.<domain>` | API base URL override; internal/custom deployments. |
| `sandbox_url` | `sandboxUrl` | string | `NOVITA_SANDBOX_URL`, else derived host | Controller URL override; internal/local development. |
| `request_timeout` | `requestTimeoutMs` | number | Python 60 s / JS 60000 ms; legacy 1800 s / 1800000 ms | HTTP/RPC request deadline, not sandbox lifetime. `0` disables. |
| `headers` | `headers` | string map | Empty | Additional API request headers. |
| `debug` | `debug` | boolean | `NOVITA_DEBUG`, else false | Local development mode; changes endpoint defaults. |
| `proxy` | — | httpx proxy config | None | Python HTTP proxy configuration. |
| `extra_sandbox_headers` | — | string map | Empty | Python additional controller request headers. |
| — | `logger` | Logger | None | JS request/RPC logging implementation. |
| — | `sync` | boolean | Unset; deprecated | Legacy pause wait mode; ignored on modern domains. |

## Resource API options

Tables referencing this group accept Python `ApiParams`: `api_key`, `domain`, `api_url`, `sandbox_url`, `headers`, `debug`, `proxy`, `request_timeout`. JS accepts all `ConnectionOpts` fields in the constructor table. Python constructor-only `access_token` and `extra_sandbox_headers` are not declared per-method `ApiParams`.

## Sandbox API options

Python accepts the `ApiParams` group above. JS `SandboxApiOpts` accepts only `apiKey`, `headers`, `debug`, `domain`, `requestTimeoutMs`, and deprecated `sync`. JS sandbox **create/connect** accept full `ConnectionOpts` instead. Do not assume all constructor options are accepted by sandbox list, kill, or metrics.

## Secret API options

Python secret methods accept only `api_key`, `api_url`, `domain`, `request_timeout` (all optional); the facade filters inherited options to these fields. JS secret methods take a separate optional `ConnectionOpts` object, as in `secret.create(params, opts)`.

## File request options

File operations accept only `user` (OS user; template default) and `request_timeout` / `requestTimeoutMs` (request deadline in seconds / milliseconds, inherited by default, `0` disables), plus operation-specific fields listed in their tables. Do not add `envs`, API credentials, or command timeouts here.

## Time and size units

| Parameter family | Unit / meaning |
|---|---|
| Sandbox/command/PTY/watch `timeout` vs `timeoutMs` | Python seconds / JS milliseconds. `0` disables command/PTY/watch deadlines, not a documented infinite sandbox lifetime. |
| `request_timeout` vs `requestTimeoutMs` | Python seconds / JS milliseconds; separate from operation lifetime. |
| URL `use_signature_expiration` / `useSignatureExpiration` | **Seconds in both SDKs**. |
| Events `start_time`/`end_time` vs `startTime`/`endTime` | Unix timestamps in **seconds in both SDKs**. |
| Metadata `idle_timeout` | String containing **seconds**. |
| Volume `quota_size_gib` / `quotaSizeGiB` | Capacity quota in GiB; returned usage is bytes. |
| Sandbox `resize` memory | Additional MiB, not target total memory. |

Source locations: `sdk-js/src/core/connectionConfig.ts`, `sdk-js/src/core/sandbox/sandboxApi.ts`, `sdk-python/src/novita_sandbox/core/connection_config.py`, and the two `core/client` facades. Resolve version differences against the installed package's signatures before copying newer options.
