
# Dotfiles (dotfiles)

Clones a dotfiles repository and runs its install.sh script when present.

## Example Usage

```json
"features": {
    "ghcr.io/StephanHeider/devcontainer-features/dotfiles:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| repository | Git URL of the dotfiles repository to clone. | string | https://github.com/StephanHeider/dotfiles.git |
| branch | Optional branch to check out. By default, the repository's default branch is used. | string | - |
| gitName | Git user.name passed to install.sh. Set together with gitEmail to run the installer noninteractively. | string | - |
| gitEmail | Git user.email passed to install.sh. Set together with gitName to run the installer noninteractively. | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/StephanHeider/devcontainer-features/blob/main/src/dotfiles/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
