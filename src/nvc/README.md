
# NVC VHDL Compiler (nvc)

Installs NVC, an open source VHDL compiler and simulator (https://github.com/nickg/nvc).

## Example Usage

```json
"features": {
    "ghcr.io/StephanHeider/devcontainer-features/nvc:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | NVC version to install (e.g. 1.23.1) or 'latest'. | string | latest |
| installMethod | 'deb' uses the prebuilt Ubuntu package (amd64, Ubuntu 22.04/24.04/26.04 only), 'source' builds from the release tarball, 'auto' prefers 'deb' and falls back to 'source'. | string | auto |
| libraries | Space or comma separated list of third-party VHDL libraries to pre-compile via 'nvc --install' (e.g. 'osvvm uvvm'). | string | - |

## Supported platforms

- Debian/Ubuntu based images (`apt-get` is required).
- With `installMethod: auto` the prebuilt `.deb` from the
  [NVC releases](https://github.com/nickg/nvc/releases) is used on amd64 Ubuntu 22.04/24.04/26.04.
  On all other distributions/architectures (e.g. Debian, arm64) NVC is built from source,
  which takes a few minutes.

## Third-party libraries

Libraries listed in `libraries` are compiled with `nvc --install` into NVC's system
library directory, so they are available to every user without `-L`:

```json
"features": {
    "ghcr.io/stephanheider/devcontainer-features/nvc:1": {
        "libraries": "osvvm uvvm"
    }
}
```


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/StephanHeider/devcontainer-features/blob/main/src/nvc/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
