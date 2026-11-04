# Dev Container Features

A collection of [Dev Container Features](https://containers.dev/implementors/features/),
published to `ghcr.io/stephanheider/devcontainer-features`.

| Feature | Description |
| ------- | ----------- |
| [nvc](src/nvc) | [NVC](https://github.com/nickg/nvc) open source VHDL compiler and simulator |

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

OSVVM is then usable directly via `library osvvm;` without any `-L` option.
Further libraries supported by `nvc --install` (e.g. `uvvm`, `vunit`) can be added as a space or comma separated list.

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