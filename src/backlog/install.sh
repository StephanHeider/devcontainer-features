#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-latest}"
VERSION="${VERSION#v}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run as root." >&2
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "Only Debian/Ubuntu based images are supported." >&2
    exit 1
fi

if ! [[ "${VERSION}" == "latest" || "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid version '${VERSION}'. Use 'latest' or a version like 1.55.3." >&2
    exit 1
fi

case "$(dpkg --print-architecture)" in
    amd64) ARCH="x64" ;;
    arm64) ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $(dpkg --print-architecture)" >&2
        exit 1
        ;;
esac

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl git

ASSET="backlog-bun-linux-${ARCH}"
if [ "${VERSION}" = "latest" ]; then
    URL="https://github.com/MrLesk/Backlog.md/releases/latest/download/${ASSET}"
else
    URL="https://github.com/MrLesk/Backlog.md/releases/download/v${VERSION}/${ASSET}"
fi

echo "Downloading ${URL}"
TMP_FILE="$(mktemp)"
trap 'rm -f "${TMP_FILE}"' EXIT
curl -fsSL --proto '=https' --tlsv1.2 -o "${TMP_FILE}" "${URL}"
install -m 0755 "${TMP_FILE}" /usr/local/bin/backlog

backlog --version

rm -rf /var/lib/apt/lists/*
