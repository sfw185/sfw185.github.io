#!/usr/bin/env bash
#
# Render an HTML file to a PDF using headless Chrome.
#
# Chrome renders with the same engine as the browser and honors the page's
# `@media print` / `@page` CSS, so the PDF matches what you see in a browser.
# (Poppler/wkhtmltopdf can't render this project's CSS grid + custom properties.)
#
# Usage:  ./scripts/build-pdf.sh <input.html> <output.pdf>
#   e.g.  ./scripts/build-pdf.sh index.html Simon-Wardan-Resume.pdf
#         ./scripts/build-pdf.sh cover-letters/skip.html Simon-Wardan-CoverLetter-Skip.pdf
#
# Paths are resolved relative to the repo root. Override the browser with:
#   CHROME="/path/to/chrome" ./scripts/build-pdf.sh ...

set -euo pipefail

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <input.html> <output.pdf>" >&2
	exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Resolve input/output relative to repo root unless already absolute.
case "$1" in /*) IN="$1" ;; *) IN="$ROOT/$1" ;; esac
case "$2" in /*) OUT="$2" ;; *) OUT="$ROOT/$2" ;; esac

if [ ! -f "$IN" ]; then
	echo "Error: input file not found: $IN" >&2
	exit 1
fi

# Locate a Chrome/Chromium/Edge binary unless CHROME is already set.
if [ -z "${CHROME:-}" ]; then
	for candidate in \
		"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
		"/Applications/Chromium.app/Contents/MacOS/Chromium" \
		"/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
		"$(command -v google-chrome 2>/dev/null || true)" \
		"$(command -v google-chrome-stable 2>/dev/null || true)" \
		"$(command -v chromium 2>/dev/null || true)" \
		"$(command -v chromium-browser 2>/dev/null || true)"; do
		if [ -n "$candidate" ] && [ -x "$candidate" ]; then
			CHROME="$candidate"
			break
		fi
	done
fi

if [ -z "${CHROME:-}" ]; then
	echo "Error: no Chrome/Chromium found. Install Google Chrome or set CHROME=/path/to/chrome." >&2
	exit 1
fi

"$CHROME" \
	--headless \
	--disable-gpu \
	--no-pdf-header-footer \
	--print-to-pdf="$OUT" \
	"file://$IN" 2>/dev/null

echo "Generated: $OUT"
