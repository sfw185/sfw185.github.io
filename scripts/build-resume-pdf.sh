#!/usr/bin/env bash
#
# Generate Simon-Wardan-Resume.pdf from index.html using headless Chrome.
#
# Chrome renders with the same engine as the browser and honors the
# `@media print` / `@page` CSS in index.html, so the PDF matches the site.
# (Poppler/wkhtmltopdf can't render this page's CSS grid + custom properties.)
#
# Usage:  ./scripts/build-resume-pdf.sh
# Override the browser with:  CHROME="/path/to/chrome" ./scripts/build-resume-pdf.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IN="$ROOT/index.html"
OUT="$ROOT/Simon-Wardan-Resume.pdf"

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
