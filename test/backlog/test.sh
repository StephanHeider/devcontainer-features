#!/bin/bash
set -e

source dev-container-features-test-lib

cd "$(mktemp -d)"
git init -q .

check "backlog is on PATH" backlog --version
check "init project" bash -c "backlog init demo --defaults </dev/null && test -d backlog"
check "create and list task" bash -c "backlog task create 'Hello from Backlog' && backlog task list --plain | grep 'Hello from Backlog'"

reportResults
