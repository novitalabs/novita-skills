# Novita AI Video API Reference

All video endpoints are async — they return `task_id`. Poll with `GET /v3/async/task-result?task_id=X`.

## Table of Contents
- [Unified Video API](#unified-video-api)
- [Model Discovery](#model-discovery)
- [Legacy SD Video Endpoints](#legacy-sd-video-endpoints)

## Unified Video API

`POST https://api.novita.ai/v3/video/create` — **Async**

Use this endpoint for unified video task creation. Each model has its own parameter schema.

### Common Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | yes | Model name |
| `callback` | string | no | Webhook for completion notification |

### Model-Specific Parameters

Model parameters are dynamic. Fetch the configuration:
```bash
curl https://api.novita.ai/v3/admin/video-unify-api/config \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

Returns each model's `json_schema` with supported parameters (prompt, image, resolution, duration, etc.).

### Example: Text-to-Video

```bash
curl -X POST https://api.novita.ai/v3/video/create \
  -H "Authorization: Bearer $NOVITA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "<VIDEO_MODEL_NAME>",
    "prompt": "A cat playing piano in a jazz bar",
    "resolution": "720p",
    "duration": 5
  }'
```

### Example: Image-to-Video

For image-to-video, include the encoded image data from a local file in the `image` field along with a text prompt, model name, and duration.

## Model Discovery

Do not use a static video model list as a recommendation. Fetch the unified video API configuration and select the model requested by the user or required by the application.

```bash
curl https://api.novita.ai/v3/admin/video-unify-api/config \
  -H "Authorization: Bearer $NOVITA_API_KEY"
```

Use the returned `json_schema` to build valid request bodies for the selected model.

## Legacy SD Video Endpoints

### Text-to-Video (SD)
`POST https://api.novita.ai/v3/async/txt2video`

| Parameter | Type | Description |
|-----------|------|-------------|
| `model_name` | string | SD video model |
| `width`, `height` | integer | Dimensions |
| `steps` | integer | Sampling steps |
| `prompts` | array | `[{frames: int, prompt: string}]` |
| `negative_prompt` | string | Negative prompt |
| `seed` | integer | Random seed |

### Image-to-Video (SVD)
`POST https://api.novita.ai/v3/async/img2video`

| Parameter | Type | Description |
|-----------|------|-------------|
| `model_name` | string | `SVD` or `SVD-XT` |
| `image_file` | string | Encoded image data |
| `frames_num` | integer | Number of frames |
| `frames_per_second` | integer | FPS |
| `steps` | integer | Sampling steps |
| `seed` | integer | Random seed |

### Hunyuan Video Fast
`POST https://api.novita.ai/v3/async/hunyuan-video-fast`

| Parameter | Type | Description |
|-----------|------|-------------|
| `model_name` | string | Model name for the selected legacy endpoint |
| `prompt` | string | Text prompt |
| `width`, `height` | integer | Dimensions |
| `steps` | integer | Sampling steps |
| `frames` | integer | Number of frames |
| `seed` | integer | Random seed |

## Task Result

Poll: `GET /v3/async/task-result?task_id=X`

Success response includes a `videos` array, where each entry contains a time-limited download link, its TTL in seconds, and the video format (mp4).
