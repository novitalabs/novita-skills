# Integrations: Frameworks

Last verified: 2026-02-09

## Table of Contents
- [LangChain (Python)](#langchain-python)
- [LlamaIndex](#llamaindex)
- [OpenAI Agents SDK](#openai-agents-sdk)

## LangChain (Python)

```python
import os
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    base_url="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
    model=os.environ["NOVITA_MODEL"],
)

response = llm.invoke("Hello!")
print(response.content)
```

For other SDKs/languages, generate equivalent code from these Python baselines and the OpenAI-compatible base URL.

## LlamaIndex

```python
import os
from llama_index.llms.openai_like import OpenAILike

llm = OpenAILike(
    api_base="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
    model=os.environ["NOVITA_MODEL"],
)
```

## OpenAI Agents SDK

```python
import os
from agents import Agent
from openai import OpenAI

client = OpenAI(
    base_url="https://api.novita.ai/openai",
    api_key=os.environ["NOVITA_API_KEY"],
)

agent = Agent(
    name="Assistant",
    model=os.environ["NOVITA_MODEL"],
)
```
