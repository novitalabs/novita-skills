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

## Setup

1. Get an API key at [novita.ai/settings/key-management](https://novita.ai/settings/key-management)
2. Set the environment variable: `export NOVITA_API_KEY=your_key`
3. All requests use `Authorization: Bearer $NOVITA_API_KEY` header
4. Base URL: `https://api.novita.ai`
5. Full documentation: [novita.ai/docs/api-reference](https://novita.ai/docs/api-reference)

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
| Account | Balance, billing | `/openapi/v1/billing/*` | Sync |

## LLM (OpenAI-Compatible)

The LLM API is a drop-in replacement for the OpenAI API. Use the standard OpenAI SDK — just change the base URL to `https://api.novita.ai/openai`.

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
```

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/openai/v1/chat/completions` | Chat completion (streaming supported) |
| POST | `/openai/v1/completions` | Text completion |
| POST | `/openai/v1/embeddings` | Text embeddings |
| POST | `/openai/v1/rerank` | Document reranking |
| GET | `/openai/v1/models` | List available models |

**Key models**: `deepseek/deepseek-v3-0324`, `deepseek/deepseek-r1`, `meta-llama/llama-3.1-70b-instruct`, `Qwen/Qwen2.5-72B-Instruct`. Embedding: `baai/bge-m3`. Rerank: `baai/bge-reranker-v2-m3`. Full list via `/models`.

**Features**: vision (multimodal), reasoning, function calling, structured outputs, prompt caching, batch API.

For full parameters and examples → [references/llm-api.md](references/llm-api.md)

## Image Generation

| Endpoint | Path | Mode | Description |
|----------|------|------|-------------|
| FLUX.1 Schnell | `POST /v3beta/flux-1-schnell` | Sync | Fast text-to-image, cheapest option |
| FLUX Kontext Dev/Pro/Max | `POST /v3/async/flux-1-kontext-*` | Async | Advanced generation with image editing |
| FLUX 2 Dev/Flex/Pro | `POST /v3/async/flux-2-*` | Async | Latest FLUX models |
| Stable Diffusion txt2img | `POST /v3/async/txt2img` | Async | Full SD control with LoRAs, samplers |
| Stable Diffusion img2img | `POST /v3/async/img2img` | Async | Image-to-image transformation |
| Seedream 3.0 / 4.0 / 4.5 / 5.0-lite | Async | Async | ByteDance image models |
| Qwen Image / Hunyuan Image 3 / GLM Image | Async | Async | Additional providers |

For full parameters and examples → [references/image-api.md](references/image-api.md)

## Image Editing

| Endpoint | Path | Mode | Input |
|----------|------|------|-------|
| Remove Background | `POST /v3/remove-background` | Sync | Base64 image |
| Replace Background | `POST /v3/replace-background` | Sync | Base64 image + text prompt |
| Reimagine | `POST /v3/reimagine` | Sync | Base64 image |
| Image to Prompt | `POST /v3/img2prompt` | Sync | Base64 image → returns text |
| Remove Text | `POST /v3/remove-text` | Sync | Base64 image |
| Cleanup (erase) | `POST /v3/cleanup` | Sync | Base64 image + base64 mask |
| Outpainting | `POST /v3/outpainting` | Sync | Base64 image + prompt + dimensions |
| Merge Face | `POST /v3/merge-face` | Sync | Base64 face + base64 target |
| Upscale | `POST /v3/upscale` | Sync | Base64 image |
| Inpainting | `POST /v3/async/inpainting` | Async | Base64 image + base64 mask + prompt |

All image inputs use base64-encoded local files. For full parameters → [references/image-api.md](references/image-api.md)

## Video Generation

All video endpoints are async — they return a task_id for polling. The Unified Video API provides a single endpoint for all models.

| Endpoint | Path | Description |
|----------|------|-------------|
| Unified Video API | `POST /v3/video/create` | Single endpoint for all video models |
| SD Text-to-Video | `POST /v3/async/txt2video` | Legacy Stable Diffusion video |
| SD Image-to-Video | `POST /v3/async/img2video` | SVD/SVD-XT models |
| Hunyuan Video Fast | `POST /v3/async/hunyuan-video-fast` | Cost-effective text-to-video |

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

For full parameters → [references/video-api.md](references/video-api.md)

## Audio

| Endpoint | Path | Mode | Use When |
|----------|------|------|----------|
| MiniMax Speech 02 HD | `POST /v3/minimax-speech-02-hd` | Sync | English TTS, high quality, 17 voices |
| GLM TTS | `POST /v3/glm-tts` | Sync | Chinese TTS, low latency, 7 voices |
| GLM ASR | `POST /v3/glm-asr` | Sync | Speech-to-text transcription |
| MiniMax Voice Cloning | `POST /v3/minimax-voice-cloning` | Sync | Clone a voice from audio |
| Fish Audio TTS | Async | Async | Custom voice TTS |

**MiniMax voices**: Wise_Woman, Calm_Woman, Friendly_Person, Deep_Voice_Man, Inspirational_girl, Casual_Guy, Lively_Girl, Patient_Man, Young_Knight, Lovely_Girl, Sweet_Girl_2, Elegant_Man

**GLM voices**: tongtong, chuichui, xiaochen, jam, kazi, douji, luodo

**Emotion control** (MiniMax): happy, sad, angry, fearful, disgusted, surprised, neutral

For full parameters → [references/audio-api.md](references/audio-api.md)

## Async Task Polling

Async endpoints (SD images, video, some audio) return a task_id. Poll for results:

`GET /v3/async/task-result` with query parameter `task_id`

Status lifecycle: TASK_STATUS_QUEUED → TASK_STATUS_PROCESSING → TASK_STATUS_SUCCEED or TASK_STATUS_FAILED

Poll every 3-5 seconds. On success, results contain download URLs in `images[]`, `videos[]`, or `audios[]` arrays. You can also configure a webhook callback in the original request for async notification.

## Batch Processing (OpenAI-Compatible)

For bulk LLM jobs using the OpenAI-compatible batch API at `/openai/v1`:

1. Upload a JSONL file via `POST /openai/v1/files`
2. Create a batch via `POST /openai/v1/batches` with the file ID
3. Poll batch status via `GET /openai/v1/batches/{batch_id}`
4. Download results via `GET /openai/v1/files/{output_file_id}/content`

For full parameters → [references/llm-api.md](references/llm-api.md)

## GPU Cloud

Base: `/gpu-instance/openapi/v1`

| Operation | Method | Path |
|-----------|--------|------|
| List GPU products | GET | `/products` |
| List CPU products | GET | `/cpu/products` |
| List clusters | GET | `/clusters` |
| Create instance | POST | `/gpu/instance/create` |
| List instances | GET | `/gpu/instance/list` |
| Get instance | GET | `/gpu/instance/get` |
| Start / Stop / Restart | POST | `/gpu/instance/{action}` |
| Delete instance | POST | `/gpu/instance/delete` |

GPU creation costs real money — always check `/products` for pricing first.

Also supports: **Templates** (create/list/get/update/delete), **Network Storage** (create/list/delete), **Serverless Endpoints** (create/list/get/update/delete).

For full parameters → [references/gpu-api.md](references/gpu-api.md)

## Account and Billing

| Operation | Method | Path |
|-----------|--------|------|
| Get balance | GET | `/openapi/v1/billing/balance/detail` |
| Monthly bill | GET | `/openapi/v1/billing/monthly/bill` |
| Usage-based billing | GET | `/openapi/v1/billing/bill/list` |
| Fixed-term billing | GET | `/openapi/v1/billing/fixed-term/bill` |

Balance amounts are in units of 0.0001 USD (divide by 10000 for dollars).

## Decision Guide

### Which image endpoint?

| Intent | Endpoint | Notes |
|--------|----------|-------|
| Text to image (fast) | FLUX.1 Schnell | Sync, cheapest |
| Text to image (quality) | FLUX Kontext, Seedream, SD | Async, more control |
| Image + text to new image | img2img | Style transfer |
| Edit region with prompt | Inpainting | Needs mask |
| Erase region | Cleanup | Sync, needs mask |
| Extend canvas | Outpainting | Sync |
| Remove background | remove-background | Sync |
| New background | replace-background | Sync |
| Remove text overlay | remove-text | Sync |
| Describe image | img2prompt | Returns text |
| Enlarge and enhance | Upscale | Sync |
| Swap face | merge-face | Sync |
| Restyle completely | Reimagine | Sync |

### Which TTS?
- **English, multilingual, high quality**: MiniMax Speech 02 HD
- **Chinese, low latency**: GLM TTS
- **Custom voice**: Fish Audio or MiniMax Voice Cloning

### Which video model?
- **General purpose**: Kling v2.5 or Hailuo 02
- **Fast and cheap**: Hunyuan Video Fast, Wan 2.5 Preview
- **High quality**: Kling v2.6 Pro, Vidu Q3
- **Image-to-video**: Kling I2V, Wan I2V, Hailuo fast-I2V

## Security

- Never hardcode API keys in code or commit them to version control. Use environment variables or secret managers.
- Endpoints accepting media inputs should only receive content from trusted, verified sources.
- When using async webhook callbacks, ensure your callback server validates the request origin.
- Enable NSFW detection for user-facing applications.

## Error Handling

| Code | HTTP Status | Meaning |
|------|-------------|---------|
| INVALID_API_KEY | 403 | Bad or missing API key |
| RATE_LIMIT_EXCEEDED | 429 | Too many requests |
| BILLING_BALANCE_NOT_ENOUGH | 400 | Insufficient balance |
| MODEL_NOT_FOUND | 404 | Invalid model name |
| INVALID_REQUEST_BODY | 400 | Malformed request |
| SERVICE_NOT_AVAILABLE | 503 | Service temporarily down |

## API References

For detailed endpoint parameters, request and response schemas, and code examples:

- **LLM API**: [references/llm-api.md](references/llm-api.md) — Chat, embeddings, rerank, function calling, structured outputs, batch
- **Image API**: [references/image-api.md](references/image-api.md) — All generation and editing endpoints with full parameter specs
- **Video API**: [references/video-api.md](references/video-api.md) — Unified API, model-specific parameters
- **Audio API**: [references/audio-api.md](references/audio-api.md) — TTS variants, ASR, voice cloning, streaming
- **GPU Cloud API**: [references/gpu-api.md](references/gpu-api.md) — Instances, templates, storage, serverless

---
