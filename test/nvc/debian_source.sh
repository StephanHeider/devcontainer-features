#!/bin/bash
set -e

source dev-container-features-test-lib

check "nvc is built from source" bash -c "command -v nvc | grep /usr/local/bin/nvc"
check "nvc runs" nvc --version

reportResults
