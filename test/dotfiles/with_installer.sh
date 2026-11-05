#!/bin/bash
set -e

source dev-container-features-test-lib

check "dotfiles installer links Bash configuration" test -L "${HOME}/.bashrc"
check "dotfiles installer links Vim configuration" test -L "${HOME}/.vimrc"
check "dotfiles installer configures Git identity" bash -c 'test "$(git config --file "$HOME/.gitconfig.local" user.name)" = "Dev Container Test" && test "$(git config --file "$HOME/.gitconfig.local" user.email)" = "devcontainer@example.invalid"'

reportResults