# Common Issues & FAQ

Last verified: 2026-02-09

## Table of Contents
- [API Issues](#api-issues)
- [Billing Issues](#billing-issues)
- [GPU Instance Issues](#gpu-instance-issues)
- [Sandbox Issues](#sandbox-issues)
- [Integration Issues](#integration-issues)
- [Get Help](#get-help)

## API Issues

### Authentication Failed
- Ensure header format: `Authorization: Bearer <API_KEY>` (not just the key)
- Check API key is valid at https://novita.ai/settings/key-management
- API keys can be disabled or deleted - verify status

### Model Not Found
- Model names are case-sensitive
- Format: `provider/model-name` (e.g., `deepseek/deepseek-r1`)
- Query available models: `GET https://api.novita.ai/openai/v1/models`

### Rate Limit Exceeded
- Rate limits vary by account tier and model
- Confirm current limits in console/docs before tuning client behavior
- Use exponential backoff for retries
- Respect `429` responses and `Retry-After` headers
- Contact support for higher limits

### Request Timeout
- Use streaming mode for long outputs: `"stream": true`
- Reduce `max_tokens` if response is too long
- Check https://status.novita.ai for service status

## Billing Issues

### Insufficient Balance
- Check balance at https://novita.ai/billing
- Enable [Auto Top-up](https://novita.ai/docs/guides/auto-top-up)
- Set [Low Balance Alert](https://novita.ai/docs/guides/low-balance-alert)

### Payment Failed
Common causes:
- Card issuer rejection (check with bank)
- Card expired or frozen
- Insufficient card balance
- Risk control (try different card)

## GPU Instance Issues

### Instance Won't Restart
After stopping, resources may be preempted. Solution:
1. [Save image](https://novita.ai/docs/guides/gpu-instance-save-image) of your instance
2. Create new instance from saved image
3. Use Network Volume for persistent data

### Storage Types

| Type | Persists on Stop | Persists on Save Image | Mount Point |
|------|------------------|------------------------|-------------|
| Container Disk | No | Yes | `/` |
| Volume Disk | No | No | `/workspace` |
| Network Volume | Yes | Independent | `/network` |

### Check GPU Usage
```bash
pip install py3nvml
py3smi
```
(Use `py3smi` instead of `nvidia-smi` in containers)

### CUDA Version
CUDA is backward compatible. If you need CUDA 12.1, any version >= 12.1 works.

## Sandbox Issues

### Sandbox Timeout
- Idle timeout varies by current sandbox settings/policy
- Use `keep_alive=True` for long-running tasks
- Consider using persistence/snapshot features

### Command Execution Failed
- Check if required packages are installed
- Verify file paths are correct
- Check sandbox logs for errors

## Integration Issues

### OpenAI SDK Not Working
Use this baseline client configuration:
```python
client = OpenAI(
    base_url="https://api.novita.ai/openai",  # Note: /openai suffix
    api_key="<YOUR_API_KEY>",
)
```

### LangChain Integration
```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    base_url="https://api.novita.ai/openai",
    api_key="<YOUR_API_KEY>",
    model="deepseek/deepseek-r1",
)
```

## Get Help

- **Discord**: https://discord.gg/YyPRAzwp7P
- **Email**: support@novita.ai
- **Status**: https://status.novita.ai
- **Full FAQ**: https://novita.ai/docs/guides/faq
