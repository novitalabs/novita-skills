# Secured access

`secure` authenticates traffic to the **sandbox controller** (envd), which exposes command execution, filesystem operations, and other control capabilities. It is different from authentication for an application served at `sandbox.getHost(port)` / `get_host(port)`.

The official guide documents secure access as enabled by default from SDK v2.0.0. These examples target the default v2 region; when working with the legacy v1 region, check its compatibility behavior rather than assuming identical defaults.

## Create with controller authentication

The SDK manages the controller access token for SDK operations. Keep `NOVITA_API_KEY` on the trusted machine or backend.

```python
sandbox = novita.sandbox.create(secure=True)
print(sandbox.commands.run("echo authenticated").stdout)
sandbox.kill()
```

```typescript
const sandbox = await novita.sandbox.create({ secure: true })
try {
  console.log((await sandbox.commands.run('echo authenticated')).stdout)
} finally {
  await sandbox.kill()
}
```

```bash
novita sandbox create base --secure -d
```

## Migrate older custom templates

Templates created with **envd earlier than v0.2.0** must be rebuilt to support secure access. Inspect the template's `Envd version` with `novita template list` or in the dashboard, rebuild it with the current template flow, then create a sandbox from the rebuilt template.

For a deliberate temporary compatibility workaround, creation accepts `secure=False` (Python), `{ secure: false }` (JS), or `--no-secure` (CLI). This removes controller authentication; someone with the sandbox ID may be able to invoke its control interfaces. Rebuilding the template is the production migration path. Do not disable `secure` to fix an application's preview URL.

## Service access and file sharing

| Goal | Use |
|------|-----|
| Authenticate SDK commands and filesystem operations | `secure=True` / `secure: true` |
| Make an application preview publicly accessible | `network.allow_public_traffic=True` / `network.allowPublicTraffic: true` |
| Require a traffic token for an application URL | `network.allow_public_traffic=False` / `network.allowPublicTraffic: false` |
| Let a client transfer a file without Novita credentials | Generate a short-lived signed upload/download URL on the trusted backend |

`secure: true` does not by itself make application ports private. Likewise, public application traffic does not require disabling controller authentication. See [network access](sandbox-network.md) for service URLs and [file transfers](fs-upload-download.md) for signed URLs.

Source: [Secured access](https://docs.novita.ai/guides/sandbox-secured-access). Reviewed 2026-09-17; creation options cross-checked against the current repository.

## SDK parameter table

| Parameter | Type | Required / default | Purpose |
|---|---|---|---|
| `secure` | boolean | true on modern domains; Python desktop differs | Protect controller traffic with an access token. |
| `allow_public_traffic` / `allowPublicTraffic` | boolean | true | Service URL access policy; false requires a traffic access token. |
| `traffic_access_token` / `trafficAccessToken` | string | server generated when restricted | Token for restricted service URLs; handle as a credential. |
