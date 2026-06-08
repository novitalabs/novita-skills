# Agent Sandbox Guide

Novita Agent Sandbox is a secure, isolated cloud environment for executing AI-generated code.

## Table of Contents
- [Agent Sandbox Guide](#agent-sandbox-guide)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Use Cases](#use-cases)
  - [Quick Start](#quick-start)
    - [1. Install SDK](#1-install-sdk)
    - [2. Set API Key](#2-set-api-key)
    - [3. Create and Run Sandbox](#3-create-and-run-sandbox)
  - [Core Operations](#core-operations)
    - [Run Code](#run-code)
    - [File Operations](#file-operations)
    - [Background Commands](#background-commands)
  - [Lifecycle Management](#lifecycle-management)
    - [Pause and Resume](#pause-and-resume)
    - [Clone](#clone)
    - [Idle Timeout](#idle-timeout)
  - [Templates](#templates)
    - [Create Template](#create-template)
    - [Use Template](#use-template)
  - [CLI Usage](#cli-usage)
    - [Install CLI](#install-cli)
    - [Commands](#commands)
  - [Pricing](#pricing)
  - [Framework Integrations](#framework-integrations)
    - [LangChain](#langchain)
    - [OpenAI Agents SDK](#openai-agents-sdk)
  - [E2B Compatibility](#e2b-compatibility)
  - [Quota and Template Limits](#quota-and-template-limits)
  - [Resources](#resources)

## Features

- **Secure**: System-level isolation for safe code execution
- **Fast**: Startup latency depends on template, region, and workload
- **Multi-language**: Python, JavaScript, TypeScript, C++, and more
- **Persistent**: Pause/resume with state preserved
- **Scalable**: Supports large-scale concurrent sandboxes

## Use Cases

- AI data analysis and visualization
- Code execution for AI agents
- Computer Use agents
- Safe code testing environment

---

## Quick Start

### 1. Install SDK

**JavaScript/TypeScript:**
```bash
npm i novita-sandbox
```

**Python:**
```bash
pip install novita-sandbox
```

### 2. Set API Key

```bash
export NOVITA_API_KEY=sk_***
```

Or in `.env` file:
```
NOVITA_API_KEY=sk_***
```

### 3. Create and Run Sandbox

**Python (original baseline):**
```python
# main.py
from dotenv import load_dotenv
from novita_sandbox.code_interpreter import Sandbox


# The .env file should be located in the project root directory
# dotenv will automatically look for .env in the current working directory
load_dotenv()

# Or
# You can set the environment variable in the command line
# export NOVITA_API_KEY=sk_***

sandbox = Sandbox.create()
execution = sandbox.run_code("print('hello world')")
print(execution.logs)

files = sandbox.files.list("/")
print(files)

# Close sandbox when no longer needed
sandbox.kill()
```

For JavaScript/TypeScript, generate equivalent code from this Python baseline.

---

## Core Operations

For JavaScript snippets below, run in an async context (top-level await in ESM, or wrap in `async function main()`).

### Run Code

```javascript
// JavaScript
const result = await sandbox.runCode(`
import pandas as pd
df = pd.DataFrame({'a': [1, 2, 3]})
print(df.describe())
`);
console.log(result.logs);
```

### File Operations

```javascript
// Write file
await sandbox.files.write('/tmp/data.txt', 'Hello World');

// Read file
const content = await sandbox.files.read('/tmp/data.txt');

// List directory
const files = await sandbox.files.list('/tmp');

// Upload file
await sandbox.files.upload('/local/file.txt', '/sandbox/file.txt');

// Download file
await sandbox.files.download('/sandbox/output.txt', '/local/output.txt');
```

### Background Commands 

```javascript
// Run command in background
const proc = await sandbox.commands.run('python long_task.py', {
  background: true
});

// Check status later
const status = await proc.status();

// Get output
const output = await proc.output();
```

---

## Lifecycle Management

### Pause and Resume

```javascript
// Pause sandbox (preserves state)
await sandbox.pause();

// Resume later
const resumed = await Sandbox.resume(sandbox.id);
```

### Clone

```javascript
// Clone a sandbox
const clone = await sandbox.clone();
```

### Idle Timeout

Sandboxes auto-pause after idle timeout (current default can change by product policy and configuration).

```javascript
// Keep alive for long-running tasks
const sandbox = await Sandbox.create({
  keepAlive: true,
  timeout: 3600  // 1 hour
});
```

---

## Templates

Create reusable sandbox configurations with pre-installed packages.

### Create Template

```javascript
// Create sandbox and install packages
const sandbox = await Sandbox.create();
await sandbox.runCode('pip install pandas numpy matplotlib');

// Save as template
const template = await sandbox.saveAsTemplate('data-science');
```

### Use Template

```javascript
// Create sandbox from template
const sandbox = await Sandbox.create({
  template: 'data-science'
});
```

---

## CLI Usage

### Install CLI

```bash
npm i -g novita-sandbox-cli
```

### Commands

Run these commands in order:
```bash
novita-sandbox auth login

novita-sandbox spawn

novita-sandbox list

novita-sandbox shutdown <sandbox-id>
```

---

## Pricing

- **CPU**: Per-second billing
- **RAM**: Per-second billing
- **Storage**: Daily charges (templates, snapshots)

See https://novita.ai/docs/guides/sandbox-pricing for details.

---

## Framework Integrations

### LangChain

```python
from langchain_community.tools import NovitaSandboxTool

tool = NovitaSandboxTool()
result = tool.run("print('Hello from LangChain')")
```

### OpenAI Agents SDK

```python
from agents import Agent
from novita_sandbox import Sandbox

sandbox = Sandbox()
agent = Agent(tools=[sandbox.as_tool()])
```

---

## E2B Compatibility

Use this only when users are migrating existing E2B workflows to Novita Sandbox.

- Compatibility domain: `E2B_DOMAIN=sandbox.novita.ai`
- Auth variable: `E2B_API_KEY=<NOVITA_API_KEY>`
- Recommended for full feature access: Novita Sandbox SDK

Minimal E2B Python example:
```python
from e2b_code_interpreter import Sandbox

sbx = Sandbox.create()
execution = sbx.commands.run("ls -l")
print(execution)
sbx.kill()
```

E2B CLI flow:
```bash
e2b auth login
e2b sandbox spawn <template-id>
e2b sandbox list
e2b sandbox kill <sandbox-id>
```

---

## Quota and Template Limits

Current policy highlights (verify live before answering):

- Concurrent sandbox quota can be limited by account plan (source material baseline mentions 100).
- Template CPU range: `1-8 vCPU` (integer values).
- Template memory maximum: `8192 MiB`, in `512 MiB` steps.
- CPU:Memory ratio rules:
  - Minimum: `1:0.5`
  - Maximum: `1:4`
- Template constraints apply when creating templates and are inherited by sandboxes launched from those templates.

If users need exact current limits or higher quota, route to official docs/support before giving hard numbers.

---

## Resources

- **Console**: https://novita.ai/sandbox/console
- **Full Docs**: https://novita.ai/docs/guides/sandbox-overview
- **SDK Reference**: https://novita.ai/docs/guides/sandbox-sdk-and-cli
- **E2B Compatibility Docs**: https://novita.ai/docs/guides/sandbox-integrations-e2b-compatible
- **Template Docs**: https://novita.ai/docs/guides/sandbox-template
- **Docs Index**: https://novita.ai/docs/llms.txt
Last verified: 2026-02-09
