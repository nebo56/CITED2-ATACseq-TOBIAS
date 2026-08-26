#!/bin/bash
# ------------------------------------------------------------------
# Download the JASPAR CORE vertebrates non-redundant PFM file used by
# BINDetect, and verify it against the checksum of the file used in
# the published analysis.
#
# JASPAR keeps previous releases available, so the 2020 collection can
# still be retrieved even though 2024 is current. The motif files are
# not committed to this repository; download them here.
#
# Usage:
#   ./get_jaspar_motifs.sh [2020|2024]     (default: 2020)
# ------------------------------------------------------------------
set -euo pipefail

VERSION="${1:-2020}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOTIF_DIR="${SCRIPT_DIR}/../motifs"
mkdir -p "${MOTIF_DIR}"

case "${VERSION}" in
    2020) URL="https://jaspar2020.genereg.net/download/CORE/JASPAR2020_CORE_vertebrates_non-redundant_pfms_jaspar.txt" ;;
    2024) URL="https://jaspar.elixir.no/download/data/2024/CORE/JASPAR2024_CORE_vertebrates_non-redundant_pfms_jaspar.txt" ;;
    *)    echo "Unknown JASPAR version: ${VERSION} (use 2020 or 2024)"; exit 1 ;;
esac

OUT="${MOTIF_DIR}/JASPAR${VERSION}_CORE_vertebrates_non-redundant_pfms_jaspar.txt"

echo "Downloading JASPAR ${VERSION} CORE vertebrates (non-redundant)..."
echo "  ${URL}"
curl -fL -o "${OUT}" "${URL}" || {
    echo
    echo "Download failed. JASPAR download URLs change between releases."
    echo "Fetch the file manually from https://jaspar.elixir.no/downloads/"
    echo "(CORE collection > Vertebrates > non-redundant > JASPAR format)"
    echo "and save it as:"
    echo "  ${OUT}"
    exit 1
}

echo "Motifs downloaded: $(grep -c '^>' "${OUT}") PFMs"
echo
echo "Expected checksums for the files used in the published analysis:"
cat "${MOTIF_DIR}/jaspar_md5sums.txt"
echo
echo "Your file:"
md5sum "${OUT}"
