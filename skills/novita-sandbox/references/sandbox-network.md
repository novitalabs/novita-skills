# Network access

Outbound internet access, inbound service access, and sandbox controller authentication are separate settings:

| Setting (Python / JS) | Controls |
|----------------------|----------|
| `allow_internet_access` / `allowInternetAccess` | Outbound internet access; enabled by default. |
| `network.allow_out` / `network.allowOut`, `network.deny_out` / `network.denyOut` | Allowed and denied outbound destinations. |
| `network.allow_public_traffic` / `network.allowPublicTraffic` | Whether service URLs can be reached without a traffic access token. |
| `network.mask_request_host` / `network.maskRequestHost` | Host header forwarded to the service inside the sandbox. |
| `secure` | Authentication of the sandbox controller; see [secured access](sandbox-secured-access.md). |

The `network` options and runtime network updates require a v2 region; see [region.md](region.md). Examples assume an initialized `Novita` client.

## Disable outbound internet

```python
sandbox = novita.sandbox.create(allow_internet_access=False)
```

```typescript
const sandbox = await novita.sandbox.create({ allowInternetAccess: false })
```

```bash
novita sandbox create base --no-internet -d
```

Disabling outbound internet does not configure authentication for incoming service requests. Use the settings below for that.

## Restrict outbound destinations at creation

To deny all except selected destinations, combine a deny-all rule with an allow list:

```python
sandbox = novita.sandbox.create(
    network={
        "deny_out": ["0.0.0.0/0"],
        "allow_out": ["1.1.1.1", "8.8.8.0/24"],
    },
)
```

```typescript
const sandbox = await novita.sandbox.create({
  network: {
    denyOut: ['0.0.0.0/0'],
    allowOut: ['1.1.1.1', '8.8.8.0/24'],
  },
})
```

The official guide also supports hostnames and wildcard domains in the creation-time allow list: replace the allowed destinations with `['api.example.com', '*.github.com']`. Do not add a URL scheme or path.

```bash
# Creation flags accept comma-separated lists and can be repeated.
novita sandbox create base -d \
  --deny-out 0.0.0.0/0 --allow-out 1.1.1.1,8.8.8.0/24
```

## Update a running sandbox's egress rules

Send the desired allow/deny lists together. This operation updates egress rules, not `secure`, public traffic, or the Host mask.

```python
sandbox.set_network(allow_out=["1.1.1.1"], deny_out=["0.0.0.0/0"])
# By ID: novita.sandbox.set_network(sandbox_id, allow_out=["1.1.1.1"], deny_out=["0.0.0.0/0"])
```

```typescript
await sandbox.setNetwork({ allowOut: ['1.1.1.1'], denyOut: ['0.0.0.0/0'] })
// By ID: await novita.sandbox.setNetwork(sandboxId, { allowOut: ['1.1.1.1'], denyOut: ['0.0.0.0/0'] })
```

```bash
novita sandbox network <sandboxID> --deny-out 0.0.0.0/0 --allow-out 1.1.1.1
```

Calling `sandbox.set_network()` / `sandbox.setNetwork()` or `novita sandbox network <sandboxID>` with neither list clears the egress rules. Do this only when the intended policy is unrestricted egress.

## Reach a service through its public URL

`get_host(port)` / `getHost(port)` returns a hostname, not a URL, and does not start a service. Bind the server to `0.0.0.0` on that port, then prefix the hostname with `https://`. No separate port-publishing call is needed.

For an intentionally public preview, explicitly allow public traffic while keeping the controller secured:

```python
sandbox = novita.sandbox.create(
    secure=True,
    network={"allow_public_traffic": True},
)
sandbox.commands.run(
    "python3 -m http.server 3000 --bind 0.0.0.0",
    background=True,
    timeout=0,
)
print(f"https://{sandbox.get_host(3000)}")
# Keep the sandbox alive while the preview is needed; kill it when finished.
```

```typescript
const sandbox = await novita.sandbox.create({
  secure: true,
  network: { allowPublicTraffic: true },
})
await sandbox.commands.run('python3 -m http.server 3000 --bind 0.0.0.0', {
  background: true,
  timeoutMs: 0,
})
console.log(`https://${sandbox.getHost(3000)}`)
// Keep the sandbox alive while the preview is needed; kill it when finished.
```

```bash
novita sandbox create base --secure --public-traffic -d
```

Public traffic means the service URL does not require a platform traffic token; add application authentication if the service needs it. For a restricted service, set `allow_public_traffic=False` / `allowPublicTraffic: false` instead. In the current SDK, the returned `sandbox.traffic_access_token` / `sandbox.trafficAccessToken` is sent as the `E2B-Traffic-Access-Token` request header by the trusted caller. This is separate from the controller's access token. Treat it as a credential, and do not print or embed it in a public URL.

The command's `timeout=0` / `timeoutMs: 0` disables only the command timeout; the sandbox's own lifetime and idle timeout still apply. A background command returning does not prove the server is ready: check readiness before sending requests, or use a [template start command with a ready check](template-define.md#startup-and-readiness).

## Customize the forwarded Host header

Useful for applications expecting `localhost:<port>` rather than the sandbox's external hostname:

```python
sandbox = novita.sandbox.create(
    network={"mask_request_host": "localhost:${PORT}"},
)
```

```typescript
const sandbox = await novita.sandbox.create({
  network: { maskRequestHost: 'localhost:${PORT}' },
})
```

Keep `${PORT}` literal (use a normal quoted JS string); the platform substitutes the service port. This changes the forwarded Host header, not the public hostname or DNS.

Sources: [Internet access](https://docs.novita.ai/guides/sandbox-internet-access), [CLI network](https://docs.novita.ai/guides/sandbox-cli-network). Reviewed 2026-09-17; SDK method names and traffic-token header cross-checked against the current repository.


## CLI parameters

### `novita sandbox network <sandboxID>`

| Parameter | Required / default | Purpose |
|---|---|---|
| `<sandboxID>` | required | Target sandbox. |
| `--allow-out <destination>` | repeatable | Allowed outbound IP/CIDR destination. |
| `--deny-out <destination>` | repeatable | Denied outbound IP/CIDR destination. |
| `-o, --output`, `-f, --format`, `--json` | pretty / deprecated | Output format. |

## SDK parameter tables

### `network` on sandbox creation

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `allow_out` | `allowOut` | string array | Unset: allow all | Allowed outbound IP/CIDR destinations. |
| `deny_out` | `denyOut` | string array | Unset | Denied outbound IP/CIDR destinations. |
| `allow_public_traffic` | `allowPublicTraffic` | boolean | true | Whether service URLs work without traffic access token. |
| `mask_request_host` | `maskRequestHost` | string | Default sandbox service host | Forwarded Host header; `${PORT}` is substituted. |

### `sandbox.set_network(...)` / `sandbox.setNetwork(opts)`

Only egress rules can be updated here; these are flat method options, not a nested `network` argument. At least one rule list must be supplied.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `allow_out` | `allowOut` | string array | Unset | Update outbound allow rules. |
| `deny_out` | `denyOut` | string array | Unset | Update outbound deny rules. |
| `**opts` | `opts` fields | Connection options | Optional | [Sandbox API options](common-parameters.md#sandbox-api-options); inherited client settings unless overridden. |
