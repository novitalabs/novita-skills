# Integrations: Observability, Agents, and Training

Last verified: 2026-02-09

## Table of Contents
- [Observability and Proxy](#observability-and-proxy)
- [AI Agents](#ai-agents)
- [Model Training](#model-training)

## Observability and Proxy

### LiteLLM (Proxy)

```python
import os
import litellm

response = litellm.completion(
    model=f"openai/{os.environ['NOVITA_MODEL']}",
    api_base="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
    messages=[{"role": "user", "content": "Hello!"}]
)
```

### Helicone (Logging)

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
    default_headers={
        "Helicone-Auth": "Bearer <HELICONE_KEY>",
    }
)
```

### Langfuse (Tracing)

Langfuse traces OpenAI-compatible calls automatically once configured:
```python
import os
from langfuse.openai import openai

openai.api_base = "https://api.novita.ai/openai"
openai.api_key = os.environ["NOVITA_API_KEY"]
```

### Portkey (Gateway)

```python
import os
from portkey_ai import Portkey

client = Portkey(
    base_url="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
    virtual_key="novita-xxx"
)
```

## AI Agents

### Browser Use

```python
import asyncio
import os
from browser_use import Agent
from langchain_openai import ChatOpenAI

async def main():
    llm = ChatOpenAI(
        base_url="https://api.novita.ai/openai",
        api_key=os.environ["NOVITA_API_KEY"],
        model=os.environ["NOVITA_MODEL"],
    )

    agent = Agent(task="Search for...", llm=llm)
    await agent.run()

asyncio.run(main())
```

### Skyvern

Set in environment:
```bash
LLM_API_BASE=https://api.novita.ai/openai
LLM_API_KEY=<YOUR_API_KEY>
MODEL_NAME=<MODEL_NAME>
```

## Model Training

### Axolotl

Use this in your Axolotl config file:
```yaml
base_model: novita/model-name
api_url: https://api.novita.ai/openai
```

### Kohya SS GUI

Use Novita for inference endpoints in training pipelines.
