# Git integration

`sandbox.git.*` provides repository helpers: clone, branch, commit, pull, push, remotes, and config. All examples assume a sandbox from `novita.sandbox.create()`.

> JS methods are camelCase (`configureUser`, `createBranch`, `dangerouslyAuthenticate`); Python are snake_case (`configure_user`, `create_branch`, `dangerously_authenticate`).

## Authentication

### Inline credentials
Pass `username` + `password` (token) directly to `clone` / `push` / `pull` for private HTTPS repos.
```python
sandbox.git.push(repo_path, username=os.environ["GIT_USERNAME"], password=os.environ["GIT_TOKEN"])
sandbox.git.pull(repo_path, username=os.environ["GIT_USERNAME"], password=os.environ["GIT_TOKEN"])
```
```typescript
await sandbox.git.push(repoPath, { username: process.env.GIT_USERNAME, password: process.env.GIT_TOKEN })
await sandbox.git.pull(repoPath, { username: process.env.GIT_USERNAME, password: process.env.GIT_TOKEN })
```

### Store credentials once (credential helper)
`dangerouslyAuthenticate()` / `dangerously_authenticate()` writes credentials into the sandbox credential helper (GitHub by default, or a custom `host`/`protocol`).

> ⚠️ Credentials are written to disk inside the sandbox and readable by anything with sandbox access.

```python
sandbox.git.dangerously_authenticate(
    username=os.environ["GIT_USERNAME"], password=os.environ["GIT_TOKEN"],
    host="git.example.com", protocol="https",   # optional; defaults to GitHub
)
sandbox.git.clone("https://git.example.com/org/repo.git", path="/home/user/repo")
sandbox.git.push("/home/user/repo")
```
```typescript
await sandbox.git.dangerouslyAuthenticate({
  username: process.env.GIT_USERNAME, password: process.env.GIT_TOKEN,
  host: 'git.example.com', protocol: 'https',
})
await sandbox.git.clone('https://git.example.com/org/repo.git', { path: '/home/user/repo' })
await sandbox.git.push('/home/user/repo')
```

### Keep credentials in the remote URL
By default credentials are stripped from the remote URL after clone. To keep them in `.git/config`, set `dangerouslyStoreCredentials: true` / `dangerously_store_credentials=True` on `clone`. ⚠️ Readable by sandbox processes.

## Configure commit identity
```python
sandbox.git.configure_user("Novita Bot", "bot@example.com")
```
```typescript
await sandbox.git.configureUser('Novita Bot', 'bot@example.com')
```

## Clone
```python
sandbox.git.clone(repo_url, path=repo_path)
sandbox.git.clone(repo_url, path=repo_path, branch="main")
sandbox.git.clone(repo_url, path=repo_path, depth=1)
```
```typescript
await sandbox.git.clone(repoUrl, { path: repoPath, branch: 'main', depth: 1 })
```

## Status & branches
```python
status = sandbox.git.status(repo_path)
branches = sandbox.git.branches(repo_path)
```
```typescript
const status = await sandbox.git.status(repoPath)
const branches = await sandbox.git.branches(repoPath)
```

## Create / switch / delete branches
```python
sandbox.git.create_branch(repo_path, "feature/new-docs")
sandbox.git.checkout_branch(repo_path, "main")
sandbox.git.delete_branch(repo_path, "feature/old-docs")
```
```typescript
await sandbox.git.createBranch(repoPath, 'feature/new-docs')
await sandbox.git.checkoutBranch(repoPath, 'main')
await sandbox.git.deleteBranch(repoPath, 'feature/old-docs')
```

## Stage, commit, push, pull
```python
sandbox.git.add(repo_path)
sandbox.git.commit(repo_path, "Initial commit")
sandbox.git.push(repo_path)
sandbox.git.pull(repo_path)
```
```typescript
await sandbox.git.add(repoPath)
await sandbox.git.commit(repoPath, 'Initial commit')
await sandbox.git.push(repoPath)
await sandbox.git.pull(repoPath)
```

## Remotes & config
`remoteAdd`/`remote_add`, `setConfig`/`set_config`, `getConfig`/`get_config` manage remotes and git config on a repo path.

Related: [tools-pty.md](tools-pty.md) · [run-command.md](sandbox-run-command.md)

## SDK parameter tables

### Shared Git request options

Only these shared fields apply to Git methods; no per-call apiKey/domain options. JS fields belong in the final opts object.

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `envs` | `envs` | string map | Empty | Environment overrides for underlying Git command. |
| `user` | `user` | string | Template default user | OS user for this operation. |
| `cwd` | `cwd` | string | Unset | Working directory for shell execution; repo path still selects Git repository. |
| `timeout` | `timeoutMs` | number | Underlying command default: 60 s / 60000 ms | Execution deadline; `0` disables. |
| `request_timeout` | `requestTimeoutMs` | number | Inherited | Request deadline: Python seconds; JS milliseconds; `0` disables. |

### `git.clone(url, ...)` / `git.clone(url, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `url` | `url` | string | Required | Repository URL. |
| `path` | `path` | string | Git default destination | Clone destination. |
| `branch` | `branch` | string | Remote default | Initial branch. |
| `depth` | `depth` | integer | Unset: full history | Shallow clone depth. |
| `username` | `username` | string | Unset | HTTP(S) username; required when using password/token. |
| `password` | `password` | string | Unset | HTTP(S) password/token. |
| `dangerously_store_credentials` | `dangerouslyStoreCredentials` | boolean | false | Keep credentials in remote URL on disk. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.configure_user(name, email, ...)` / `configureUser(name, email, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `name` | `name` | string | Required | Commit author name. |
| `email` | `email` | string | Required | Commit author email. |
| `scope` | `scope` | string | `global` | Git config scope: global, local, system. |
| `path` | `path` | string | Required for local scope | Repository directory for local configuration. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.dangerously_authenticate(...)` / `dangerouslyAuthenticate(opts)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `username` | `username` | string | Required | Credential username. |
| `password` | `password` | string | Required | Password/token stored in credential helper on disk. |
| `host` | `host` | string | `github.com` | Credential host. |
| `protocol` | `protocol` | string | `https` | Credential URL scheme. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.status(path, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.branches(path, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.create_branch(path, branch, ...)` / `createBranch(path, branch, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `branch` | `branch` | string | Required | Branch name. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.checkout_branch(path, branch, ...)` / `checkoutBranch(path, branch, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `branch` | `branch` | string | Required | Branch name. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.delete_branch(path, branch, ...)` / `deleteBranch(path, branch, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `branch` | `branch` | string | Required | Branch name. |
| `force` | `force` | boolean | false | Force delete with git branch -D. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.add(path, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `files` | `files` | string array | Unset | Paths to stage; explicit list takes precedence over all. |
| `all` | `all` | boolean | true | Without files, true uses git add -A; false uses git add . |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.commit(path, message, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `message` | `message` | string | Required | Commit message. |
| `author_name` | `authorName` | string | Git configured name | Commit identity override. |
| `author_email` | `authorEmail` | string | Git configured email | Commit identity override. |
| `allow_empty` | `allowEmpty` | boolean | false | Allow commit without staged changes. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.push(path, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `remote` | `remote` | string | Configured upstream | Remote name. |
| `branch` | `branch` | string | Configured upstream/current branch | Remote branch. |
| `set_upstream` | `setUpstream` | boolean | true | Set upstream tracking. |
| `username` | `username` | string | Unset | HTTP(S) username; required when using password/token. |
| `password` | `password` | string | Unset | HTTP(S) password/token. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.pull(path, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `remote` | `remote` | string | Configured upstream | Remote name. |
| `branch` | `branch` | string | Configured upstream/current branch | Remote branch. |
| `username` | `username` | string | Unset | HTTP(S) username; required when using password/token. |
| `password` | `password` | string | Unset | HTTP(S) password/token. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.remote_add(path, name, url, ...)` / `remoteAdd(path, name, url, opts?)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `path` | `path` | string | Required | Repository directory inside sandbox. |
| `name` | `name` | string | Required | Remote name, e.g. origin. |
| `url` | `url` | string | Required | Remote URL. |
| `fetch` | `fetch` | boolean | false | Fetch after adding. |
| `overwrite` | `overwrite` | boolean | false | Replace URL if remote exists. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.set_config(key, ...)` / `setConfig(key, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `key` | `key` | string | Required | Git config key, e.g. user.name. |
| `value` | `value` | string | Required; second positional argument | Config value. |
| `scope` | `scope` | string | `global` | Git config scope: global, local, system. |
| `path` | `path` | string | Required for local scope | Repository directory for local configuration. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |

### `git.get_config(key, ...)` / `getConfig(key, ...)`

| Python parameter | JS parameter | Type | Required / default | Purpose |
|---|---|---|---|---|
| `key` | `key` | string | Required | Git config key, e.g. user.name. |
| `scope` | `scope` | string | `global` | Git config scope: global, local, system. |
| `path` | `path` | string | Required for local scope | Repository directory for local configuration. |
| Shared keyword args | Shared `opts` fields | Git request options | Optional | All fields from the shared Git request table above. |
