#!/bin/bash
set -e

source dev-container-features-test-lib

check "pinned version installed" bash -c "backlog --version | grep '1.55.3'"

reportResults
