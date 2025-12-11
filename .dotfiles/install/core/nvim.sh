#!/bin/bash
set -e

PATH=$PATH:$HOME/.cargo/bin

# Neovim version to download
NVIM_VERSION="v0.11.2"
BASE_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}"

# Determine OS and architecture
OS_KERNEL=$(uname -s)
OS_ARCH=$(uname -m)

FILENAME=""
DOWNLOAD_URL=""

echo "Determining OS and architecture..."
echo "Kernel: ${OS_KERNEL}, Architecture: ${OS_ARCH}"

if [ "${OS_KERNEL}" = "Linux" ]; then
    if [ "${OS_ARCH}" = "x86_64" ]; then
        FILENAME="nvim-linux-x86_64.tar.gz"
    elif [ "${OS_ARCH}" = "aarch64" ] || [ "${OS_ARCH}" = "arm64" ]; then
        FILENAME="nvim-linux-arm64.tar.gz"
    else
        echo "Unsupported Linux architecture: ${OS_ARCH}"
        exit 1
    fi
elif [ "${OS_KERNEL}" = "Darwin" ]; then # macOS
    if [ "${OS_ARCH}" = "arm64" ] || [ "${OS_ARCH}" = "aarch64" ]; then # Apple Silicon
        FILENAME="nvim-macos-arm64.tar.gz"
    else
        echo "Unsupported macOS architecture: ${OS_ARCH}"
        exit 1
    fi
else
    echo "Unsupported operating system: ${OS_KERNEL}"
    exit 1
fi

if [ -z "${FILENAME}" ]; then
    echo "Could not determine the correct Neovim binary for your system."
    exit 1
fi

DOWNLOAD_URL="${BASE_URL}/${FILENAME}"
INSTALL_DIR="${HOME}/.local/nvim"
TMP_DIR=$(mktemp -d) # Create a temporary directory for download

echo "Target Neovim version: ${NVIM_VERSION}"
echo "Determined asset: ${FILENAME}"
echo "Download URL: ${DOWNLOAD_URL}"
echo "Installation directory: ${INSTALL_DIR}"

# Create installation directory if it doesn't exist
mkdir -p "${INSTALL_DIR}"

# Download the tarball
echo "Downloading ${FILENAME} to ${TMP_DIR}..."
if command -v curl >/dev/null 2>&1; then
    curl -L "${DOWNLOAD_URL}" -o "${TMP_DIR}/${FILENAME}"
elif command -v wget >/dev/null 2>&1; then
    wget -O "${TMP_DIR}/${FILENAME}" "${DOWNLOAD_URL}"
else
    echo "Error: Neither curl nor wget is installed. Please install one to download Neovim."
    rm -rf "${TMP_DIR}"
    exit 1
fi

echo "Download complete."

# Extract the tarball
echo "Extracting ${FILENAME} to ${INSTALL_DIR}..."
# The --strip-components=1 option removes the top-level directory (e.g., nvim-linux-x86_64/) from the archive
tar -xzf "${TMP_DIR}/${FILENAME}" -C "${INSTALL_DIR}" --strip-components=1

echo "Extraction complete."

# Clean up
echo "Cleaning up temporary files..."
rm -rf "${TMP_DIR}"

# Run initial setup
if type just &>/dev/null; then
  if [[ $XDG_CONFIG_HOME == '' ]]; then
    XDG_CONFIG_HOME="$HOME/.config"
  fi
  pushd "$XDG_CONFIG_HOME/nvim"
  just init
  popd
fi

echo "Neovim ${NVIM_VERSION} has been successfully installed to ${INSTALL_DIR}"
echo "Ensure ${INSTALL_DIR}/bin is in your PATH."
echo "For example, add 'export PATH=\"\$HOME/.local/nvim/bin:\$PATH\"' to your shell configuration file (e.g., .bashrc, .zshrc)."

exit 0
