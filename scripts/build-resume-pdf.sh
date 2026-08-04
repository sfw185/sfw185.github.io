#!/usr/bin/env bash
#
# Generate Simon-Wardan-Resume.pdf from index.html.
# Thin wrapper around build-pdf.sh kept for convenience / muscle memory.
#
# Usage:  ./scripts/build-resume-pdf.sh

set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$DIR/build-pdf.sh" index.html Simon-Wardan-Resume.pdf
