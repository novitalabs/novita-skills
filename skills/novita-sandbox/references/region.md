# Regions

Novita Sandbox is served from two regions. The region determines the **API domain** the SDK, CLI, and sandboxes use — it is configured at connection time, not per-sandbox.

| Region | Version | Domain | Notes |
|--------|---------|--------|-------|
| `us-phx-1` | v2 | `us-phx-1.sandbox.novita.ai` | **Default** used by the current SDK and CLI. Full feature set, including **Secrets** and **Snapshots**. |
| `us-virginia-1` | v1 | `sandbox.novita.ai` | Legacy region. Selected via the `NOVITA_DOMAIN` environment variable. |

The v2 region (`us-phx-1`) is the default and recommended: it adds Secrets and Snapshots on top of v1. Both regions are supported by the documented SDK and CLI.

> **Legacy-domain limits:** features marked *modern domains only* (Secrets, Snapshots, Volumes) are **not available** on the v1 region. If a command fails with "not supported on legacy domains," the configured region is v1 — switch to v2 (`us-phx-1`) to use those features.

## Default (v2 / us-phx-1)

No configuration needed — this is the SDK and CLI default.

```bash
# No region config required. The domain defaults to us-phx-1.sandbox.novita.ai.
novita sandbox list
```

## Select the v1 region

Set `NOVITA_DOMAIN` to the legacy domain (`sandbox.novita.ai`). This is the one thing a user needs to change to switch regions — it works for both the SDK and the CLI.

```bash
export NOVITA_DOMAIN=sandbox.novita.ai
novita sandbox list
```

**Python**
```python
import os
os.environ["NOVITA_DOMAIN"] = "sandbox.novita.ai"
```

**JavaScript / TypeScript**
```typescript
process.env.NOVITA_DOMAIN = 'sandbox.novita.ai'
```

## Connectivity notes

- The **API token** is a credential stored in `~/.novita/config.json`, independent of the region. The **domain** is a connection address. They are separate — see [cli-reference.md](cli-reference.md) for `auth login`/`auth configure`.
- The sandbox URL is derived from the same domain: `https://<port>-<sandboxID>.<domain>`.
- `NOVITA_DOMAIN` is read at connection build time — set it before creating the SDK client / running the CLI command.

Related: [sandbox-create.md](sandbox-create.md) · [secret.md](secret.md) (modern-domain only) · [snapshot.md](snapshot.md) (modern-domain only)

## Connection parameter table

| Parameter | Type | Required / default | Purpose |
|---|---|---|---|
| `NOVITA_DOMAIN` / `--domain` | string | `us-phx-1.sandbox.novita.ai` | Select region/API domain. |
| `NOVITA_API_URL` / `--api-url` | URL | derived from domain | Override API endpoint for custom/local deployments. |
| `NOVITA_API_KEY` / `--api-key` | string | required unless access token/config | API authentication credential. |
