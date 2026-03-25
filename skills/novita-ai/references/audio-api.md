# Novita AI Audio API Reference

> **Security**: All audio inputs should come from trusted, local sources only. Verify the origin of any audio data before processing.

## Table of Contents
- [MiniMax TTS (Speech-02-HD)](#minimax-tts)
- [MiniMax TTS Variants](#minimax-tts-variants)
- [GLM TTS](#glm-tts)
- [GLM ASR (Speech-to-Text)](#glm-asr)
- [Voice Cloning](#voice-cloning)
- [Fish Audio](#fish-audio)

## MiniMax TTS

`POST https://api.novita.ai/v3/minimax-speech-02-hd` — **Synchronous** (streaming supported)

### Request

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `text` | string | yes | Text to speak (max 10,000 chars). Supports `<#x#>` pause markers |
| `voice_setting` | object | yes | Voice configuration |
| `audio_setting` | object | no | Audio format configuration |
| `stream` | boolean | no | Enable SSE streaming (default: false) |
| `output_format` | string | no | Output encoding format (default: hex). Non-streaming only |
| `language_boost` | string | no | Language hint: English, Chinese, Japanese, Korean, etc. |

### voice_setting

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `voice_id` | string | — | Voice name (see list below) |
| `speed` | float | 1.0 | Speaking speed (0.5-2.0) |
| `vol` | float | 1.0 | Volume (0-10) |
| `pitch` | integer | 0 | Pitch adjustment (-12 to 12) |
| `emotion` | string | — | `happy`, `sad`, `angry`, `fearful`, `disgusted`, `surprised`, `neutral` |

### System Voices

| Voice ID | Style |
|----------|-------|
| `Wise_Woman` | Mature, authoritative |
| `Calm_Woman` | Gentle, soothing |
| `Friendly_Person` | Warm, conversational |
| `Deep_Voice_Man` | Rich, deep |
| `Inspirational_girl` | Energetic, young |
| `Casual_Guy` | Relaxed, informal |
| `Lively_Girl` | Upbeat, cheerful |
| `Patient_Man` | Measured, patient |
| `Young_Knight` | Confident, youthful |
| `Determined_Man` | Strong, resolute |
| `Lovely_Girl` | Sweet, playful |
| `Decent_Boy` | Clean, proper |
| `Imposing_Manner` | Commanding |
| `Elegant_Man` | Refined, sophisticated |
| `Abbess` | Serene, spiritual |
| `Sweet_Girl_2` | Sweet, feminine |
| `Exuberant_Girl` | Excited, vibrant |

### audio_setting

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `format` | string | mp3 | mp3, pcm, flac, wav |
| `sample_rate` | number | 32000 | 8000/16000/22050/24000/32000/44100 |
| `bitrate` | number | 128000 | 32000/64000/128000/256000 (mp3 only) |
| `channel` | number | 1 | 1=mono, 2=stereo |

### Advanced Features

**Timbre blending** (alternative to voice_id):
```json
{
  "timbre_weights": [
    {"voice_id": "Calm_Woman", "weight": 70},
    {"voice_id": "Deep_Voice_Man", "weight": 30}
  ]
}
```

**Voice modification**:
```json
{
  "voice_modify": {
    "pitch": 50,
    "intensity": 30,
    "timbre": 0,
    "sound_effects": "spacious_echo"
  }
}
```
Effects: `spacious_echo`, `auditorium_echo`, `lofi_telephone`, `robotic`

**Pronunciation dictionary**:
```json
{
  "pronunciation_dict": {"tone": ["omg/oh my god", "API/A-P-I"]}
}
```

### Response

Non-streaming: returns audio data in the response body

Streaming (SSE): `data: {"audio": "<hex>", "status": 1}` ... `data: {"status": 2}`

## MiniMax TTS Variants

| Endpoint | Notes |
|----------|-------|
| `/v3/minimax-speech-02-hd` | Standard, high quality |
| `/v3/minimax-speech-02-turbo` | Faster, lower quality |
| `/v3/minimax-speech-2.5-hd-preview` | Improved v2.5 |
| `/v3/minimax-speech-2.6-hd` | Improved v2.6 |
| `/v3/minimax-speech-2.8-hd` | Latest |

All share the same parameter structure as Speech-02-HD.

## GLM TTS

`POST https://api.novita.ai/v3/glm-tts` — **Synchronous** (returns binary audio)

Optimized for Chinese, low latency.

### Request

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `input` | string | yes | — | Text to speak (max 1024 chars) |
| `voice` | string | yes | tongtong | Voice name |
| `speed` | number | no | 1 | Speed (0.5-2) |
| `volume` | number | no | 1 | Volume (0-10) |
| `response_format` | string | no | pcm | `wav` or `pcm` |

### Voices

| Voice | Style |
|-------|-------|
| `tongtong` | Standard female |
| `chuichui` | — |
| `xiaochen` | — |
| `jam` | — |
| `kazi` | — |
| `douji` | — |
| `luodo` | — |

### Response

Binary audio data. Recommended sample rate: 24000 Hz.

Pipe directly to file:
```bash
curl ... --output speech.wav
```

## GLM ASR

Endpoint: `POST /v3/glm-asr` (synchronous)

Parameters:
- `file` (string, required) — encoded audio data from a local file. Supported formats: wav, mp3. Max 25 MB, max 30 seconds.
- `prompt` (string, optional) — previous transcription context for continuity, max 8000 characters
- `hotwords` (array, optional) — domain-specific vocabulary list, max 100 words

Returns a `text` field with the transcribed content.

## Voice Cloning

### MiniMax Voice Cloning
Endpoint: `POST /v3/minimax-voice-cloning`

Parameters:
- `audio` (string) — reference audio data from a local file you own or have permission to use
- `text` (string) — text to generate with the cloned voice
- `model` (string) — use "speech-02-hd"
- `accuracy` (number) — cloning accuracy level

### GLM TTS Voice Clone
Asynchronous endpoint — returns task_id for polling.

## Fish Audio

### Fish Audio TTS
Asynchronous endpoint — returns task_id. Supports custom voices from the Fish Audio voice library.

### Fish Audio Voice Cloning
Asynchronous endpoint — create custom voices from audio samples.
