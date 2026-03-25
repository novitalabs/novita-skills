# Novita AI Image API Reference

All image endpoints use Bearer token authentication. Images are passed as encoded data from local files.

## Security

- Only use images from trusted, local sources
- Verify the origin of all image data before processing
- Enable NSFW detection for user-facing applications

## Image Generation

### FLUX.1 Schnell (synchronous)

`POST /v3beta/flux-1-schnell`

The fastest and cheapest text-to-image option. Returns images directly in the response.

Required fields: prompt (max 1024 chars), width (64-2048), height (64-2048), image_num (1-8), steps (1-100, recommend 4), seed.

Optional: response_image_format (png, webp, jpeg).

Pricing: $0.003 per image at 1024x1024 with 4 steps.

### FLUX Kontext (asynchronous)

Three tiers available at `/v3/async/flux-1-kontext-dev`, `-pro`, and `-max`.

Supports text-to-image and image editing with up to 4 encoded reference images from local files. Required: prompt. Optional: images (array of encoded image data), size, num_inference_steps, guidance_scale, num_images, seed, output_format.

### Stable Diffusion (asynchronous)

Text-to-image at `POST /v3/async/txt2img`. Image-to-image at `POST /v3/async/img2img`.

The request body wraps parameters in a `request` object. Required fields for txt2img: model_name (e.g. sd_xl_base_1.0.safetensors), prompt, width (128-2048), height (128-2048), image_num (1-8), steps (1-100), guidance_scale (1-30), sampler_name.

Optional: negative_prompt, seed, loras (max 5, with model_name and strength), embeddings, hires_fix, refiner.

For img2img, additionally requires the source image data and a strength value (0-1).

Samplers: Euler a, Euler, LMS, Heun, DPM2, DPM++ 2M, DPM++ SDE, DPM++ 2M Karras, DPM++ SDE Karras, DDIM, PLMS, UniPC, and others.

### Other Generation Models

Additional async endpoints at `/v3/async/{model}`: Seedream (`seedream-3.0`, `seedream-4.0`, `seedream-4.5`, `seedream-5.0-lite`), FLUX 2 (`flux-2-dev`, `flux-2-flex`, `flux-2-pro`), Qwen Image, Hunyuan Image 3, GLM Image. All return a task_id for polling.

## Image Editing

### Synchronous Endpoints

These endpoints accept an encoded image and return the result directly.

| Endpoint | Path | What It Does |
|----------|------|-------------|
| Remove Background | `/v3/remove-background` | Removes background, returns transparent image |
| Replace Background | `/v3/replace-background` | Replaces background using a text prompt |
| Reimagine | `/v3/reimagine` | Generates a new interpretation of the image |
| Image to Prompt | `/v3/img2prompt` | Describes the image as text |
| Remove Text | `/v3/remove-text` | Removes text overlays from the image |
| Cleanup | `/v3/cleanup` | Erases a masked region from the image |
| Outpainting | `/v3/outpainting` | Extends the image beyond its borders |
| Merge Face | `/v3/merge-face` | Swaps a face from one image onto another |
| Upscale | `/v3/upscale` | Enhances image resolution |

Common parameters: All accept image data (encoded, max 16 megapixels, max 30 MB). Replace Background and Outpainting also accept a text prompt. Cleanup requires a mask image. Merge Face requires both a face source and a target image.

### Asynchronous Endpoints

These return a task_id for polling.

| Endpoint | Path | What It Does |
|----------|------|-------------|
| Inpainting | `/v3/async/inpainting` | Fills a masked region guided by a text prompt |
| Upscale (async) | `/v3/async/upscale` | Enhances resolution with model selection |
| Replace Background (async) | `/v3/async/replace-background` | Alternative async version |

Inpainting uses the same request structure as Stable Diffusion txt2img, with additional image and mask fields.

## Task Result Polling

`GET /v3/async/task-result` with query parameter `task_id`.

The response includes a task status (QUEUED, PROCESSING, SUCCEED, or FAILED) and, on success, an images array with time-limited download links.

## Extra Options

Many endpoints support an `extra` object with:
- Response image format (png, webp, jpeg)
- NSFW detection toggle
- Webhook callback for async completion notifications
- Custom S3 storage for output files
