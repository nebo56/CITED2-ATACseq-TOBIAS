#!/bin/bash
#PBS -l select=1:ncpus=8:mem=12gb
#PBS -l walltime=18:0:0
# ------------------------------------------------------------------
# Step 4 - Differential TF binding at promoter/TSS peaks (BINDetect).
#
# This is the analysis reported in the paper: TOBIAS BINDetect compares
# the Cited2 and GFP footprint signals across JASPAR motif occurrences
# within promoter/TSS-overlapping consensus peaks, and returns, per TF,
# a differential binding score and its significance, plus bound/unbound
# site BEDs per condition.
#
# Motif database: JASPAR 2020 CORE vertebrates, non-redundant.
#   Pinned deliberately - the rest of the paper's motif analyses use
#   JASPAR 2020, and motif IDs/versions are not stable across releases
#   (e.g. ZBTB7C is MA0695.1 in 2020 and MA0695.2 in 2024). Set
#   JASPAR_VERSION=2024 in config.sh to re-run against the current
#   release; results will not be numerically identical to the paper.
#
# The --peak_header option is deliberately NOT used: the peak file is
# plain BED3, so BINDetect falls back to chrom/start/end column names.
# If you supply peaks with extra annotation columns, add a header file
# (one column name per line) via --peak_header.
#
# Requires: results from 02_footprint_signals.sh
#
# Usage:
#   ./03_bindetect_promoter.sh            # interactive / local
#   qsub  scripts/03_bindetect_promoter.sh  # PBS cluster (Imperial RCS)
#
# The PBS directives above request 8 cores / 12 GB / 18 h, which was
# sufficient for ~1,400 promoter peaks x 746 motifs. Scale walltime up
# if you run against the full (non-promoter-restricted) peak set.
# ------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config.sh"
activate_tobias_env

OUTDIR="${RESULTS_DIR}/BINDetect_promoter_jaspar${JASPAR_VERSION}"
mkdir -p "${OUTDIR}"

# --signals and --cond_names must be given in the SAME order.
TOBIAS BINDetect \
    --motifs   "${JASPAR_MOTIFS}" \
    --signals  "${RESULTS_DIR}/results_combined_${COND1}/C2-combined_footprints.bw" \
               "${RESULTS_DIR}/results_combined_${COND2}/GFP-combined_footprints.bw" \
    --genome   "${GENOME}" \
    --peaks    "${PEAKS}" \
    --outdir   "${OUTDIR}" \
    --cond_names "${COND1}" "${COND2}" \
    --cores    "${THREADS}"

echo "BINDetect output: ${OUTDIR}"
echo "  bindetect_results.txt  - per-TF differential binding scores"
echo "  bindetect_results.xlsx - same, spreadsheet form"
echo "  <TF>/beds/             - bound/unbound sites per condition"
