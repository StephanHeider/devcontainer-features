#!/bin/bash
set -e

source dev-container-features-test-lib

check "dotfiles repository was cloned" test -d "${HOME}/.dotfiles/.git"
check "dotfiles clone has an origin" git -C "${HOME}/.dotfiles" remote get-url origin

reportResults