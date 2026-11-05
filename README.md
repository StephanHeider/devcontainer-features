# Dev Container Features

A collection of [Dev Container Features](https://containers.dev/implementors/features/),
published to `ghcr.io/stephanheider/devcontainer-features`.

| Feature | Description |
| ------- | ----------- |
| [nvc](src/nvc) | [NVC](https://github.com/nickg/nvc) open source VHDL compiler and simulator |
| [dotfiles](src/dotfiles) | Clones your dotfiles repository and runs its `install.sh`, if present |
| [backlog](src/backlog) | [Backlog.md](https://github.com/MrLesk/Backlog.md) markdown-native task manager and Kanban board |

## Usage

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
    "features": {
        "ghcr.io/stephanheider/devcontainer-features/nvc:1": {
            "version": "latest",
            "libraries": "osvvm"
        }
    }
}
```

To install your dotfiles in a development container:

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
    "features": {
        "ghcr.io/stephanheider/devcontainer-features/dotfiles:1": {
            "repository": "https://github.com/StephanHeider/dotfiles.git",
            "gitName": "Your Name",
            "gitEmail": "you@example.com"
        }
    }
}
```

The repository is cloned to `~/.dotfiles`. Set both `gitName` and `gitEmail` to run its `install.sh` as the remote user; they are passed to the script to avoid interactive prompts. Without both values, the repository is cloned but the installer is skipped. Set `branch` to check out a specific branch.

OSVVM is then usable directly via `library osvvm;` without any `-L` option.
Further libraries supported by `nvc --install` (e.g. `uvvm`, `vunit`) can be added as a space or comma separated list.

To install Backlog.md (prebuilt binary, amd64/arm64):

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
    "features": {
        "ghcr.io/stephanheider/devcontainer-features/backlog:1": {
            "version": "latest"
        }
    }
}
```

## Repository layout

```
src/<feature>/devcontainer-feature.json   feature metadata and options
src/<feature>/install.sh                  install script
test/<feature>/test.sh                    default test (run against any base image)
test/<feature>/scenarios.json             additional scenarios, each with a <name>.sh test
```

## Testing locally

```bash
npm install -g @devcontainers/cli
devcontainer features test -f nvc .
```