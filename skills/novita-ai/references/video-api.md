# Novita AI Video API Reference

All video endpoints are async — they return `task_id`. Poll with `GET /v3/async/task-result?task_id=X`.

## Table of Contents
- [Unified Video API](#unified-video-api)
- [Available Models](#available-models)
- [Legacy SD Video Endpoints](#legacy-sd-video-endpoints)

## Unified Video API

`POST https://api.novita.ai/v3/video/create` — **Async**

The recommended way to access all video models through a single endpoint. Each model has its own parameter schema.

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
    "model": "hailuo-02",
    "prompt": "A cat playing piano in a jazz bar",
    "resolution": "720p",
    "duration": 5
  }'
```

### Example: Image-to-Video

For image-to-video, include the encoded image data from a local file in the `image` field along with a text prompt, model name, and duration.

## Available Models

### Kling (Kuaishou)
| Model | Type | Key Features |
|-------|------|-------------|
| `kling-v3.0-pro-t2v` | T2V | Latest, highest quality |
| `kling-v3.0-std-t2v` | T2V | Latest, balanced |
| `kling-v3.0-pro-i2v` | I2V | Latest image-to-video |
| `kling-v3.0-std-i2v` | I2V | Latest, balanced I2V |
| `kling-v2.6-pro-t2v` | T2V | High quality |
| `kling-v2.5-turbo-t2v` | T2V | Fast |
| `kling-v2.5-master-i2v` | I2V | Image-to-video |
| `kling-v2.1-master-ref2v` | Ref2V | Reference-based |
| `kling-v2.1-master-video-edit` | Edit | Video editing |
| `kling-o1-t2v` | T2V | Reasoning model |

### Wan (Alibaba)
| Model | Type | Key Features |
|-------|------|-------------|
| `wan-2.6-t2v` | T2V | Latest |
| `wan-2.5-t2v-preview` | T2V | Fast preview |
| `wan-2.6-i2v` | I2V | Image-to-video |
| `wan-2.0-t2v`, `wan-2.2-t2v` | T2V | Earlier versions |

### Minimax Hailuo
| Model | Type | Key Features |
|-------|------|-------------|
| `hailuo-02` | T2V, I2V | General purpose |
| `hailuo-2.3-t2v` | T2V | Latest |
| `hailuo-2.3-fast-i2v` | I2V | Fast image-to-video |

### Hunyuan (Tencent)
| Model | Type | Key Features |
|-------|------|-------------|
| `hunyuan-video-fast` | T2V | Cost-effective |

### Vidu (Shengshu)
| Model | Type | Key Features |
|-------|------|-------------|
| `vidu-q3-text2video` | T2V | Highest quality |
| `vidu-q2-img2video` | I2V | Image-to-video |
| `vidu-q1-startend2video` | Start/End | Start+end frame control |
| `vidu-q1-reference2video` | Ref2V | Reference-based |

### PixVerse
| Model | Type | Key Features |
|-------|------|-------------|
| `pixverse-v4.5-t2v` | T2V | — |
| `pixverse-v4.5-i2v` | I2V | — |

### Seedance (ByteDance)
| Model | Type | Key Features |
|-------|------|-------------|
| `seedance-v1.5-pro-t2v` | T2V | Pro quality |
| `seedance-v1.5-lite-t2v` | T2V | Faster, cheaper |
| `seedance-v1-i2v` | I2V | — |

### Other
- `heygen-video-translate` — Video translation

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
| `model_name` | string | `hunyuan-video-fast` |
| `prompt` | string | Text prompt |
| `width`, `height` | integer | Dimensions |
| `steps` | integer | Sampling steps |
| `frames` | integer | Number of frames |
| `seed` | integer | Random seed |

## Task Result

Poll: `GET /v3/async/task-result?task_id=X`

Success response includes a `videos` array, where each entry contains a time-limited download link, its TTL in seconds, and the video format (mp4).
