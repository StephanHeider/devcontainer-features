#!/bin/bash
set -e

source dev-container-features-test-lib

cd "$(mktemp -d)"
cat > hello.vhd <<'EOF'
entity hello is
end entity;

architecture test of hello is
begin
    process
    begin
        report "Hello from NVC";
        wait;
    end process;
end architecture;
EOF

check "nvc is on PATH" nvc --version
check "analyse, elaborate and run" bash -c "nvc -a hello.vhd -e hello -r 2>&1 | grep 'Hello from NVC'"

reportResults
