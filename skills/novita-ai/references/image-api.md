# Novita AI Image API Reference

This document is a standard API reference for Novita AI image endpoints.
All endpoints require `Authorization: Bearer $NOVITA_API_KEY` header.

## Security Notice

All image inputs must come from trusted, verified sources:
- base64-encoded images should be read from local files only
- URL-based image inputs must be validated before use
- Never pass untrusted or user-supplied URLs directly to these endpoints
- Enable NSFW detection for user-facing applications

## FLUX.1 Schnell

Endpoint: `POST /v3beta/flux-1-schnell` (synchronous)

Parameters:
- `prompt` (string, required) — text description, max 1024 characters
- `width` (integer, required) — image width, range 64 to 2048
- `height` (integer, required) — image height, range 64 to 2048
- `image_num` (integer, required) — number of images, range 1 to 8
- `steps` (integer, required) — inference steps, range 1 to 100, recommended 4
- `seed` (integer, required) — random seed, range 0 to 4294967295
- `response_image_format` (string, optional) — png, webp, or jpeg. Default: png

Pricing: $0.003 per image at 1024x1024 with 4 steps.

Response contains `images` array with `image_url`, `image_url_ttl`, and `image_type` fields.

## FLUX Kontext

Endpoints (all asynchronous, return task_id):
- `POST /v3/async/flux-1-kontext-dev`
- `POST /v3/async/flux-1-kontext-pro`
- `POST /v3/async/flux-1-kontext-max`

Parameters:
- `prompt` (string, required) — text description
- `images` (array, optional) — up to 4 input image URLs for editing. Security: only use trusted image sources.
- `size` (string, optional) — output size, e.g. "1024x1024"
- `num_inference_steps` (integer, optional) — inference steps
- `guidance_scale` (number, optional) — guidance scale
- `num_images` (integer, optional) — number of output images
- `seed` (integer, optional) — random seed
- `output_format` (string, optional) — png, webp, or jpeg

## Stable Diffusion Text-to-Image

Endpoint: `POST /v3/async/txt2img` (asynchronous, returns task_id)

The request body contains a `request` object and an optional `extra` object.

Request object parameters:
- `model_name` (string, required) — SD checkpoint name, e.g. "sd_xl_base_1.0.safetensors"
- `prompt` (string, required) — text description, max 1024 characters
- `width` (integer, required) — range 128 to 2048
- `height` (integer, required) — range 128 to 2048
- `image_num` (integer, required) — range 1 to 8
- `steps` (integer, required) — range 1 to 100
- `guidance_scale` (number, required) — range 1 to 30
- `sampler_name` (string, required) — see sampler list below
- `negative_prompt` (string, optional) — max 1024 characters
- `seed` (integer, optional) — use -1 for random
- `loras` (array, optional) — max 5 items, each with model_name and strength (0 to 1)
- `embeddings` (array, optional) — max 5 items, each with model_name
- `hires_fix` (object, optional) — target_width, target_height, strength, upscaler
- `refiner` (object, optional) — switch_at (0 to 1)

Extra object parameters:
- `response_image_type` (string) — png, webp, or jpeg. Default: png
- `enable_nsfw_detection` (boolean) — enable content safety filter
- `webhook` (object) — callback URL for async notification. Security: only use HTTPS webhook URLs you control.
- `custom_storage` (object) — optional AWS S3 storage configuration

Available samplers: Euler a, Euler, LMS, Heun, DPM2, DPM2 a, DPM++ 2S a, DPM++ 2M, DPM++ SDE, DPM fast, DPM adaptive, LMS Karras, DPM2 Karras, DPM2 a Karras, DPM++ 2S a Karras, DPM++ 2M Karras, DPM++ SDE Karras, DDIM, PLMS, UniPC

## Stable Diffusion Image-to-Image

Endpoint: `POST /v3/async/img2img` (asynchronous, returns task_id)

Same parameters as txt2img with two additions:
- `request.image_base64` (string, required) — base64-encoded source image from a trusted local file
- `request.strength` (number, required) — transformation strength, range 0 to 1

## Image Editing — Synchronous Endpoints

All sync editing endpoints accept `image_file` as a base64-encoded image string from a local file.

### Remove Background
Endpoint: `POST /v3/remove-background`
- `image_file` (string, required) — base64 image, max 16 megapixels, max 30 MB
- `extra.response_image_type` — png, webp, or jpeg
- Returns: base64-encoded result image

### Replace Background
Endpoint: `POST /v3/replace-background`
- `image_file` (required) — base64 image
- `prompt` (required) — description of the new background

### Reimagine
Endpoint: `POST /v3/reimagine`
- `image_file` (required) — base64 image

### Image to Prompt
Endpoint: `POST /v3/img2prompt`
- `image_file` (required) — base64 image
- Returns text description of the image

### Remove Text
Endpoint: `POST /v3/remove-text`
- `image_file` (required) — base64 image

### Cleanup (Erase Region)
Endpoint: `POST /v3/cleanup`
- `image_file` (required) — base64 original image
- `mask_file` (required) — base64 mask where white indicates areas to erase

### Outpainting
Endpoint: `POST /v3/outpainting`
- `image_file` (required) — base64 image
- `prompt` (optional) — description for extended area
- `width`, `height` — target canvas dimensions
- `center_x`, `center_y` — position of original image in new canvas

### Merge Face
Endpoint: `POST /v3/merge-face`
- `face_image_file` (required) — base64 face source image
- `image_file` (required) — base64 target image

### Upscale
Endpoint: `POST /v3/upscale`
- `image_file` (required) — base64 image

## Image Editing — Asynchronous Endpoints

These endpoints return a task_id. Poll with the Task Result API.

### Inpainting
Endpoint: `POST /v3/async/inpainting`
- Same request structure as txt2img
- Additional: `request.image_base64` and `request.mask_image_base64`

### Upscale (async)
Endpoint: `POST /v3/async/upscale`
- `request.model_name` — default: RealESRGAN_x4plus_anime_6B
- `request.image_base64` and `request.scale_factor`

### Replace Background (async)
Endpoint: `POST /v3/async/replace-background`
- `image_file`, `prompt`, `extra`

## Task Result Polling

Endpoint: `GET /v3/async/task-result` with query parameter `task_id`

The response contains a `task` object with `task_id`, `status`, `progress_percent`, and `reason` fields. On success, results are in the `images` array with `image_url`, `image_url_ttl`, and `image_type`.

Status values: TASK_STATUS_QUEUED, TASK_STATUS_PROCESSING, TASK_STATUS_SUCCEED, TASK_STATUS_FAILED
