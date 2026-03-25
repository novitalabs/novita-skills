---
name: novita-ai
description: >
  Novita AI: LLM, Image Generation & Editing, Video Generation, Audio (TTS/ASR), and GPU Cloud.
  Use this skill whenever the user wants to call Novita AI APIs — chat with LLMs (DeepSeek,
  Llama, Qwen), generate images (FLUX, Stable Diffusion, Seedream, Hunyuan Image), edit images
  (remove background, upscale, inpainting, img2img, outpainting, reimagine, merge face, replace
  background, remove text), generate videos (Kling, Wan, Hunyuan, Minimax Hailuo, Vidu, PixVerse,
  Seedance), do text-to-speech or speech-to-text (MiniMax TTS, GLM TTS, Fish Audio, ASR, voice
  cloning), run OpenAI-compatible batch jobs, manage GPU cloud instances and serverless endpoints,
  or check account balance and billing. Also trigger when the user mentions novita.ai, Novita AI,
  Novita API key, or wants to use any Novita platform service — even if they just say "generate
  an image" or "run an LLM" and Novita is available as a provider.
license: MIT
compatibility: >
  Works with any HTTP client (curl, Python requests, fetch) or OpenAI-compatible SDKs
  (Python openai, TypeScript @ai-sdk). No special dependencies required.
metadata:
  author: Novita AI
  version: "1.0.0"
allowed-tools: Bash(curl:*) Bash(python:*) Bash(node:*) Bash(pip:*) Bash(npm:*) Read
---

# Novita AI

Access 200+ AI models through a unified API — LLM chat and embeddings (DeepSeek, Llama, Qwen), image generation and editing (FLUX, Stable Diffusion, Seedream), video generation (Kling, Wan, Hailuo, Vidu), text-to-speech, speech recognition, and GPU cloud infrastructure.

- OpenAI-compatible LLM API works as a drop-in replacement with any OpenAI SDK
- 30+ image endpoints covering generation, editing, upscaling, background removal, face merging, and more
- Video generation from 7+ providers including Kling, Wan, Minimax Hailuo, Vidu, and Seedance
- Full GPU cloud management — instances, templates, storage, and serverless endpoints

**Base URL**: `https://api.novita.ai` · **Auth**: `Authorization: Bearer $NOVITA_API_KEY` · [Get API Key](https://novita.ai/settings/key-management) · [Full Docs](https://novita.ai/docs/api-reference)

## Services

| Service | Use When | Endpoints | Mode |
|---------|----------|-----------|------|
| LLM | Chat, completion, embeddings, reranking | `/openai/v1/*` | Sync / Stream |
| Image Generation | Text-to-image, image-to-image | FLUX, SD, Seedream, Qwen, Hunyuan, GLM | Sync / Async |
| Image Editing | Remove BG, upscale, inpaint, outpaint, cleanup, reimagine, merge face | `/v3/*` | Sync / Async |
| Video Generation | Text-to-video, image-to-video | Kling, Wan, Hunyuan, Hailuo, Vidu, PixVerse, Seedance | Async |
| Audio | TTS, ASR, voice cloning | MiniMax, GLM, Fish Audio | Sync |
| Batch | Bulk LLM processing | `/openai/v1/batches` | Async |
| GPU Cloud | Instances, templates, storage, serverless | `/gpu-instance/openapi/v1/*` | Sync |
| Account | Balance, billing | `/v3/user/*` | Sync |

## LLM (OpenAI-Compatible)

The LLM API is a drop-in replacement for the OpenAI API. Use the standard OpenAI SDK with a different base URL.

**Base**: `https://api.novita.ai/openai/v1`

### With OpenAI SDK (recommended)

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key="YOUR_NOVITA_API_KEY",
)

response = client.chat.completions.create(
    model="deepseek/deepseek-v3-0324",
    messages=[{"role": "user", "content": "Hello"}],
    max_tokens=512,
)
print(response.choices[0].message.content)
```

### With curl

```bash
curl -X POST https://api.novita.ai/openai/v1/chat/completions \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek/deepseek-v3-0324",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 512
  }'
```

### LLM Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/openai/v1/chat/completions` | Chat completion (streaming supported) |
| POST | `/openai/v1/completions` | Text completion |
| POST | `/openai/v1/embeddings` | Text embeddings |
| POST | `/openai/v1/rerank` | Document reranking |
| GET | `/openai/v1/models` | List available models |

**Key models**: `deepseek/deepseek-v3-0324`, `deepseek/deepseek-r1`, `meta-llama/llama-3.1-70b-instruct`, `Qwen/Qwen2.5-72B-Instruct`. Embedding: `baai/bge-m3`. Rerank: `baai/bge-reranker-v2-m3`. Full list via `/models`.

**Features**: vision (multimodal), reasoning (`separate_reasoning`, `enable_thinking`), function calling (`tools`), structured outputs (`response_format: {type: "json_schema"}`), prompt caching, batch API.

For detailed parameters → read [references/llm-api.md](references/llm-api.md)

## Image Generation

### FLUX.1 Schnell (fast, sync)

```bash
curl -X POST https://api.novita.ai/v3beta/flux-1-schnell \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "a sunset over mountains", "width": 1024, "height": 1024, "image_num": 1, "steps": 4, "seed": 0}'
```

Returns `images[].image_url` directly (synchronous).

### Stable Diffusion (async, more control)

```bash
curl -X POST https://api.novita.ai/v3/async/txt2img \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "request": {
      "model_name": "sd_xl_base_1.0.safetensors",
      "prompt": "a cat in a garden",
      "width": 1024, "height": 1024, "image_num": 1,
      "steps": 20, "guidance_scale": 7.5, "sampler_name": "DPM++ 2M Karras"
    },
    "extra": {"response_image_type": "png"}
  }'
```

Returns `task_id` — poll with Task Result API (see below).

### All Image Generation Endpoints

| Endpoint | Path | Sync/Async |
|----------|------|------------|
| FLUX.1 Schnell | `POST /v3beta/flux-1-schnell` | Sync |
| FLUX Kontext Dev/Pro/Max | `POST /v3/async/flux-1-kontext-{dev,pro,max}` | Async |
| FLUX 2 Dev/Flex/Pro | `POST /v3/async/flux-2-{dev,flex,pro}` | Async |
| Stable Diffusion txt2img | `POST /v3/async/txt2img` | Async |
| Stable Diffusion img2img | `POST /v3/async/img2img` | Async |
| Seedream 3.0 / 4.0 / 4.5 / 5.0-lite | `POST /v3/async/seedream-*` | Async |
| Qwen Image | `POST /v3/async/qwen-image` | Async |
| Hunyuan Image 3 | `POST /v3/async/hunyuan-image-3` | Async |
| GLM Image | `POST /v3/async/glm-image` | Async |

For detailed parameters → read [references/image-api.md](references/image-api.md)

## Image Editing

| Endpoint | Path | Mode | Input |
|----------|------|------|-------|
| Remove Background | `POST /v3/remove-background` | Sync | `image_file` (base64) |
| Replace Background | `POST /v3/replace-background` | Sync | `image_file` + `prompt` |
| Reimagine | `POST /v3/reimagine` | Sync | `image_file` |
| Image to Prompt | `POST /v3/img2prompt` | Sync | `image_file` → text |
| Remove Text | `POST /v3/remove-text` | Sync | `image_file` |
| Cleanup (erase) | `POST /v3/cleanup` | Sync | `image_file` + `mask_file` |
| Outpainting | `POST /v3/outpainting` | Sync | `image_file`, `prompt`, `width`, `height` |
| Merge Face | `POST /v3/merge-face` | Sync | `face_image_file` + `image_file` |
| Upscale | `POST /v3/upscale` | Sync | `image_file` |
| Inpainting | `POST /v3/async/inpainting` | Async | `image_base64`, `mask_image_base64`, `prompt` |

```bash
# Remove background (sync — returns base64 image)
curl -X POST https://api.novita.ai/v3/remove-background \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"image_file": "'$(base64 -w0 photo.jpg)'"}'
```

For detailed parameters → read [references/image-api.md](references/image-api.md)

## Video Generation

All video endpoints are async — they return `task_id`. Use the Unified Video API for access to all models through a single endpoint.

### Unified Video API (recommended)

```bash
curl -X POST https://api.novita.ai/v3/video/create \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "hailuo-02", "prompt": "a cat playing piano", "resolution": "720p", "duration": 5}'
```

### Available Video Models

| Model | Capabilities | Notable Features |
|-------|-------------|-----------------|
| Kling v2.1 / v2.5 / v2.6 | T2V, I2V, ref2v, video-edit | Motion control, camera control |
| Wan 2.5 / 2.6 | T2V, I2V | Fast preview modes |
| Minimax Hailuo 02 / 2.3 | T2V, I2V | Fast I2V variant |
| Hunyuan Video Fast | T2V | Cost-effective |
| Vidu Q1 / Q2 / Q3 | T2V, I2V, startend2v, ref2v | Multi-frame, templates |
| PixVerse v4.5 | T2V, I2V | — |
| Seedance v1 / v1.5 | T2V, I2V | Lite and Pro variants |

Model-specific parameters vary — the Unified API fetches each model's schema dynamically. For detailed parameters → read [references/video-api.md](references/video-api.md)

## Audio

### Text-to-Speech (MiniMax — English, high quality)

```bash
curl -X POST https://api.novita.ai/v3/minimax-speech-02-hd \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Hello world",
    "voice_setting": {"voice_id": "Calm_Woman", "speed": 1.0},
    "audio_setting": {"format": "mp3"},
    "output_format": "url"
  }'
```

**MiniMax voices**: `Wise_Woman`, `Calm_Woman`, `Friendly_Person`, `Deep_Voice_Man`, `Inspirational_girl`, `Casual_Guy`, `Lively_Girl`, `Patient_Man`, `Young_Knight`, `Lovely_Girl`, `Sweet_Girl_2`, `Elegant_Man`

**Emotion control**: `happy`, `sad`, `angry`, `fearful`, `disgusted`, `surprised`, `neutral`

### Text-to-Speech (GLM — Chinese, low latency)

```bash
curl -X POST https://api.novita.ai/v3/glm-tts \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input": "你好世界", "voice": "jam", "response_format": "wav"}' \
  --output speech.wav
```

**GLM voices**: `tongtong`, `chuichui`, `xiaochen`, `jam`, `kazi`, `douji`, `luodo`

Returns binary audio directly — pipe to file.

### Speech-to-Text (ASR)

```bash
curl -X POST https://api.novita.ai/v3/glm-asr \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"file": "https://example.com/audio.wav"}'
```

Accepts audio URL or base64 data URI. Max 25 MB, 30 seconds. Returns `{"text": "..."}`.

### Voice Cloning

```bash
curl -X POST https://api.novita.ai/v3/minimax-voice-cloning \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"audio_url": "https://example.com/voice.mp3", "text": "Hello", "model": "speech-02-hd"}'
```

For detailed parameters (Fish Audio, MiniMax 2.8, streaming) → read [references/audio-api.md](references/audio-api.md)

## Async Task Polling

All async endpoints (SD images, video, some audio) return `{"task_id": "..."}`. Poll for results:

```bash
curl "https://api.novita.ai/v3/async/task-result?task_id=TASK_ID" \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

**Status lifecycle**: `TASK_STATUS_QUEUED` → `TASK_STATUS_PROCESSING` → `TASK_STATUS_SUCCEED` / `TASK_STATUS_FAILED`

Poll every 3-5 seconds. On success, results are in `images[]`, `videos[]`, or `audios[]` — each containing a `*_url` with a time-limited download link.

You can also configure a **webhook** by adding `"extra": {"webhook": {"url": "https://your-server.com/callback"}}` to any async request.

## Batch Processing (OpenAI-Compatible)

For bulk LLM jobs. Base: `https://api.novita.ai/openai/v1`

```bash
# 1. Upload JSONL file
curl -X POST https://api.novita.ai/openai/v1/files \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -F file=@batch.jsonl -F purpose=batch

# 2. Create batch
curl -X POST https://api.novita.ai/openai/v1/batches \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input_file_id": "FILE_ID", "endpoint": "/v1/chat/completions", "completion_window": "48h"}'

# 3. Check status
curl https://api.novita.ai/openai/v1/batches/BATCH_ID \
  -H "Authorization: Bearer $NOVITA_API_KEY"

# 4. Download results
curl https://api.novita.ai/openai/v1/files/OUTPUT_FILE_ID/content \
  -H "Authorization: Bearer $NOVITA_API_KEY" -o results.jsonl
```

## GPU Cloud

Base: `https://api.novita.ai/gpu-instance/openapi/v1`

| Operation | Method | Path |
|-----------|--------|------|
| List GPU products | GET | `/products` |
| List CPU products | GET | `/cpu/products` |
| List clusters | GET | `/clusters` |
| Create instance | POST | `/gpu/instance/create` |
| List instances | GET | `/gpu/instance/list` |
| Get instance | GET | `/gpu/instance/get?instanceId=X` |
| Start / Stop / Restart | POST | `/gpu/instance/{start,stop,restart}` |
| Delete instance | POST | `/gpu/instance/delete` |

```bash
# List available GPUs and pricing
curl https://api.novita.ai/gpu-instance/openapi/v1/products \
  -H "Authorization: Bearer $NOVITA_API_KEY"

# Create a GPU instance
curl -X POST https://api.novita.ai/gpu-instance/openapi/v1/gpu/instance/create \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"productId": "xxx", "gpuNum": 1, "imageUrl": "pytorch/pytorch:latest", "rootfsSize": 20}'
```

GPU creation costs real money — always check `/products` for pricing first.

Also supports: **Templates** (create/list/get/update/delete), **Network Storage** (create/list/delete), **Serverless Endpoints** (create/list/get/update/delete). For details → read [references/gpu-api.md](references/gpu-api.md)

## Account & Billing

```bash
# Check balance (units of 0.0001 USD — divide by 10000 for dollars)
curl https://api.novita.ai/openapi/v1/billing/balance/detail \
  -H "Authorization: Bearer $NOVITA_API_KEY"

# Monthly billing
curl https://api.novita.ai/openapi/v1/billing/monthly/bill \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

## Decision Guide

### Which image endpoint?

| Intent | Endpoint | Notes |
|--------|----------|-------|
| Text → Image (fast) | `/v3beta/flux-1-schnell` | Sync, cheapest |
| Text → Image (quality) | FLUX Kontext / Seedream / SD | Async, more control |
| Image + Text → New Image | `/v3/async/img2img` | Style transfer |
| Edit region with prompt | `/v3/async/inpainting` | Needs mask |
| Erase region | `/v3/cleanup` | Sync, needs mask |
| Extend canvas | `/v3/outpainting` | Sync |
| Remove background | `/v3/remove-background` | Sync |
| New background | `/v3/replace-background` | Sync |
| Remove text overlay | `/v3/remove-text` | Sync |
| Describe image | `/v3/img2prompt` | Sync, returns text |
| Enlarge/enhance | `/v3/upscale` | Sync |
| Swap face | `/v3/merge-face` | Sync |
| Restyle completely | `/v3/reimagine` | Sync |

### Which TTS?
- **English / multilingual, high quality**: MiniMax Speech (`/v3/minimax-speech-02-hd`)
- **Chinese, low latency**: GLM TTS (`/v3/glm-tts`)
- **Custom voice**: Fish Audio or MiniMax Voice Cloning

### Which video model?
- **General purpose**: Kling v2.5 or Hailuo 02
- **Fast/cheap**: Hunyuan Video Fast, Wan 2.5 Preview
- **High quality**: Kling v2.6 Pro, Vidu Q3
- **Image-to-video**: Kling I2V, Wan I2V, Hailuo fast-I2V

## Security

- **API Key**: Never hardcode `NOVITA_API_KEY` in code or commit it to version control. Use environment variables or secret managers.
- **External URLs**: Endpoints that accept external URLs (image_url, audio file URLs, webhook URLs) should only receive URLs from trusted sources. Validate and sanitize all user-provided URLs before passing them to the API to prevent indirect prompt injection.
- **Webhook endpoints**: If using async webhook callbacks, ensure your callback server validates the request origin.
- **Base64 inputs**: Image and audio inputs encoded as base64 should come from verified local files, not untrusted external content.

## Error Handling

All errors follow: `{"error": {"message": "...", "code": "..."}}`

| Code | HTTP | Meaning |
|------|------|---------|
| INVALID_API_KEY | 403 | Bad or missing API key |
| RATE_LIMIT_EXCEEDED | 429 | Too many requests — back off |
| BILLING_BALANCE_NOT_ENOUGH | 400 | Insufficient balance |
| MODEL_NOT_FOUND | 404 | Invalid model name |
| INVALID_REQUEST_BODY | 400 | Malformed request |
| SERVICE_NOT_AVAILABLE | 503 | Service temporarily down |

## SDK Quick References

For detailed endpoint parameters, request/response schemas, and advanced features:

- **LLM API**: [references/llm-api.md](references/llm-api.md) — Chat, embeddings, rerank, function calling, structured outputs
- **Image API**: [references/image-api.md](references/image-api.md) — All generation and editing endpoints with full parameter specs
- **Video API**: [references/video-api.md](references/video-api.md) — Unified API, model-specific parameters
- **Audio API**: [references/audio-api.md](references/audio-api.md) — TTS variants, ASR, voice cloning, streaming
- **GPU Cloud API**: [references/gpu-api.md](references/gpu-api.md) — Instances, templates, storage, serverless

---
