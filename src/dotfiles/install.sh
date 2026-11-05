#!/usr/bin/env bash
set -euo pipefail

REPOSITORY="${REPOSITORY:-https://github.com/StephanHeider/dotfiles.git}"
BRANCH="${BRANCH:-}"
GIT_NAME="${GITNAME:-}"
GIT_EMAIL="${GITEMAIL:-}"
REMOTE_USER="${_REMOTE_USER:-root}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run as root." >&2
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "Only Debian/Ubuntu based images are supported." >&2
    exit 1
fi

PACKAGES=(ca-certificates git)
if [ -n "${GIT_NAME}" ] && [ -n "${GIT_EMAIL}" ]; then
    PACKAGES+=(curl vim)
fi
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${PACKAGES[@]}"

if ! command -v runuser >/dev/null 2>&1; then
    echo "The runuser command is required to install dotfiles for the remote user." >&2
    exit 1
fi

REMOTE_HOME="$(getent passwd "${REMOTE_USER}" | cut -d: -f6)"
if [ -z "${REMOTE_HOME}" ] || [ ! -d "${REMOTE_HOME}" ]; then
    echo "Could not find a home directory for remote user '${REMOTE_USER}'." >&2
    exit 1
fi

DOTFILES_DIR="${REMOTE_HOME}/.dotfiles"
CLONE_ARGS=(clone --depth 1)
if [ -n "${BRANCH}" ]; then
    CLONE_ARGS+=(--branch "${BRANCH}" --single-branch)
fi

echo "Cloning ${REPOSITORY} into ${DOTFILES_DIR} for ${REMOTE_USER}"
runuser -u "${REMOTE_USER}" -- env HOME="${REMOTE_HOME}" git "${CLONE_ARGS[@]}" -- "${REPOSITORY}" "${DOTFILES_DIR}"

if [ -f "${DOTFILES_DIR}/install.sh" ]; then
    if [ -n "${GIT_NAME}" ] && [ -n "${GIT_EMAIL}" ]; then
        echo "Running dotfiles install.sh as ${REMOTE_USER}"
        runuser -u "${REMOTE_USER}" -- env HOME="${REMOTE_HOME}" bash -c 'cd "$1" && exec bash ./install.sh --name "$2" --email "$3"' -- "${DOTFILES_DIR}" "${GIT_NAME}" "${GIT_EMAIL}"
    else
        echo "Skipping install.sh; set both gitName and gitEmail to run it noninteractively."
    fi
else
    echo "No install.sh found in ${DOTFILES_DIR}; skipping dotfiles setup."
fi

rm -rf /var/lib/apt/lists/*