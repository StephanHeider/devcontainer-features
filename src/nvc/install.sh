#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-latest}"
INSTALL_METHOD="${INSTALLMETHOD:-auto}"
LIBRARIES="${LIBRARIES:-}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run as root." >&2
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "Only Debian/Ubuntu based images are supported." >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
APT_UPDATED=false

apt_install() {
    if [ "${APT_UPDATED}" = "false" ]; then
        apt-get update -y
        APT_UPDATED=true
    fi
    apt-get install -y --no-install-recommends "$@"
}

apt_install ca-certificates curl

if [ "${VERSION}" = "latest" ]; then
    # Follow the redirect instead of using the API to avoid rate limits
    tag_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/nickg/nvc/releases/latest)"
    VERSION="${tag_url##*/r}"
fi
VERSION="${VERSION#r}"
VERSION="${VERSION#v}"
echo "Installing NVC ${VERSION} (method: ${INSTALL_METHOD})"

# Read in a subshell: /etc/os-release defines VERSION, which would clobber ours
ID="$(. /etc/os-release && echo "${ID}")"
VERSION_ID="$(. /etc/os-release && echo "${VERSION_ID:-}")"
ARCH="$(dpkg --print-architecture)"
DEB_URL="https://github.com/nickg/nvc/releases/download/r${VERSION}/nvc_${VERSION}-1_${ARCH}_${ID}-${VERSION_ID:-unknown}.deb"
SRC_URL="https://github.com/nickg/nvc/releases/download/r${VERSION}/nvc-${VERSION}.tar.gz"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

install_deb() {
    echo "Downloading ${DEB_URL}"
    curl -fsSL -o "${TMP_DIR}/nvc.deb" "${DEB_URL}" || return 1
    apt_install "${TMP_DIR}/nvc.deb"
}

install_source() {
    echo "Building NVC from ${SRC_URL}"
    apt_install build-essential pkg-config flex llvm-dev \
        zlib1g-dev libdw-dev libffi-dev libzstd-dev
    curl -fsSL -o "${TMP_DIR}/nvc.tar.gz" "${SRC_URL}"
    tar -xzf "${TMP_DIR}/nvc.tar.gz" -C "${TMP_DIR}"
    local llvm_config
    llvm_config="$(command -v llvm-config || ls /usr/bin/llvm-config-* 2>/dev/null | sort -V | tail -n1)"
    mkdir -p "${TMP_DIR}/nvc-${VERSION}/build"
    cd "${TMP_DIR}/nvc-${VERSION}/build"
    ../configure --prefix=/usr/local --with-llvm="${llvm_config}" --enable-release
    make -j"$(nproc)"
    make install
    cd /
}

case "${INSTALL_METHOD}" in
    deb)
        install_deb || { echo "No prebuilt package for ${ID}-${VERSION_ID:-?}/${ARCH}." >&2; exit 1; }
        ;;
    source)
        install_source
        ;;
    auto)
        install_deb || { echo "No prebuilt package available, falling back to source build."; install_source; }
        ;;
    *)
        echo "Unknown installMethod '${INSTALL_METHOD}'." >&2
        exit 1
        ;;
esac

LIBRARIES="${LIBRARIES//,/ }"
if [ -n "${LIBRARIES// /}" ]; then
    apt_install git make tcl tcllib
    # Install next to the standard libraries so they are found by every user
    NVC_LIBDIR="$(dirname "$(find /usr -type f -path '*/nvc/install-osvvm.sh' -print -quit)")"
    for lib in ${LIBRARIES}; do
        echo "Installing VHDL library '${lib}' into ${NVC_LIBDIR}"
        CACHE="${TMP_DIR}/cache" nvc --install "${lib}" --dest="${NVC_LIBDIR}"
    done
fi

rm -rf /var/lib/apt/lists/*

nvc --version
