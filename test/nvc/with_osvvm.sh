#!/bin/bash
set -e

source dev-container-features-test-lib

cd "$(mktemp -d)"
cat > uses_osvvm.vhd <<'EOF'
library osvvm;
use osvvm.RandomPkg.all;

entity uses_osvvm is
end entity;

architecture test of uses_osvvm is
begin
    process
        variable rv : RandomPType;
    begin
        rv.InitSeed("seed");
        report "OSVVM OK";
        wait;
    end process;
end architecture;
EOF

check "osvvm library is usable" bash -c "nvc -a uses_osvvm.vhd -e uses_osvvm -r 2>&1 | grep 'OSVVM OK'"

reportResults
