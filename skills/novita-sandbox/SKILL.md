---
name: novita-sandbox-skills
version: 1.0.0a3
description: >-
  Write and troubleshoot Python, JavaScript/TypeScript, and CLI workflows for
  Novita Agent Sandbox. Covers sandbox lifecycle, commands, network egress,
  secured access, templates and readiness checks, snapshots, filesystem,
  secrets, persistent volumes, regions, Git, PTY, log streaming, and desktop VNC.
  Use when working with novita-sandbox, the Novita client, novita CLI commands,
  sandbox files or credentials, custom templates, service previews, long-running
  sandboxes, or NOVITA_DOMAIN.
---

# Novita Sandbox SDK & CLI

Write correct, idiomatic code for the **Novita Agent Sandbox** — Sandbox module. This skill gives you the accurate client entry point, method names, parameters, and equivalent CLI commands across Python, JavaScript/TypeScript, and the `novita` CLI.

The authoritative source is the product documentation at <https://docs.novita.ai> (the SDK code in this repo may lag behind). This skill reflects the current documented API. For what changed between releases, see the changelog at <https://docs.novita.ai/changelog>.

## Client entry point

All SDK usage goes through the `Novita` client. Create one client, then call operations under `novita.sandbox.*`.

**Python**
```python
from novita_sandbox import Novita

novita = Novita()  # reads NOVITA_API_KEY from the environment
sandbox = novita.sandbox.create()
```

**JavaScript / TypeScript**
```javascript
import { Novita } from 'novita-sandbox'

const novita = new Novita()  // reads NOVITA_API_KEY from the environment
const sandbox = await novita.sandbox.create()
```

**CLI** — every command is under `novita sandbox <verb>`. Set `NOVITA_API_KEY` in the environment first.

> **Note:** JS methods are camelCase (`getInfo`, `setTimeout`, `getEvents`); Python methods are snake_case (`get_info`, `set_timeout`, `get_events`). Time is milliseconds in JS (`timeoutMs`) and seconds in Python (`timeout`).

## Prerequisites

This skill documents the API as of SDK/CLI **2.1.0 — both the `novita-sandbox` SDK and `novita-sandbox-cli` must be >= 2.1.0**. Older versions are missing or behave differently for some of the operations described here; if the user's installed version is older, ask them to upgrade before relying on these references.

- Python: `pip install "novita-sandbox>=2.1.0"` (Python 3.9+)
- JS/TS: `npm i novita-sandbox@^2.1.0` (Node.js 20+)
- CLI: `npm i -g novita-sandbox-cli@^2.1.0` (check with `novita --version`)
- Set `NOVITA_API_KEY` in the environment for all three.

## Choosing what to read

Each operation has a reference file with Python + JS/TS + CLI examples. Read the one you need — don't guess the API.

**Regions** — which Novita region / API domain to connect to:

| Task | Reference |
|------|-----------|
| Available regions, select v2 (default, `us-phx-1`) vs v1 (`us-virginia-1`) via `NOVITA_DOMAIN` or `--domain`, legacy-domain limits | [references/region.md](references/region.md) |

**Sandbox module** — manage running sandboxes:

| Task | Reference |
|------|-----------|
| Create a sandbox (from template, envs, metadata, secrets, lifecycle) | [references/sandbox-create.md](references/sandbox-create.md) |
| Run commands inside a sandbox (foreground, background, streaming) | [references/sandbox-run-command.md](references/sandbox-run-command.md) |
| List sandboxes (filter by state / metadata, pagination) | [references/sandbox-list.md](references/sandbox-list.md) |
| Connect to a running sandbox | [references/sandbox-connect.md](references/sandbox-connect.md) |
| Pause & resume a sandbox | [references/sandbox-pause-resume.md](references/sandbox-pause-resume.md) |
| Kill a sandbox (single or all) | [references/sandbox-kill.md](references/sandbox-kill.md) |
| Timeout (max lifetime) and lifecycle on timeout | [references/sandbox-timeout.md](references/sandbox-timeout.md) |
| Long-running sandboxes (lift the 1-hour timeout cap via the `long_running` metadata marker) | [references/sandbox-long-running.md](references/sandbox-long-running.md) |
| Idle timeout (auto-stop/pause on inactivity) | [references/sandbox-idle-timeout.md](references/sandbox-idle-timeout.md) |
| Info, metrics, and events | [references/sandbox-info-metrics-events.md](references/sandbox-info-metrics-events.md) |
| Network access (disable internet, egress rules, public/private service URLs, Host header mask) | [references/sandbox-network.md](references/sandbox-network.md) |
| Secured controller access, legacy template migration, service vs controller authentication | [references/sandbox-secured-access.md](references/sandbox-secured-access.md) |

**Template module** — build reusable sandbox blueprints (`novita.template.*`):

| Task | Reference |
|------|-----------|
| Define a template (base image, private registries, user/workdir, run/copy/env, packages, git clone, start command and ready checks) | [references/template-define.md](references/template-define.md) |
| Build a template and control the build cache | [references/template-build.md](references/template-build.md) |
| Assign / remove / get template tags | [references/template-tags.md](references/template-tags.md) |
| List & delete templates | [references/template-list-delete.md](references/template-list-delete.md) |

**Snapshot module** — save and restore sandbox state:

| Task | Reference |
|------|-----------|
| Create a snapshot, create a sandbox from a snapshot, list & delete snapshots | [references/snapshot.md](references/snapshot.md) |

**Filesystem module** — files inside a sandbox (`sandbox.files.*`):

| Task | Reference |
|------|-----------|
| Read / write files (single & multiple), file & directory metadata | [references/fs-read-write.md](references/fs-read-write.md) |
| Watch a directory for filesystem events | [references/fs-watch.md](references/fs-watch.md) |
| Upload / download data, including pre-signed URLs | [references/fs-upload-download.md](references/fs-upload-download.md) |

**Secret module** — inject credentials without exposing them (`Secret` class):

| Task | Reference |
|------|-----------|
| Create / get / list / update / delete secrets, `secret_envs`, and HTTPS-header-only substitution limits | [references/secret.md](references/secret.md) |

**Volume module** — persistent storage that outlives a sandbox (`novita.volume.*`):

| Task | Reference |
|------|-----------|
| Create/connect/list/get volumes, mount at creation or runtime, reuse data across sandboxes, update quota, unmount and delete | [references/volume.md](references/volume.md) |

**Tools / integrations** — capabilities layered on a sandbox:

| Task | Reference |
|------|-----------|
| Git — clone, branch, commit, push/pull, remotes, auth (`sandbox.git.*`) | [references/tools-git.md](references/tools-git.md) |
| PTY — interactive terminal sessions (`sandbox.pty.*`) | [references/tools-pty.md](references/tools-pty.md) |
| Log streaming — stream command stdout/stderr in real time | [references/tools-log-streaming.md](references/tools-log-streaming.md) |
| Computer Use — virtual desktop + VNC stream (`novita.desktop.*`) | [references/tools-computer-use.md](references/tools-computer-use.md) |

**CLI** — `novita` commands (auth, snapshot, secret, volume, and a full command index). Each resource reference keeps its CLI examples beside the corresponding parameter table:

| Task | Reference |
|------|-----------|
| Auth (login/logout/info/configure), snapshot/secret/volume groups, CLI-only sandbox/template commands, command index | [references/cli-reference.md](references/cli-reference.md) |

**Parameter reference** — every SDK operation has an explicit table in its topic reference. Shared connection, time, size, and request-option groups are centralized here:

| Shared SDK parameter semantics | Reference |
|---|---|
| Constructor, connection subsets, request deadlines, units | [references/common-parameters.md](references/common-parameters.md) |

## Best practices & integration guides (external)

End-to-end guides on <https://docs.novita.ai> for common scenarios that combine several operations above. These are not mirrored in `references/`; fetch the page when the user's task matches one of them:

| Scenario | Guide |
|----------|-------|
| Connect a sandbox to a private Tailscale tailnet (`tailscale` template, auth keys, subnet routing) | <https://docs.novita.ai/guides/sandbox-vpn-tailscale> |
| Route sandbox traffic through an OpenVPN tunnel using a `.ovpn` client config | <https://docs.novita.ai/guides/sandbox-vpn-openvpn> |
| Use Novita Sandbox as the cloud execution backend for the Harbor agent-evaluation framework | <https://docs.novita.ai/guides/sandbox-integrations-harbor> |
| Run Hugging Face OpenEnv RL environments with Novita Sandbox as the provider | <https://docs.novita.ai/guides/sandbox-integrations-openenv> |
| Run Browser Use AI browser agents at high concurrency inside sandboxes | <https://docs.novita.ai/guides/sandbox-integrations-browser-use> |
| Virtual desktop with VNC streaming (Computer Use) | <https://docs.novita.ai/guides/sandbox-integrations-desktop> |
| Run OpenAI Codex as a coding agent in the `codex` template | <https://docs.novita.ai/guides/sandbox-coding-agent-codex> |
| Run Claude Code as a coding agent in a sandbox | <https://docs.novita.ai/guides/sandbox-coding-agent-claude-code> |
| Mount S3-compatible object storage for data that must outlive the sandbox | <https://docs.novita.ai/guides/sandbox-mount-cloudstorage> |
| SSH into a sandbox (template with an `sshd` ready check) | <https://docs.novita.ai/guides/sandbox-ssh-access> |

## Conventions used in every example

- The SDK examples assume `novita` is an initialized `Novita` client (see above).
- Always release sandboxes you no longer need with `sandbox.kill()`; leaked sandboxes keep billing until their timeout.
- Prefer passing the API key via the `NOVITA_API_KEY` environment variable rather than hardcoding it.
- For services inside a sandbox, bind to `0.0.0.0`, choose public or token-protected service access, and use the sandbox host URL. Controller `secure` is a separate setting; see [network access](references/sandbox-network.md) and [secured access](references/sandbox-secured-access.md).

## Keeping this skill up to date

This skill is distributed as the `novita-sandbox-skills` npm package; the `version` in the frontmatter above matches the installed package version. If the documentation here appears to disagree with the actual SDK/CLI behavior, or the user asks to update this skill, upgrade every installed copy (global and project-level) to the latest published version:

```bash
npx skills add novitalabs/novita-skills --skill novita-sandbox
```

Then restart the agent session so the updated files are loaded. To check the currently installed version without upgrading, read the `version:` field in this file's frontmatter, or run `npx novita-sandbox-skills@latest --version` to see the latest published version.

To see what changed in a release (SDK, CLI, or API behavior), check the changelog at <https://docs.novita.ai/changelog>.
