# Defining a template (builder)

A **template** is the blueprint a sandbox is created from: base image, packages, files, env, and startup commands. Building one is like authoring a Dockerfile, but you express the steps in code with the builder — start from a Docker image and layer instructions on top.

Start the builder with `novita.template.new()`, chain methods, then build it (see [template-build.md](template-build.md)).

```python
template = novita.template.new().from_python_image("3.12").run_cmd("pip install fastapi")
```
```typescript
const template = novita.template.new().fromPythonImage('3.12').runCmd('pip install fastapi')
```

> JS methods are camelCase (`fromImage`, `runCmd`, `setEnvs`); Python are snake_case (`from_image`, `run_cmd`, `set_envs`).

## Base image

Start from a Docker image or another template.

| Method (JS / Python) | Use |
|----------------------|-----|
| `fromBaseImage` / `from_base_image` | Novita's default base image |
| `fromImage` / `from_image` | Any Docker image, optionally with `{ username, password }` for a private registry |
| `fromPythonImage` / `from_python_image` | Python base image by version, e.g. `'3.12'` |
| `fromUbuntuImage` / `from_ubuntu_image` | Ubuntu base image by version, e.g. `'24.04'` |
| `fromTemplate` / `from_template` | An existing template name or ID to extend |

### Private / cloud registries

Pass credentials on the base-image call.

| Registry | Method (JS / Python) | Credentials |
|----------|----------------------|-------------|
| Generic (basic auth) | `fromImage` / `from_image` | `username`, `password` |
| AWS ECR | `fromAWSRegistry` / `from_aws_registry` | `accessKeyId`, `secretAccessKey`, `region` |
| Google GCR/GAR | `fromGCPRegistry` / `from_gcp_registry` | `serviceAccountJSON` (path, JSON string, or object) |
| Oracle OCI | `fromOCIRegistry` / `from_oci_registry` | `tenancyOcid`, `userOcid`, `fingerprint`, `privateKey`, `region` |
| Huawei Cloud SWR | `fromHuaweiCloudRegistry` / `from_huawei_cloud_registry` | `accessKeyId`, `secretAccessKey`, `region` |

```typescript
const template = novita.template.new().fromImage('myregistry.com/team/app:latest', {
  username: process.env.REGISTRY_USERNAME,
  password: process.env.REGISTRY_PASSWORD,
})

novita.template.new().fromAWSRegistry('123456789.dkr.ecr.us-west-2.amazonaws.com/app:latest', {
  accessKeyId: 'AKIA...', secretAccessKey: '...', region: 'us-west-2',
})
```
```python
template = novita.template.new().from_image(
    "myregistry.com/team/app:latest",
    username=os.environ.get("REGISTRY_USERNAME"),
    password=os.environ.get("REGISTRY_PASSWORD"),
)

novita.template.new().from_aws_registry(
    "123456789.dkr.ecr.us-west-2.amazonaws.com/app:latest",
    access_key_id="AKIA...", secret_access_key="...", region="us-west-2",
)
```

## User and working directory

`setUser` / `set_user` and `setWorkdir` / `set_workdir` control subsequent build instructions. Create the directory and grant access before switching to an unprivileged user; that user must exist in the base image.

```typescript
const template = novita.template.new()
  .fromBaseImage()
  .setUser('root')
  .runCmd('mkdir -p /home/user/app && chown user:user /home/user/app')
  .setUser('user')
  .setWorkdir('/home/user/app')
  .runCmd('pwd')
```

```python
template = (
    novita.template.new()
    .from_base_image()
    .set_user("root")
    .run_cmd("mkdir -p /home/user/app && chown user:user /home/user/app")
    .set_user("user")
    .set_workdir("/home/user/app")
    .run_cmd("pwd")
)
```

## Run commands — `runCmd` / `run_cmd`

A single command string or a list (joined with `&&`); optional `user`.
```typescript
template.runCmd('apt-get update')
template.runCmd(['pip install numpy', 'pip install pandas'])
template.runCmd('apt-get install vim', { user: 'root' })
```
```python
template.run_cmd('apt-get update')
template.run_cmd(['pip install numpy', 'pip install pandas'])
template.run_cmd('apt-get install vim', user='root')
```

## Copy files — `copy`

`src` (path or list) → `dest`. Options: `forceUpload`/`force_upload`, `user`, `mode`, `resolveSymlinks`/`resolve_symlinks`.
```typescript
template.copy('requirements.txt', '/home/user/')
template.copy(['app.ts', 'config.ts'], '/app/', { mode: 0o755 })
```
```python
template.copy('requirements.txt', '/home/user/')
template.copy(['app.py', 'config.py'], '/app/', mode=0o755)
```

## Set environment — `setEnvs` / `set_envs`

> The current SDK records these values in the template runtime environment as well as making them available to subsequent build instructions. Values supplied through `sandbox.create(envs=...)` / `create({ envs })` can override them at runtime.

```typescript
template.setEnvs({ NODE_ENV: 'production', PORT: '8080' })
```
```python
template.set_envs({'APP_ENV': 'production', 'PORT': '8000'})
```

## Install packages

Each helper takes a single package or a list; omit packages to install from the current project (`pip install .` / `package.json`).

| Method (JS / Python) | Options |
|----------------------|---------|
| `pipInstall` / `pip_install` | `g` (default **true** = global; `false` → `--user`) |
| `npmInstall` / `npm_install` | `g` (`-g`), `dev` (dev deps) |
| `bunInstall` / `bun_install` | `g`, `dev` (uses `bun`) |
| `aptInstall` / `apt_install` | `noInstallRecommends`/`no_install_recommends`, `fixMissing`/`fix_missing` — runs as root; packages required |

```typescript
template.pipInstall(['pandas', 'scikit-learn'])
template.pipInstall('numpy', { g: false })
template.npmInstall('typescript', { dev: true })
template.aptInstall(['git', 'curl'], { noInstallRecommends: true })
```
```python
template.pip_install(['pandas', 'scikit-learn'])
template.pip_install('numpy', g=False)
template.npm_install('typescript', dev=True)
template.apt_install(['git', 'curl'], no_install_recommends=True)
```

## Clone a repo — `gitClone` / `git_clone`

`url` required; optional `path`, `branch`, `depth`, `user`. No dedicated auth params — for private repos embed a token in the URL or set it up with a prior `runCmd`.
```typescript
template.gitClone('https://github.com/user/repo.git', '/app/repo')
template.gitClone('https://github.com/user/repo.git', undefined, { branch: 'main', depth: 1 })
```
```python
template.git_clone('https://github.com/user/repo.git', '/app/repo')
template.git_clone('https://github.com/user/repo.git', branch='main', depth=1)
```

## Startup and readiness

Use `runCmd` / `run_cmd` for finite build steps such as installing dependencies. Put the service command in `setStartCmd(startCommand, readyCommand)` / `set_start_cmd(start_cmd, ready_cmd)`. The second argument is required: it is a command that exits **0** when the service is ready, or a `ReadyCmd` helper. Do not launch a never-ending server as a build step.

Call startup/readiness methods after the build steps. They return `TemplateFinal`, which you pass to `novita.template.build(...)`; in Python it no longer exposes the normal builder methods. `setReadyCmd` / `set_ready_cmd` sets just the readiness check when the template already has a start command.

| Ready check (JS / Python) | Meaning / dependency inside the image |
|--------------------------|---------------------------------------|
| `waitForPort(port)` / `wait_for_port(port)` | Port is listening; requires `ss` (typically `iproute2`). |
| `waitForURL(url, statusCode)` / `wait_for_url(url, status_code)` | HTTP status matches (default 200); requires `curl`. |
| `waitForProcess(name)` / `wait_for_process(name)` | Process exists; requires `pgrep` (typically `procps`). |
| `waitForFile(path)` / `wait_for_file(path)` | A readiness marker file exists. |

Import the helpers from `novita-sandbox` (JS) or `novita_sandbox.core` (Python). Prefer an HTTP health endpoint when readiness requires more than an open port. A raw check such as `curl -fsS http://127.0.0.1:3000/health` must fail until ready; do not append `|| true`.

### Complete example: build and launch a ready HTTP service

These examples install the readiness tool, configure startup, build the template, create a sandbox, verify the service from inside it, and clean up the sandbox. The built template remains available for reuse.

**Python**
```python
from novita_sandbox import Novita
from novita_sandbox.core import wait_for_url

novita = Novita()
template = (
    novita.template.new()
    .from_python_image("3.12")
    .set_user("root")
    .run_cmd("apt-get update")
    .apt_install(["curl"])
    .run_cmd("mkdir -p /srv/preview && printf 'ready' > /srv/preview/index.html")
    .set_workdir("/srv/preview")
    .set_start_cmd(
        "python3 -m http.server 3000 --bind 0.0.0.0",
        wait_for_url("http://127.0.0.1:3000/", 200),
    )
)
build = novita.template.build(template, "http-preview", cpu_count=2, memory_mb=1024)
sandbox = novita.sandbox.create(build.template_id)
try:
    print(sandbox.commands.run("curl -fsS http://127.0.0.1:3000/").stdout)
finally:
    sandbox.kill()
```

**JavaScript / TypeScript**
```typescript
import { Novita, waitForURL } from 'novita-sandbox'

const novita = new Novita()
const template = novita.template.new()
  .fromPythonImage('3.12')
  .setUser('root')
  .runCmd('apt-get update')
  .aptInstall(['curl'])
  .runCmd("mkdir -p /srv/preview && printf 'ready' > /srv/preview/index.html")
  .setWorkdir('/srv/preview')
  .setStartCmd(
    'python3 -m http.server 3000 --bind 0.0.0.0',
    waitForURL('http://127.0.0.1:3000/', 200),
  )
const build = await novita.template.build(template, 'http-preview', {
  cpuCount: 2,
  memoryMB: 1024,
})
const sandbox = await novita.sandbox.create(build.templateId)
try {
  console.log((await sandbox.commands.run('curl -fsS http://127.0.0.1:3000/')).stdout)
} finally {
  await sandbox.kill()
}
```

For access from outside the sandbox, choose the [service access policy](sandbox-network.md#reach-a-service-through-its-public-url) when creating it. A ready check does not configure public access.

Next: [template-build.md](template-build.md) — build options, CLI startup flags, and failure diagnosis.

Sources: [Build Template](https://docs.novita.ai/guides/sandbox-template-build-operations), [V2 migration guide](https://docs.novita.ai/guides/sandbox-template-v2-migration-guide), [SSH example using a ready check](https://docs.novita.ai/guides/sandbox-ssh-access). Reviewed 2026-09-17; builder signatures and ready helpers cross-checked against the current repository.

## SDK parameter tables

### `novita.template.new(...)`

JS `new(opts?)`; Python keyword arguments. Builder methods below are local definitions and do not accept API connection options.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `file_context_path` | `fileContextPath` | path | Caller file directory | Base directory for local files copied into the template. |
| `file_ignore_patterns` | `fileIgnorePatterns` | string array | Empty | Glob patterns excluded from copied context. |

### `from_base_image()` / `fromBaseImage()`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |

### `from_python_image(version?)` / `fromPythonImage(version?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `version` | `version` | string | `3` | Python image version/tag, e.g. `3.12`. |

### `from_ubuntu_image(variant?)` / `fromUbuntuImage(variant?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `variant` | `variant` | string | `latest` | Ubuntu image tag, e.g. `24.04`. |

### `from_template(template)` / `fromTemplate(template)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `template` | `template` | string | Required | Existing template name or ID used as base. |

### `from_image(...)` / `fromImage(baseImage, credentials?, options?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `image` | `baseImage` | string | Required | Container image reference. |
| `username` | `credentials.username` | string | Unset | Registry username; supply together with password. |
| `password` | `credentials.password` | string | Unset | Registry password/token. |
| `inherit_config` | `options.inheritConfig` | boolean | true | Restore image ENV, WORKDIR and effective startup command. JS uses third argument, not credentials object. |

### `from_aws_registry(image, ...)` / `fromAWSRegistry(image, credentials)`

Python credentials are named arguments; JS credentials are fields of the second argument.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `image` | `image` | string | Required | Private container image reference. |
| `access_key_id` | `credentials.accessKeyId` | string | Required | AWS access key ID. |
| `secret_access_key` | `credentials.secretAccessKey` | string | Required | AWS secret access key. |
| `region` | `credentials.region` | string | Required | AWS region for ECR. |

### `from_gcp_registry(image, ...)` / `fromGCPRegistry(image, credentials)`

Python credentials are named arguments; JS credentials are fields of the second argument.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `image` | `image` | string | Required | Private container image reference. |
| `service_account_json` | `credentials.serviceAccountJSON` | string / object | Required | GCP service-account JSON object, JSON string, or local JSON file path. |

### `from_oci_registry(image, ...)` / `fromOCIRegistry(image, credentials)`

Python credentials are named arguments; JS credentials are fields of the second argument.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `image` | `image` | string | Required | Private container image reference. |
| `tenancy_ocid` | `credentials.tenancyOcid` | string | Required | OCI tenancy OCID. |
| `user_ocid` | `credentials.userOcid` | string | Required | OCI user OCID. |
| `fingerprint` | `credentials.fingerprint` | string | Required | Signing key fingerprint. |
| `private_key` | `credentials.privateKey` | string | Required | Signing private key. |
| `region` | `credentials.region` | string | Required | OCI region. |

### `from_huawei_cloud_registry(image, ...)` / `fromHuaweiCloudRegistry(image, credentials)`

Python credentials are named arguments; JS credentials are fields of the second argument.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `image` | `image` | string | Required | Private container image reference. |
| `access_key_id` | `credentials.accessKeyId` | string | Required | Huawei access key ID. |
| `secret_access_key` | `credentials.secretAccessKey` | string | Required | Huawei secret access key. |
| `region` | `credentials.region` | string | Required | Huawei SWR region. |

### `run_cmd(command, ...)` / `runCmd(command, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `command` | `command` | string or string array | Required | Build command; array is joined with `&&`. |
| `user` | `user` | string | Current builder user | User that executes this build step. |

### `copy(src, dest, ...)` / `copy(src, dest, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `src` | `src` | path or path array | Required | Local source files/directories resolved from file context. |
| `dest` | `dest` | path | Required | Destination in template filesystem. |
| `force_upload` | `forceUpload` | true / unset | Unset | Force upload despite cached file content. |
| `user` | `user` | string | Unset | File owner, optionally `user:group`. |
| `mode` | `mode` | integer | Unset | Permission bits, e.g. `0o755`. |
| `resolve_symlinks` | `resolveSymlinks` | boolean | Unset | Whether to resolve source symlinks. |

### `set_user(user)` / `setUser(user)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `user` | `user` | string | Required | Default OS user for subsequent instructions; must exist in image. |

### `set_workdir(workdir)` / `setWorkdir(workdir)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `workdir` | `workdir` | string | Required | Working directory for subsequent instructions. Ensure it exists and is accessible. |

### `set_envs(envs)` / `setEnvs(envs)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `envs` | `envs` | string map | Required | Environment for subsequent instructions; current source also persists it in template runtime configuration. Sandbox create envs can override. |

### `pip_install(packages?, ...)` / `pipInstall(packages?, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `packages` | `packages` | string or string array | Unset | Package names; omitted runs `pip install .`. |
| `g` | `g` | boolean | true | Global install; false adds `--user`. |

### `npm_install(packages?, ...)` / `npmInstall(packages?, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `packages` | `packages` | string or string array | Unset | Package names; omitted installs project dependencies. |
| `g` | `g` | boolean | false | Global install. |
| `dev` | `dev` | boolean | false | Install as development dependencies. |

### `bun_install(packages?, ...)` / `bunInstall(packages?, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `packages` | `packages` | string or string array | Unset | Package names; omitted installs project dependencies. |
| `g` | `g` | boolean | false | Global install. |
| `dev` | `dev` | boolean | false | Install as development dependencies. |

### `apt_install(packages, ...)` / `aptInstall(packages, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `packages` | `packages` | string or string array | Required | OS packages; runs installation as root. |
| `no_install_recommends` | `noInstallRecommends` | boolean | false | Omit recommended packages. |
| `fix_missing` | `fixMissing` | boolean | false | Add apt --fix-missing. |

### `git_clone(url, path?, ...)` / `gitClone(url, path?, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `url` | `url` | string | Required | Repository URL. |
| `path` | `path` | string | Git default destination | Destination directory in template. |
| `branch` | `branch` | string | Remote default | Branch to clone. |
| `depth` | `depth` | integer | Unset: full history | Shallow clone history depth. |
| `user` | `user` | string | Current builder user | OS user performing clone. |

### `skip_cache()` / `skipCache()`

Invalidate cache from the preceding definition step onward; whole build cache is controlled by build(skip_cache/skipCache).

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| — | — | — | No parameters | Uses the state of this object; no options argument. |

### `set_patch_cmd(cmd)` / `setPatchCmd(cmd)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `cmd` | `cmd` | string | Required | Preboot patch command for Debian provisioning with from_image/fromImage. Ignored for from_template/fromTemplate and dind. Serialized as API preBootScript. |

### `set_start_cmd(start_cmd, ready_cmd)` / `setStartCmd(startCommand, readyCommand)`

Returns TemplateFinal; finish normal builder instructions first.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `start_cmd` | `startCommand` | string | Required | Long-running service command for sandbox startup. |
| `ready_cmd` | `readyCommand` | string / ReadyCmd | Required | Command that exits 0 when ready; or helper below. |

### `set_ready_cmd(ready_cmd)` / `setReadyCmd(readyCommand)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `ready_cmd` | `readyCommand` | string / ReadyCmd | Required | Readiness check for an existing startup command. |

### `wait_for_port(port)` / `waitForPort(port)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `port` | `port` | integer | Required | Port to check using ss inside image. |

### `wait_for_url(url, status_code?)` / `waitForURL(url, statusCode?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `url` | `url` | string | Required | HTTP health endpoint reachable inside sandbox; requires curl. |
| `status_code` | `statusCode` | integer | 200 | Expected HTTP response status. |

### `wait_for_process(name)` / `waitForProcess(name)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Process name checked by pgrep. |

### `wait_for_file(path)` / `waitForFile(path)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Readiness marker file inside image. |
