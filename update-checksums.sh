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
    ARM_URL="${GITHUB_REPO}/releases/download/v${VERSION}/rgrc-aarch64-apple-darwin.tar.gz"
    INTEL_URL="${GITHUB_REPO}/releases/download/v${VERSION}/rgrc-x86_64-apple-darwin.tar.gz"
    LINUX_URL="${GITHUB_REPO}/releases/download/v${VERSION}/rgrc-x86_64-unknown-linux-gnu.tar.gz"

    info "Calculating checksums for version ${VERSION}..."
    echo

    # Download and calculate checksums
    info "Processing ARM64 (Apple Silicon)..."
    ARM_SHA256=$(download_and_checksum "$ARM_URL")
    if [[ -z "$ARM_SHA256" ]]; then
        error "Failed to get ARM64 checksum"
        exit 1
    fi
    info "ARM64 SHA256: ${ARM_SHA256}"
    echo

    info "Processing x86_64 (Intel)..."
    INTEL_SHA256=$(download_and_checksum "$INTEL_URL")
    if [[ -z "$INTEL_SHA256" ]]; then
        error "Failed to get Intel checksum"
        exit 1
    fi
    info "Intel SHA256: ${INTEL_SHA256}"
    echo

    info "Processing x86_64 (Intel)..."
    LINUX_SHA256=$(download_and_checksum "$LINUX_URL")
    if [[ -z "$LINUX_SHA256" ]]; then
        error "Failed to get Linux checksum"
        exit 1
    fi
    info "Linux SHA256: ${LINUX_SHA256}"
    echo

    # Update formula file
    info "Updating formula file..."

    # Read the file and update checksums using Ruby (most reliable cross-platform)
    ruby -i.tmp -pe "
        if /on_arm/../^  end/
            gsub(/sha256 \"[0-9a-f]{64}\"/, \"sha256 \\\"${ARM_SHA256}\\\"\")
        end
        if /on_intel/../^  end/
            gsub(/sha256 \"[0-9a-f]{64}\"/, \"sha256 \\\"${INTEL_SHA256}\\\"\")
        end
        if /on_linux/../^  end/
            gsub(/sha256 \"[0-9a-f]{64}\"/, \"sha256 \\\"${LINUX_SHA256}\\\"\")
        end
    " "$FORMULA_FILE"
    rm -f "${FORMULA_FILE}.tmp"

    # Verify changes
    if grep -q "${ARM_SHA256}" "$FORMULA_FILE" && grep -q "${INTEL_SHA256}" "$FORMULA_FILE"; then
        info "Formula file updated successfully!"
        echo
        info "Changes made:"
        echo "  ARM64:  ${ARM_SHA256}"
        echo "  Intel:  ${INTEL_SHA256}"
        echo "  Linux:  ${LINUX_SHA256}"
        echo
        info "You can review the changes with: git diff ${FORMULA_FILE}"
    else
        error "Failed to update formula file. Use 'git restore ${FORMULA_FILE}' to revert."
        exit 1
    fi
}

# Run main function
main "$@"
