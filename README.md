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

## Publishing

1. Push to `main` and run the **Release dev container features & generate documentation**
   workflow (Actions tab -> *Run workflow*). It publishes every feature under `src/` to
   `ghcr.io/stephanheider/devcontainer-features/<feature>` and opens a PR with generated READMEs.
2. Allow the workflow to create PRs: *Settings -> Actions -> General -> Workflow permissions ->
   Allow GitHub Actions to create and approve pull requests*.
3. After the first publish, make the packages public: *Profile -> Packages -> `devcontainer-features/nvc`
   -> Package settings -> Change visibility -> Public*.

Bump `version` in `devcontainer-feature.json` for every change — already published versions are not overwritten.
