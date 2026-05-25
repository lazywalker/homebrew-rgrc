#!/usr/bin/env bash
#
# Script to automatically update SHA256 checksums in rgrc.rb Homebrew formula
# Usage: ./update-checksums.sh [VERSION]
#   If VERSION is not provided, it will be read from the formula file

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORMULA_FILE="${SCRIPT_DIR}/Formula/rgrc.rb"

# Function to print colored messages
info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Function to extract version from formula file
get_version_from_formula() {
    grep -E '^\s*version\s+"[^"]+"' "$FORMULA_FILE" | sed -E 's/.*"([^"]+)".*/\1/'
}

# Function to download file and calculate SHA256
download_and_checksum() {
    local url="$1"
    local filename="$(basename "$url")"
    local tmpfile="/tmp/${filename}"

    info "Downloading: $url" >&2
    if curl -fsSL -o "$tmpfile" "$url"; then
        local checksum
        if [[ "$OSTYPE" == "darwin"* ]]; then
            checksum=$(shasum -a 256 "$tmpfile" | awk '{print $1}')
        else
            checksum=$(sha256sum "$tmpfile" | awk '{print $1}')
        fi
        rm -f "$tmpfile"
        echo "$checksum"
    else
        error "Failed to download: $url"
        return 1
    fi
}

# Main script
main() {
    # Check if formula file exists
    if [[ ! -f "$FORMULA_FILE" ]]; then
        error "Formula file not found: $FORMULA_FILE"
        exit 1
    fi

    # Get version from command line or formula file
    if [[ $# -ge 1 ]]; then
        VERSION="$1"
        info "Using version from command line: $VERSION"
    else
        VERSION="$(get_version_from_formula)"
        if [[ -z "$VERSION" ]]; then
            error "Could not extract version from formula file"
            exit 1
        fi
        info "Using version from formula file: $VERSION"
    fi

    # Define URLs
    GITHUB_REPO="https://github.com/lazywalker/rgrc"
    MACOS_ARM_URL="${GITHUB_REPO}/releases/download/v${VERSION}/rgrc-aarch64-apple-darwin.tar.gz"
    MACOS_INTEL_URL="${GITHUB_REPO}/releases/download/v${VERSION}/rgrc-x86_64-apple-darwin.tar.gz"
    LINUX_ARM_URL="${GITHUB_REPO}/releases/download/v${VERSION}/rgrc-aarch64-unknown-linux-musl.tar.gz"
    LINUX_INTEL_URL="${GITHUB_REPO}/releases/download/v${VERSION}/rgrc-x86_64-unknown-linux-gnu.tar.gz"

    info "Calculating checksums for version ${VERSION}..."
    echo

    # Download and calculate checksums
    info "Processing macOS ARM64 (Apple Silicon)..."
    MACOS_ARM_SHA256=$(download_and_checksum "$MACOS_ARM_URL")
    if [[ -z "$MACOS_ARM_SHA256" ]]; then
        error "Failed to get macOS ARM64 checksum"
        exit 1
    fi
    info "macOS ARM64 SHA256: ${MACOS_ARM_SHA256}"
    echo

    info "Processing macOS x86_64 (Intel)..."
    MACOS_INTEL_SHA256=$(download_and_checksum "$MACOS_INTEL_URL")
    if [[ -z "$MACOS_INTEL_SHA256" ]]; then
        error "Failed to get macOS Intel checksum"
        exit 1
    fi
    info "macOS Intel SHA256: ${MACOS_INTEL_SHA256}"
    echo

    info "Processing Linux ARM64 (aarch64)..."
    LINUX_ARM_SHA256=$(download_and_checksum "$LINUX_ARM_URL")
    if [[ -z "$LINUX_ARM_SHA256" ]]; then
        error "Failed to get Linux ARM64 checksum"
        exit 1
    fi
    info "Linux ARM64 SHA256: ${LINUX_ARM_SHA256}"
    echo

    info "Processing Linux x86_64..."
    LINUX_INTEL_SHA256=$(download_and_checksum "$LINUX_INTEL_URL")
    if [[ -z "$LINUX_INTEL_SHA256" ]]; then
        error "Failed to get Linux x86_64 checksum"
        exit 1
    fi
    info "Linux x86_64 SHA256: ${LINUX_INTEL_SHA256}"
    echo

    # Update formula file
    info "Updating formula file..."

    # Update each sha256 by matching the URL line above it.
    # Each block has the pattern:
    #   url "https://.../<target>.tar.gz"
    #   sha256 "<old_hash>"
    # We match the URL and replace the sha256 on the next line.

    update_sha256_for_url() {
        local url_pattern="$1"
        local new_sha256="$2"
        # Use sed to find the line with the matching URL and replace the sha256 on the next line
        sed -i.bak "/${url_pattern}/{n;s/sha256 \"[0-9a-f]\{64\}\"/sha256 \"${new_sha256}\"/}" "$FORMULA_FILE"
    }

    update_sha256_for_url "aarch64-apple-darwin" "${MACOS_ARM_SHA256}"
    update_sha256_for_url "x86_64-apple-darwin" "${MACOS_INTEL_SHA256}"
    update_sha256_for_url "aarch64-unknown-linux-musl" "${LINUX_ARM_SHA256}"
    update_sha256_for_url "x86_64-unknown-linux-gnu" "${LINUX_INTEL_SHA256}"

    rm -f "${FORMULA_FILE}.bak"

    # Verify changes
    if grep -q "${MACOS_ARM_SHA256}" "$FORMULA_FILE" && grep -q "${MACOS_INTEL_SHA256}" "$FORMULA_FILE" && grep -q "${LINUX_ARM_SHA256}" "$FORMULA_FILE" && grep -q "${LINUX_INTEL_SHA256}" "$FORMULA_FILE"; then
        info "Formula file updated successfully!"
        echo
        info "Changes made:"
        echo "  macOS ARM64:    ${MACOS_ARM_SHA256}"
        echo "  macOS Intel:    ${MACOS_INTEL_SHA256}"
        echo "  Linux ARM64:   ${LINUX_ARM_SHA256}"
        echo "  Linux x86_64:  ${LINUX_INTEL_SHA256}"
        echo
        info "You can review the changes with: git diff ${FORMULA_FILE}"
    else
        error "Failed to update formula file. Use 'git restore ${FORMULA_FILE}' to revert."
        exit 1
    fi
}

# Run main function
main "$@"
