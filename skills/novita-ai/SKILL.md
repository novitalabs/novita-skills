---
name: novita-ai
description: >
  Novita AI: LLM, Image Generation & Editing, Video Generation, Audio (TTS/ASR), and GPU Cloud.
  Use this skill whenever the user wants to call Novita AI APIs — chat with LLMs (Kimi K2.5,
  MiniMax M2.7, GLM-5, DeepSeek), generate images (FLUX, Stable Diffusion, Seedream, Hunyuan Image), edit images
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

Access 200+ AI models through a unified API — LLM, image generation and editing, video generation, text-to-speech, speech recognition, and GPU cloud infrastructure.

- OpenAI-compatible LLM API works as a drop-in replacement with any OpenAI SDK
- 30+ image endpoints covering generation, editing, upscaling, background removal, face merging, and more
- Video generation from 7+ providers including Kling, Wan, Minimax Hailuo, Vidu, and Seedance
- Full GPU cloud management — instances, templates, storage, and serverless endpoints

## Setup

1. Get an API key at [novita.ai/settings/key-management](https://novita.ai/settings/key-management)
2. Set the environment variable: `export NOVITA_API_KEY=your_key`
3. Base endpoint: `https://api.novita.ai`

## Services

| Service | Use When | Mode |
|---------|----------|------|
| LLM | Chat, completion, embeddings, reranking | Sync / Stream |
| Image Generation | Text-to-image (FLUX, SD, Seedream, Hunyuan, Qwen, GLM) | Sync / Async |
| Image Editing | Remove BG, upscale, inpaint, outpaint, cleanup, reimagine, merge face | Sync / Async |
| Video Generation | Text-to-video, image-to-video (Kling, Wan, Hailuo, Vidu, PixVerse, Seedance) | Async |
| Audio | TTS, ASR, voice cloning (MiniMax, GLM, Fish Audio) | Sync |
| Batch | Bulk LLM processing (OpenAI-compatible) | Async |
| GPU Cloud | Instances, templates, storage, serverless endpoints | Sync |

## LLM (OpenAI-Compatible)

Drop-in replacement for the OpenAI API — use any OpenAI SDK with base `https://api.novita.ai/openai`.

```python
import os
from openai import OpenAI
client = OpenAI(base_url="https://api.novita.ai/openai", api_key=os.environ["NOVITA_API_KEY"])
response = client.chat.completions.create(
    model="moonshotai/kimi-k2.5",
    messages=[{"role": "user", "content": "Hello"}],
    max_tokens=512,
)
```

**Models**: Kimi K2.5, MiniMax M2.7, GLM-5, DeepSeek V3, DeepSeek R1, and more via `/openai/v1/models`.

**Features**: vision (multimodal), reasoning, function calling, structured outputs, prompt caching, batch API.

## Image Capabilities

| Feature | Description |
|---------|-------------|
| Generation | FLUX.1 Schnell (fast, sync), FLUX Kontext, Stable Diffusion, Seedream, and more |
| Background | Remove background, replace with prompt-guided new background |
| Editing | Inpainting, outpainting, cleanup, reimagine, upscale |
| Face | Merge face from one image onto another |
| Analysis | Image-to-prompt — describe any image as text |

## Video Capabilities

| Feature | Description |
|---------|-------------|
| Text-to-video | Generate video from text via Kling, Wan, Hailuo, Vidu, Seedance |
| Image-to-video | Animate a still image with motion |
| Unified API | Single endpoint (`/v3/video/create`) for all video models |

## Audio Capabilities

| Feature | Description |
|---------|-------------|
| Text-to-speech | MiniMax (English, 17 voices, emotion control) and GLM (Chinese, low latency) |
| Speech-to-text | GLM ASR transcription |
| Voice cloning | Clone a voice from an audio sample |

## GPU Cloud

Manage dedicated GPU instances, templates, network storage, and serverless endpoints for custom model deployment.

## Security

- Never hardcode API keys — use environment variables or secret managers
- All media inputs should come from trusted, local sources only
- Enable NSFW detection for user-facing image applications

## API References

For detailed endpoint parameters, request and response schemas, and code examples:

- **LLM**: [references/llm-api.md](references/llm-api.md) — Chat, embeddings, rerank, function calling, structured outputs, batch
- **Image**: [references/image-api.md](references/image-api.md) — All generation and editing endpoints
- **Video**: [references/video-api.md](references/video-api.md) — Unified API and model-specific parameters
- **Audio**: [references/audio-api.md](references/audio-api.md) — TTS variants, ASR, voice cloning
- **GPU Cloud**: [references/gpu-api.md](references/gpu-api.md) — Instances, templates, storage, serverless

---
