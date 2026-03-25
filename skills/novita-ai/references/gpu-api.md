# Novita AI GPU Cloud API Reference

Base: `https://api.novita.ai/gpu-instance/openapi/v1`

## Table of Contents
- [Instance Management](#instance-management)
- [Products & Clusters](#products--clusters)
- [Templates](#templates)
- [Network Storage](#network-storage)
- [Serverless Endpoints](#serverless-endpoints)
- [Account & Billing](#account--billing)

## Instance Management

### Create Instance
`POST /gpu/instance/create`

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `productId` | string | yes | GPU product ID (from `/products`) |
| `gpuNum` | integer | yes | Number of GPUs |
| `imageUrl` | string | yes | Docker image (e.g., `pytorch/pytorch:latest`) |
| `rootfsSize` | integer | no | Root filesystem size in GB |
| `name` | string | no | Instance name |
| `ports` | array | no | Port mappings |
| `envs` | array | no | `[{key, value}]` environment variables |
| `tools` | array | no | Pre-installed tools |
| `billingType` | string | no | Billing mode |
| `networkStorageId` | string | no | Attach network storage |
| `command` | string | no | Startup command |

### Create CPU Instance
`POST /cpu/instance/create` — Same structure, for CPU-only workloads.

### List Instances
`GET /gpu/instance/list?pageSize=20&pageNum=1`

Optional filters: `name`, `status`

### Get Instance
`GET /gpu/instance/get?instanceId=X`

### Instance Actions

| Action | Method | Path | Body |
|--------|--------|------|------|
| Start | POST | `/gpu/instance/start` | `{instanceId}` |
| Stop | POST | `/gpu/instance/stop` | `{instanceId}` |
| Restart | POST | `/gpu/instance/restart` | `{instanceId}` |
| Delete | POST | `/gpu/instance/delete` | `{instanceId}` |
| Edit | POST | `/gpu/instance/update` | `{instanceId, ports, expandRootDisk}` |
| Upgrade | POST | `/gpu/instance/upgrade` | `{instanceId, productId}` |

### Instance Metrics
`GET https://api.novita.ai/openapi/v1/metrics/gpu/instance?instanceId=X&interval=5m`

## Products & Clusters

### List GPU Products
`GET /products`

Optional filters: `gpuNum`, `productName`, `billingMethod`

Returns available GPU types with pricing, VRAM, and availability.

### List CPU Products
`GET /cpu/products`

Optional filter: `productName`

### List Clusters (Data Centers)
`GET /clusters`

Returns available regions/data centers.

## Templates

Reusable instance configurations. Template CRUD is free — safe for testing.

### Create Template
`POST /template/create`

```json
{
  "template": {
    "name": "my-template",
    "type": "private",
    "channel": "private",
    "image": "pytorch/pytorch:latest",
    "rootfsSize": 20,
    "startCommand": "python main.py",
    "minCudaVersion": "12.0",
    "envs": [{"key": "DEBUG", "value": "1"}]
  }
}
```

### List Templates
`GET /templates?channel=private&pageSize=20&pageNum=1`

Channels: `official`, `community`, `private`

### Get Template
`GET /template?templateId=X`

### Update Template
`POST /template/update` — Same structure as create, with `template.Id` field.

### Delete Template
`POST /template/delete` — `{templateId}`

## Network Storage

Persistent storage that can be attached to GPU instances.

### Create Storage
`POST /networkstorage/create`

```json
{"clusterId": "xxx", "storageName": "my-storage", "storageSize": 100}
```

### List Storage
`GET /networkstorages`

### Delete Storage
`POST /networkstorage/delete` — `{id}`

## Serverless Endpoints

Auto-scaling GPU endpoints for inference workloads.

### Create Endpoint
`POST /endpoint/create`

```json
{
  "endpoint": {
    "name": "my-endpoint",
    "appName": "my-app",
    "workerConfig": {
      "minNum": 0,
      "maxNum": 3,
      "freeTimeout": 300,
      "maxConcurrent": 10,
      "gpuNum": 1
    },
    "ports": [{"containerPort": 8080, "protocol": "TCP"}],
    "policy": {"type": "queue", "value": 5},
    "image": "my-inference-image:latest"
  }
}
```

### List Endpoints
`GET /endpoint/list?pageSize=20&pageNum=1`

### Get Endpoint
`GET /endpoint/get?id=X`

### Update Endpoint
`POST /endpoint/update` — Partial update with `{id, workerConfig, ports, policy, image}`.

### Delete Endpoint
`POST /endpoint/delete` — `{name}`

### Endpoint Limits
`GET /endpoint/limit` — Query account-level endpoint limits.

## Account & Billing

Different base path: `https://api.novita.ai/openapi/v1/billing`

### Get Balance
`GET /openapi/v1/billing/balance/detail`

Response fields: `availableBalance`, `cashBalance`, `creditLimit`, `outstandingInvoices`

All amounts in units of 0.0001 USD (divide by 10000 for dollars).

### Monthly Bill
`GET /openapi/v1/billing/monthly/bill`

### Usage-Based Billing
`GET /openapi/v1/billing/bill/list`

Query params: `cycleType` (Hour/Day/Week/Month), `productCategory` (summary/gpu/llm/serverless/cloud_storage/gen_api), `startTime`, `endTime`

### Fixed-Term Billing
`GET /openapi/v1/billing/fixed-term/bill`
