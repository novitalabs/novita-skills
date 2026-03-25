# Novita AI Image API Reference

> **Security**: Endpoints accepting `image_file` (base64) or `images[]` (URLs) should only receive content from trusted sources. Validate user-provided URLs before passing to the API.

## Table of Contents
- [FLUX.1 Schnell (sync)](#flux1-schnell)
- [FLUX Kontext (async)](#flux-kontext)
- [Stable Diffusion txt2img (async)](#stable-diffusion-txt2img)
- [Stable Diffusion img2img (async)](#stable-diffusion-img2img)
- [Image Editing — Sync](#image-editing-sync)
- [Image Editing — Async](#image-editing-async)
- [Task Result Polling](#task-result-polling)

## FLUX.1 Schnell

`POST https://api.novita.ai/v3beta/flux-1-schnell` — **Synchronous**

| Parameter | Type | Required | Range | Description |
|-----------|------|----------|-------|-------------|
| `prompt` | string | yes | max 1024 | Text prompt |
| `width` | integer | yes | 64-2048 | Image width |
| `height` | integer | yes | 64-2048 | Image height |
| `image_num` | integer | yes | 1-8 | Number of images |
| `steps` | integer | yes | 1-100 | Inference steps (4 recommended) |
| `seed` | integer | yes | 0-4294967295 | Random seed |
| `response_image_format` | string | no | png/webp/jpeg | Default: png |

**Pricing**: $0.003 × (Width × Height × Steps) / (1024 × 1024 × 4)

**Response**: `{images: [{image_url, image_url_ttl, image_type}], task: {task_id}}`

## FLUX Kontext

`POST https://api.novita.ai/v3/async/flux-1-kontext-{dev,pro,max}` — **Async**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | yes | Text prompt |
| `images` | array | no | Up to 4 input image URLs for editing |
| `size` | string | no | e.g., "1024x1024" |
| `num_inference_steps` | integer | no | Inference steps |
| `guidance_scale` | number | no | Guidance scale |
| `num_images` | integer | no | Number of output images |
| `seed` | integer | no | Random seed |
| `output_format` | string | no | png/webp/jpeg |

## Stable Diffusion txt2img

`POST https://api.novita.ai/v3/async/txt2img` — **Async**

### request (object, required)

| Parameter | Type | Required | Range | Description |
|-----------|------|----------|-------|-------------|
| `model_name` | string | yes | — | SD checkpoint (e.g., `sd_xl_base_1.0.safetensors`) |
| `prompt` | string | yes | max 1024 | Text prompt |
| `width` | integer | yes | 128-2048 | Image width |
| `height` | integer | yes | 128-2048 | Image height |
| `image_num` | integer | yes | 1-8 | Number of images |
| `steps` | integer | yes | 1-100 | Sampling steps |
| `guidance_scale` | number | yes | 1-30 | CFG scale |
| `sampler_name` | string | yes | see below | Sampling method |
| `negative_prompt` | string | no | max 1024 | Negative prompt |
| `seed` | integer | no | — | Random seed (-1 = random) |
| `loras` | array | no | max 5 | `[{model_name, strength: 0-1}]` |
| `embeddings` | array | no | max 5 | `[{model_name}]` |
| `hires_fix` | object | no | — | `{target_width, target_height, strength, upscaler}` |
| `refiner` | object | no | — | `{switch_at: 0-1}` |

**Sampler names**: `Euler a`, `Euler`, `LMS`, `Heun`, `DPM2`, `DPM2 a`, `DPM++ 2S a`, `DPM++ 2M`, `DPM++ SDE`, `DPM fast`, `DPM adaptive`, `LMS Karras`, `DPM2 Karras`, `DPM2 a Karras`, `DPM++ 2S a Karras`, `DPM++ 2M Karras`, `DPM++ SDE Karras`, `DDIM`, `PLMS`, `UniPC`

### extra (object, optional)

| Parameter | Type | Description |
|-----------|------|-------------|
| `response_image_type` | string | png/webp/jpeg (default: png) |
| `enable_nsfw_detection` | boolean | NSFW detection |
| `webhook` | object | `{url: string}` for async callback |
| `custom_storage` | object | AWS S3 configuration |

**Response**: `{task_id: string}`

## Stable Diffusion img2img

`POST https://api.novita.ai/v3/async/img2img` — **Async**

Same as txt2img but with additional `request.image_base64` (required) and `request.strength` (0-1, required).

## Image Editing — Sync

All sync endpoints accept `image_file` as base64-encoded image string.

### Remove Background
`POST /v3/remove-background`
- `image_file` (string, required) — base64 image, max 16MP, max 30 MB
- `extra.response_image_type` — png/webp/jpeg
- **Returns**: `{image_file: "<base64>", image_type: "png"}`

### Replace Background
`POST /v3/replace-background`
- `image_file` (required) — base64 image
- `prompt` (required) — new background description
- `extra.response_image_type`

### Reimagine
`POST /v3/reimagine`
- `image_file` (required) — base64 image
- `extra.response_image_type`

### Image to Prompt
`POST /v3/img2prompt`
- `image_file` (required) — base64 image
- **Returns**: `{text: "description of the image"}`

### Remove Text
`POST /v3/remove-text`
- `image_file` (required) — base64 image

### Cleanup (Erase)
`POST /v3/cleanup`
- `image_file` (required) — base64 original image
- `mask_file` (required) — base64 mask (white = erase)

### Outpainting
`POST /v3/outpainting`
- `image_file` (required) — base64 image
- `prompt` (optional) — description for extended area
- `width`, `height` — target dimensions
- `center_x`, `center_y` — position of original in canvas

### Merge Face
`POST /v3/merge-face`
- `face_image_file` (required) — base64 face source
- `image_file` (required) — base64 target image

### Upscale
`POST /v3/upscale`
- `image_file` (required) — base64 image

## Image Editing — Async

### Inpainting
`POST /v3/async/inpainting`
- `request.model_name`, `request.image_base64`, `request.mask_image_base64`, `request.prompt`
- Same structure as txt2img `request` object

### Upscale (async variant)
`POST /v3/async/upscale`
- `request.model_name` (default: `RealESRGAN_x4plus_anime_6B`)
- `request.image_base64`, `request.scale_factor`

### Replace Background (async variant)
`POST /v3/async/replace-background`
- `image_file`, `prompt`, `extra`

## Task Result Polling

`GET https://api.novita.ai/v3/async/task-result?task_id=TASK_ID`

Response:
```json
{
  "task": {
    "task_id": "xxx",
    "status": "TASK_STATUS_SUCCEED",
    "progress_percent": 100,
    "reason": ""
  },
  "images": [{"image_url": "https://...", "image_url_ttl": 3600, "image_type": "png"}]
}
```

Status values: `TASK_STATUS_QUEUED`, `TASK_STATUS_PROCESSING`, `TASK_STATUS_SUCCEED`, `TASK_STATUS_FAILED`
