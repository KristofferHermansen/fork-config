# AGENTS.md — fork-config

Config and scripts for the [Fork](https://fork.dev) git client.

## Structure

```
run.zsh                              # dispatcher — the only thing Fork actions call
custom_scripts/*.zsh                 # one script per action
custom_scripts/repo_setup.zsh        # inject secrets, run xcodegen
custom_scripts/opencode_xcode.zsh       # open Warp split: opencode + repo_setup, then open Xcode
custom_scripts/warp_tab.zsh          # open new Warp tab at repo path
custom_scripts/xcode.zsh             # run repo_setup then open Xcode
launch_configurations/               # Warp launch config templates (unused at runtime)
debug.zsh                            # dev tool: dumps Fork env vars, useful for testing
```

## Fork action call sites

All are **Repo** actions. Paste as the command in Fork → Preferences → Custom Commands.

| Action | Fork command |
|---|---|
| 🤖 OpenCode + Xcode | `zsh ~/Git/fork-config/run.zsh opencode_xcode` |
| 🀰 Warp | `zsh ~/Git/fork-config/run.zsh warp_tab` |
| 🔨 Xcode | `zsh ~/Git/fork-config/run.zsh xcode` |

## How Fork actions work

Fork runs custom commands as bash/zsh with a **minimal env** — no `.zshrc`, no user PATH beyond what Fork adds.

**What Fork provides automatically (env vars):**
- `PWD` — absolute path to the repo (the only reliable way to get repo path)
- `GIT_EXEC_PATH`, `GIT_SSH_COMMAND` — Fork's bundled git
- Standard: `HOME`, `USER`, `SHELL`, `PATH` (includes Homebrew)

**What Fork does NOT provide as env vars:**
- Repo name, branch, SHA — not in env. Derive them:
  - Name: `basename "$PWD"`
  - Branch: `git rev-parse --abbrev-ref HEAD`

**`run.zsh` auto-derives these** before calling any script:
```zsh
export FORK_REPO_PATH="${FORK_REPO_PATH:-$PWD}"
export FORK_REPO_NAME="${FORK_REPO_NAME:-$(basename "$FORK_REPO_PATH")}"
```

## Fork inline variable substitution

Fork substitutes these **in the command string only** — they do NOT reach scripts as env vars. Use them only if constructing the call inline (not needed when using `run.zsh`).

### Repo actions
| Variable | Value |
|---|---|
| `${repo:name}` | repository name |

### Branch actions
| Variable | Value |
|---|---|
| `${repo:name}` | repository name |
| `${ref}` | branch name |
| `${ref:short}` | branch without remote prefix |
| `${ref:full}` | full reference |
| `${sha}` | commit sha |
| `${sha:abbr}` | abbreviated sha |

### Commit actions
| Variable | Value |
|---|---|
| `${repo:name}` | repository name |
| `${sha}` | commit sha |
| `${sha:abbr}` | abbreviated sha |

### File actions
| Variable | Value |
|---|---|
| `${repo:name}` | repository name |
| `${file}` | file path |
| `${file:name}` | file name |
| `${sha}` | commit sha |
| `${sha:abbr}` | abbreviated sha |

### Submodule actions
| Variable | Value |
|---|---|
| `${repo:path}` | repository path |
| `${repo:name}` | repository name |
| `${submodule}` | submodule name |

## Writing a new script

1. Create `custom_scripts/<name>.zsh`
2. Start with:
```zsh
#!/bin/zsh
set -euo pipefail

# $REPO_PATH and $REPO_NAME are exported by run.zsh — use directly
```
3. If you need branch or sha, fetch via git — do not expect them as env vars.

## Fork action one-liner (repo context)

```
zsh ~/Git/fork-config/run.zsh <script_name>
```

If the action context provides extra values you need (branch, sha), pass them explicitly since they won't be in env:

```
zsh ~/Git/fork-config/run.zsh <script_name> ${ref} ${sha}
```

Then read as `$1`, `$2` in the script (after the env var guard).

## Verified facts

- Fork sets `PWD` to repo root — confirmed via `debug.zsh` output
- `${repo:path}` is only available in submodule context, not repo/branch/commit
- Fork uses bash (2.46+) but scripts here use `#!/bin/zsh` — both work
- No `.zshrc` is sourced; tools must be on `PATH` or called with full path
