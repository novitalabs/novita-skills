# Novita AI Quick Start

Get started with Novita AI in 5 minutes.

Last verified: 2026-02-09

## 1. Get Your API Key

1. Log in at https://novita.ai (Google/GitHub/Email)
2. Go to [Key Management](https://novita.ai/settings/key-management)
3. Create a new API key

## 2. Make Your First API Call

Novita AI is **OpenAI SDK compatible**. Just change the base URL.

### Python (OpenAI SDK)

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key="<YOUR_API_KEY>",
)

response = client.chat.completions.create(
    model="deepseek/deepseek-r1",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hello!"}
    ],
    max_tokens=512,
)
print(response.choices[0].message.content)
```

### cURL

```bash
curl https://api.novita.ai/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -d '{
    "model": "deepseek/deepseek-r1",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Hello!"}
    ],
    "max_tokens": 512
  }'
```

For other SDKs/languages, generate equivalent code from this Python baseline and the OpenAI-compatible base URL.

## 3. Explore Models

- **Browse models**: https://novita.ai/models
- **Query via API**: `GET https://api.novita.ai/openai/v1/models`

### Popular Models

Model availability changes frequently. Confirm current availability at https://novita.ai/models.

| Model | Use Case |
|-------|----------|
| `deepseek/deepseek-r1` | Reasoning, coding |
| `deepseek/deepseek-v3` | General purpose |
| `qwen/qwen3-235b-a22b` | Large context |
| `meta-llama/llama-4-maverick` | Fast inference |

## 4. Add Credits

New users get free credits. To add more:
1. Visit [Billing](https://novita.ai/billing)
2. Add payment method
3. Enable [Auto Top-up](https://novita.ai/docs/guides/auto-top-up) (recommended)

## Next Steps

- [LLM API Guide](llm-guide.md) - Advanced features like function calling, vision
- [Sandbox Guide](sandbox-guide.md) - Run code in cloud sandbox
- [GPU Guide](gpu-guide.md) - Dedicated GPU instances
- [Integrations](integrations.md) - Use with LangChain, Cursor, etc.
