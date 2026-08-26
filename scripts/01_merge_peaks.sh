#!/bin/bash
# ------------------------------------------------------------------
# Step 1 - Build the consensus peak set for footprinting.
#
# TOBIAS requires a single set of regions representing open chromatin
# ACROSS ALL CONDITIONS, and the same regions must be used for both
# the signal correction (step 2/3) and BINDetect (step 4). Using
# condition-specific peaks would bias the differential comparison.
#
# Input:  per-replicate/per-condition narrowPeak files from the ATAC-seq
#         peak caller (ENCODE pipeline output: pooled, p<0.01,
#         top 300K, blacklist-filtered).
# Output: sorted, non-overlapping consensus peak BED (BED3).
#
# NOTE: the published analysis restricted BINDetect to promoter/TSS-
# overlapping peaks. That subsetting step is documented in
# data/README.md; the resulting file is provided as
# data/promoter_tss_peaks.bed.
#
# Usage:
#   ./01_merge_peaks.sh <dir_with_narrowPeak_files> <output.bed>
# ------------------------------------------------------------------
set -euo pipefail

PEAK_DIR="${1:?Usage: $0 <dir_with_narrowPeak_files> <output.bed>}"
OUT_BED="${2:?Usage: $0 <dir_with_narrowPeak_files> <output.bed>}"

TMP_SORTED="${OUT_BED%.bed}.pooled_sorted.bed"

# Pool all narrowPeaks and sort by coordinate (required by bedtools merge)
cat "${PEAK_DIR}"/*narrowPeak | sort -k1,1 -k2,2n > "${TMP_SORTED}"

# Collapse overlapping peaks into a single consensus interval set
bedtools merge -i "${TMP_SORTED}" > "${OUT_BED}"

echo "Consensus peaks: $(wc -l < "${OUT_BED}") regions -> ${OUT_BED}"
