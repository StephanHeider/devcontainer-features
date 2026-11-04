#!/bin/bash
set -e

source dev-container-features-test-lib

check "nvc is on PATH" nvc --version

reportResults
