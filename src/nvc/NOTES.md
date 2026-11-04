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
