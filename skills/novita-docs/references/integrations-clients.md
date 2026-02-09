# Integrations: Clients and Platforms

Last verified: 2026-02-09

## Table of Contents
- [AI Coding Assistants](#ai-coding-assistants)
- [AI Platforms](#ai-platforms)
- [Browser Extensions](#browser-extensions)

## AI Coding Assistants

### Cursor
1. Open **Settings** -> **Models**
2. Uncheck default models
3. Add model: `deepseek/deepseek-r1`
4. Set **OpenAI Base URL**: `https://api.novita.ai/openai`
5. Enter your **Novita API Key**
6. Click **Verify**

### Continue (VS Code / JetBrains)

Edit `~/.continue/config.json`:
```json
{
  "models": [
    {
      "title": "Novita DeepSeek",
      "provider": "openai",
      "model": "deepseek/deepseek-r1",
      "apiBase": "https://api.novita.ai/openai",
      "apiKey": "<YOUR_API_KEY>"
    }
  ]
}
```

### Claude Code

```bash
export OPENAI_API_BASE=https://api.novita.ai/openai
export OPENAI_API_KEY=<YOUR_API_KEY>
```

### CodeCompanion (Neovim)

```lua
require("codecompanion").setup({
  adapters = {
    novita = function()
      return require("codecompanion.adapters").extend("openai", {
        url = "https://api.novita.ai/openai/v1/chat/completions",
        env = { api_key = "NOVITA_API_KEY" },
        schema = { model = { default = "deepseek/deepseek-r1" } },
      })
    end,
  },
})
```

## AI Platforms

### Dify
1. Go to **Settings** -> **Model Providers**
2. Find **Novita AI** in the list
3. Paste your API key
4. Click **Save**

### LangFlow
1. Add **ChatOpenAI** component
2. Set **OpenAI API Base**: `https://api.novita.ai/openai`
3. Set **OpenAI API Key**: your Novita key
4. Set **Model Name**: `deepseek/deepseek-r1`

### AnythingLLM
1. Go to **Settings** -> **LLM Preference**
2. Select **Novita AI** or **Generic OpenAI**
3. Enter API key and base URL
4. Choose model

## Browser Extensions

### LobeChat
1. Go to **Settings** -> **Language Models**
2. Enable **Novita AI** provider
3. Enter API key
4. Select model

### ChatBox
1. Open **Settings**
2. Add new AI provider: **OpenAI API Compatible**
3. API Host: `https://api.novita.ai`
4. API Key: your Novita key
5. Model: `deepseek/deepseek-r1`

### Page Assist
1. Click extension icon -> **Settings**
2. Select **Novita AI** or **Custom OpenAI**
3. Enter API key and base URL
