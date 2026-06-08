# GPU Guide

Novita AI offers two GPU products for different use cases.

## Table of Contents
- [Product Comparison](#product-comparison)
- [GPU Instance](#gpu-instance)
- [Serverless GPU](#serverless-gpu)
- [Common Tasks](#common-tasks)
- [Resources](#resources)

## Product Comparison

| Feature | GPU Instance | Serverless GPU |
|---------|-------------|----------------|
| **Best for** | Long-running, predictable workloads | Burstable, sporadic tasks |
| **Control** | Full VM control | Managed endpoint |
| **Scaling** | Manual | Auto-scaling |
| **Billing** | Per-second while running | Per-request |
| **Startup** | Seconds | Cold start varies |

---

## GPU Instance

Dedicated virtual machines with full GPU control.

## Features

- **Fast startup**: Instances start in seconds
- **Built-in templates**: Pre-configured for common AI tasks
- **Global regions**: Deploy close to users
- **Free storage**: Free-tier allocation depends on current product policy
- **Per-second billing**: Pay only for running time
- **Cost profile**: Can be cost-effective versus major cloud providers, depending on workload and region

## Storage Types

| Type | Mount | Persists on Stop | Persists on Image Save | Free Tier |
|------|-------|------------------|------------------------|-----------|
| Container Disk | `/` | No | Yes | Varies by current plan |
| Volume Disk | `/workspace` | No | No | None |
| Network Volume | `/network` | Yes | Independent | None |

**Recommendation**: Use Network Volume for data that must persist across instance restarts.

## Quick Start

### 1. Create Instance

1. Go to https://novita.ai/gpu-instance/console/explore
2. Choose a GPU template (e.g., PyTorch, ComfyUI, Ollama)
3. Select GPU type and region
4. Click "Create"

### 2. Connect

**SSH:**
```bash
ssh root@<instance-ip> -p <port>
```

**Web Terminal**: Available in console UI

**JupyterLab**: Many templates include JupyterLab at port 8888

### 3. Save Image

Before stopping, save your environment:
1. Go to instance details
2. Click "Save Image"
3. Use saved image to create new instances

## Pricing

### Compute
- Billed per-second, settled hourly
- Billing starts at "Pulling" status
- Pricing varies by region, GPU type, and product policy
- Always check live pricing: https://novita.ai/gpu-instance/pricing

### Storage
- Storage pricing can change; verify current rates in the pricing page above

---

## Serverless GPU

Fully managed GPU endpoints that auto-scale.

## Features

- **Auto-scaling**: Scale to zero when idle, scale up on demand
- **Pay per request**: Only pay for actual compute time
- **No infrastructure**: No VM management
- **REST API**: Simple HTTP endpoints

## Quick Start

### 1. Create Endpoint

1. Go to https://novita.ai/gpus-console/serverless
2. Prepare a Docker container image with your model/code
3. Configure:
   - GPU type
   - Min/max replicas
   - Timeout settings
4. Deploy

### 2. Call Endpoint

```bash
curl -X POST https://api.novita.ai/serverless/<endpoint-id>/run \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input": {"prompt": "Hello"}}'
```

### 3. Async Requests

For long-running tasks, first submit the async job, then poll the status endpoint.
```bash
curl -X POST https://api.novita.ai/serverless/<endpoint-id>/runsync \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -d '{"input": {...}}'

curl https://api.novita.ai/serverless/<endpoint-id>/status/<job-id> \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

## Scaling Configuration

| Setting | Description |
|---------|-------------|
| Min replicas | Minimum always-on instances (0 = scale to zero) |
| Max replicas | Maximum concurrent instances |
| Scale-up threshold | Queue depth to trigger scale-up |
| Idle timeout | Time before scaling down |

---

## Common Tasks

### Check GPU Usage
```bash
pip install py3nvml
py3smi  # Use instead of nvidia-smi in containers
```

### CUDA Compatibility
CUDA is backward compatible. If you need CUDA 12.1, any version >= 12.1 works.

### Troubleshooting
- Check "System Logs" and "Instance Logs" in console
- For save image failures, verify container registry auth
- Contact support: https://discord.gg/YyPRAzwp7P

---

## Resources

- **GPU Console**: https://novita.ai/gpu-instance/console
- **Serverless Console**: https://novita.ai/gpus-console/serverless
- **Pricing**: https://novita.ai/gpu-instance/pricing
- **Full Docs**: https://novita.ai/docs/guides/gpu-instance-overview
Last verified: 2026-02-09
