# Integrations: Observability, Agents, and Training

Last verified: 2026-08-25

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

### Arize AX (Tracing and Evaluation)

[Arize AX](https://arize.com/docs/ax/integrations/llm-providers/novita-ai/novita-ai-tracing) captures Novita calls made through the OpenAI-compatible API by using the OpenInference OpenAI instrumentor. Use AX when you want a managed workspace for production tracing, monitoring, and evaluation workflows. Use [Arize Phoenix](https://arize.com/phoenix/) when you prefer an open-source or self-hosted observability path.

Install the tracing packages:

```bash
pip install arize-otel openinference-instrumentation-openai openai
```

Configure credentials:

```bash
export ARIZE_SPACE_ID="<YOUR_ARIZE_SPACE_ID>"
export ARIZE_API_KEY="<YOUR_ARIZE_API_KEY>"
export ARIZE_PROJECT_NAME="novita-ai"
export NOVITA_API_KEY="<YOUR_NOVITA_API_KEY>"
export NOVITA_MODEL="<MODEL_NAME>"
```

Instrument the OpenAI SDK before creating the Novita client:

```python
import os

from arize.otel import register
from openinference.instrumentation.openai import OpenAIInstrumentor

tracer_provider = register(
    space_id=os.environ["ARIZE_SPACE_ID"],
    api_key=os.environ["ARIZE_API_KEY"],
    project_name=os.environ["ARIZE_PROJECT_NAME"],
)
OpenAIInstrumentor().instrument(tracer_provider=tracer_provider)

from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
)

response = client.chat.completions.create(
    model=os.environ["NOVITA_MODEL"],
    messages=[{"role": "user", "content": "Summarize this trace for review."}],
)

print(response.choices[0].message.content)
```

For deeper quality workflows, see Arize's guides to [LLM evaluation](https://arize.com/resources/llm-evaluation/) and [agent evaluation](https://arize.com/guides/ai-agent-handbook/agent-evaluation/).

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
