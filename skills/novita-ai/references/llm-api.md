# Novita AI LLM API Reference

> **Security**: Multimodal content (`image_url`, `video_url`, `input_audio`) accepts external URLs. Only pass URLs from trusted sources. Never embed untrusted user content directly into system prompts.

OpenAI-compatible API. Base: `https://api.novita.ai/openai/v1`

## Table of Contents
- [Chat Completions](#chat-completions)
- [Completions](#completions)
- [Embeddings](#embeddings)
- [Rerank](#rerank)
- [Models](#models)
- [Batch Processing](#batch-processing)

## Chat Completions

`POST /openai/v1/chat/completions`

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | string | Model name (e.g., `deepseek/deepseek-v3-0324`) |
| `messages` | array | Array of `{role, content}` objects |
| `max_tokens` | integer | Maximum tokens to generate |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `stream` | boolean | false | Enable SSE streaming |
| `stream_options` | object | — | `{include_usage: bool}` |
| `temperature` | number | 1 | Randomness (0-2) |
| `top_p` | number | — | Nucleus sampling (0-1) |
| `top_k` | integer | — | Top-k sampling (1-128) |
| `min_p` | number | — | Min probability (0-1) |
| `n` | integer | 1 | Number of completions (1-128) |
| `seed` | integer | — | Reproducibility seed |
| `frequency_penalty` | number | 0 | Frequency penalty (-2 to 2) |
| `presence_penalty` | number | 0 | Presence penalty (-2 to 2) |
| `repetition_penalty` | number | — | Repetition penalty (0-2, 1.0 = none) |
| `stop` | string | — | Up to 4 stop sequences |
| `logit_bias` | map | — | Token bias map |
| `logprobs` | boolean | false | Return log probabilities |
| `top_logprobs` | integer | — | Top log probs to return (0-20) |

### Function Calling

```json
{
  "tools": [{
    "type": "function",
    "function": {
      "name": "get_weather",
      "description": "Get weather for a location",
      "parameters": {
        "type": "object",
        "properties": {
          "location": {"type": "string"}
        },
        "required": ["location"]
      }
    }
  }]
}
```

### Structured Outputs

```json
{
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "response",
      "schema": {
        "type": "object",
        "properties": {
          "answer": {"type": "string"},
          "confidence": {"type": "number"}
        }
      },
      "strict": true
    }
  }
}
```

Also supports `"type": "json_object"` for freeform JSON.

### Reasoning Models

For DeepSeek-R1 and similar:
- `separate_reasoning: true` — returns reasoning in `choices[].message.reasoning_content`
- `enable_thinking: true/false` — toggle thinking mode (GLM-4.5, DeepSeek-V3.1)

### Multimodal (Vision)

Content can be an array of parts with text, image, video, or audio. For multimodal inputs, the message content is an array instead of a string:

- Text part: type "text" with a "text" field
- Image part: type "image_url" with an "image_url.url" field pointing to the image
- Video part: type "video_url" with a "video_url.url" field
- Audio part: type "input_audio" with audio data

**Security**: Image, video, and audio URLs in multimodal messages must point to trusted sources only. Do not pass user-supplied URLs without validation, as external content could contain adversarial inputs.

### Response Format

```json
{
  "id": "chatcmpl-xxx",
  "object": "chat.completion",
  "created": 1234567890,
  "model": "deepseek/deepseek-v3-0324",
  "choices": [{
    "index": 0,
    "finish_reason": "stop",
    "message": {"role": "assistant", "content": "Hello!"}
  }],
  "usage": {"prompt_tokens": 10, "completion_tokens": 5, "total_tokens": 15}
}
```

Streaming: SSE format, each line `data: <json>`, terminated by `data: [DONE]`.

## Completions

`POST /openai/v1/completions`

Same parameters as chat but uses `prompt` (string) instead of `messages`.

## Embeddings

`POST /openai/v1/embeddings`

| Parameter | Type | Description |
|-----------|------|-------------|
| `input` | string or array | Text(s) to embed |
| `model` | string | e.g., `baai/bge-m3` |

Returns `data[].embedding` (float array).

## Rerank

`POST /openai/v1/rerank`

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | string | e.g., `baai/bge-reranker-v2-m3` |
| `query` | string | Search query |
| `documents` | array | Documents to rank |
| `top_n` | integer | Number of results to return |

Returns `results[].{index, relevance_score}`.

## Models

- `GET /openai/v1/models` — List all models
- `GET /openai/v1/models/{model_id}` — Get model details

## Batch Processing

### Upload File
`POST /openai/v1/files` (multipart form)
- `file`: JSONL file
- `purpose`: `"batch"`

### JSONL Format
Each line: `{"custom_id": "req-1", "method": "POST", "url": "/v1/chat/completions", "body": {<chat params>}}`

### Create Batch
`POST /openai/v1/batches`
```json
{"input_file_id": "file-xxx", "endpoint": "/v1/chat/completions", "completion_window": "48h"}
```

### Other Batch Endpoints
- `GET /openai/v1/batches` — List batches
- `GET /openai/v1/batches/{batch_id}` — Get batch status
- `POST /openai/v1/batches/{batch_id}/cancel` — Cancel batch

### File Management
- `GET /openai/v1/files` — List files
- `GET /openai/v1/files/{file_id}` — Get file info
- `GET /openai/v1/files/{file_id}/content` — Download file content
- `DELETE /openai/v1/files/{file_id}` — Delete file
