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
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
)

response = client.chat.completions.create(
    model=os.environ["NOVITA_MODEL"],
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
    "model": "<MODEL_NAME>",
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

### Model Selection

Do not assume a default model. Use the model selected by the user or application. If no model is selected, browse https://novita.ai/models or query the model API and choose based on the task requirements.

## 4. Add Credits

New users get free credits. To add more:
1. Visit [Billing](https://novita.ai/billing)
2. Add payment method
3. Optionally enable [Auto Top-up](https://novita.ai/docs/guides/auto-top-up)

## Next Steps

- [LLM API Guide](llm-guide.md) - Advanced features like function calling, vision
- [GPU Guide](gpu-guide.md) - Dedicated GPU instances
- [Integrations](integrations.md) - Use with LangChain, Cursor, etc.
