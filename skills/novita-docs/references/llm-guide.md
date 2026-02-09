# LLM API Guide

Novita AI provides OpenAI-compatible APIs for a continuously updated model catalog.

Last verified: 2026-02-09

## Table of Contents
- [Quick Setup](#quick-setup)
- [Basic Chat Completion](#basic-chat-completion)
- [Key Parameters](#key-parameters)
- [Function Calling (Tool Use)](#function-calling-tool-use)
- [Vision (Image Input)](#vision-image-input)
- [Structured Outputs (JSON Mode)](#structured-outputs-json-mode)
- [Batch API](#batch-api)
- [Advanced Features](#advanced-features)
- [API Reference](#api-reference)

## Quick Setup

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key="<YOUR_API_KEY>",
)
```

## Basic Chat Completion

```python
response = client.chat.completions.create(
    model="deepseek/deepseek-r1",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hello!"}
    ],
    max_tokens=512,
    stream=True,  # Recommended for long responses
)

for chunk in response:
    print(chunk.choices[0].delta.content or "", end="")
```

## Key Parameters

### Model Selection
- Browse models: https://novita.ai/models
- Query via API: `GET https://api.novita.ai/openai/v1/models`
- Format: `provider/model-name` (e.g., `deepseek/deepseek-r1`)
- Fetch latest models:
```bash
curl https://api.novita.ai/openai/v1/models \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

### Output Control

| Parameter | Description | Typical Value |
|-----------|-------------|---------------|
| `max_tokens` | Maximum response length | 512-4096 |
| `temperature` | Creativity (0=deterministic, 2=creative) | 0.7 |
| `top_p` | Nucleus sampling | 0.9 |
| `stream` | Stream response chunks | true |

### Repetition Control

| Parameter | Description |
|-----------|-------------|
| `presence_penalty` | Penalize tokens that appeared (encourages new topics) |
| `frequency_penalty` | Penalize based on frequency (reduces repetition) |
| `stop` | Stop sequences to terminate generation |

---

## Function Calling (Tool Use)

Enable LLMs to call external functions/APIs.

### Supported Models
- `deepseek/deepseek-v3.2`
- `qwen/qwen3-coder-next`
- `zai-org/glm-4.7-flash`
- [View all](https://novita.ai/models)

### Example

Define tools, call the model with `tools`, then read the returned tool call.
```python
import json

tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "Get weather for a location",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "City and state, e.g. San Francisco, CA"
                    }
                },
                "required": ["location"]
            }
        }
    }
]

response = client.chat.completions.create(
    model="deepseek/deepseek-v3.2",
    messages=[{"role": "user", "content": "What's the weather in Tokyo?"}],
    tools=tools,
)

tool_call = response.choices[0].message.tool_calls[0]
print(tool_call.function.name)       # "get_weather"
print(tool_call.function.arguments)  # '{"location": "Tokyo, Japan"}'
```

---

## Vision (Image Input)

Process images with Vision-Language Models.

### Supported Models
- `qwen/qwen2-vl-72b-instruct`
- `meta-llama/llama-4-maverick`
- [View all vision models](https://novita.ai/models)

### Image via URL

```python
response = client.chat.completions.create(
    model="qwen/qwen2-vl-72b-instruct",
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "image_url",
                    "image_url": {
                        "url": "https://example.com/image.jpg",
                        "detail": "high"  # high, low, or auto
                    }
                },
                {"type": "text", "text": "Describe this image."}
            ]
        }
    ],
)
```

### Image via Base64

```python
import base64

with open("image.jpg", "rb") as f:
    base64_image = base64.b64encode(f.read()).decode("utf-8")

response = client.chat.completions.create(
    model="qwen/qwen2-vl-72b-instruct",
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "image_url",
                    "image_url": {
                        "url": f"data:image/jpeg;base64,{base64_image}",
                        "detail": "high"
                    }
                },
                {"type": "text", "text": "What text is in this image?"}
            ]
        }
    ],
)
```

---

## Structured Outputs (JSON Mode)

Force LLM to output valid JSON matching your schema.

### Example

```python
response = client.chat.completions.create(
    model="deepseek/deepseek-v3.2",
    messages=[
        {"role": "system", "content": "Extract expense info as JSON."},
        {"role": "user", "content": "I spent $50 on lunch and $30 on coffee today."}
    ],
    response_format={
        "type": "json_schema",
        "json_schema": {
            "name": "expenses",
            "schema": {
                "type": "object",
                "properties": {
                    "items": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "description": {"type": "string"},
                                "amount": {"type": "number"},
                                "category": {"type": "string"}
                            },
                            "required": ["description", "amount"]
                        }
                    }
                },
                "required": ["items"]
            }
        }
    }
)
```

---

## Batch API

Process large volumes of requests asynchronously with discounted batch pricing (see live pricing/docs for current terms).

### Workflow
1. Upload JSONL file with requests
2. Create batch job
3. Poll for completion
4. Download results

```python
with open("requests.jsonl", "rb") as f:
    file = client.files.create(file=f, purpose="batch")

batch = client.batches.create(
    input_file_id=file.id,
    endpoint="/v1/chat/completions",
    completion_window="24h"
)

status = client.batches.retrieve(batch.id)
print(status.status)  # "completed"

results = client.files.content(status.output_file_id)
```

---

## Advanced Features

### Prompt Caching
Automatically caches repeated prompt prefixes for faster responses and lower costs.

### Reasoning Models
Models like `deepseek/deepseek-r1` show reasoning process:
```python
print(response.choices[0].message.reasoning_content)
```

### Streaming
Always use streaming for long outputs to avoid timeouts:
```python
stream = client.chat.completions.create(
    model="deepseek/deepseek-r1",
    messages=[...],
    stream=True,
)
for chunk in stream:
    print(chunk.choices[0].delta.content or "", end="")
```

---

## API Reference

- **Endpoint**: `POST https://api.novita.ai/openai/v1/chat/completions`
- **Full API docs**: https://novita.ai/docs/api-reference/model-apis-llm-create-chat-completion
- **Rate limits**: Vary by account tier and model; verify current limits in docs/console
