#!/bin/bash
# ------------------------------------------------------------------
# Steps 2-3 - Tn5 bias correction and footprint scoring, per condition.
#
#   ATACorrect  : estimates and removes the Tn5 insertion sequence bias,
#                 producing _corrected.bw (plus _uncorrected.bw and
#                 _expected.bw for QC).
#   ScoreBigwig : converts the corrected cut-site signal into a
#                 continuous footprint score used by BINDetect.
#
# >>> PROVENANCE NOTE <<<
# The original scripts for these two steps were not recovered from the
# project directory. The commands below are RECONSTRUCTED from the
# inputs that BINDetect (step 4) consumes:
#     results_combined_Cited2/C2-combined_footprints.bw
#     results_combined_GFP/GFP-combined_footprints.bw
# They use TOBIAS defaults. If you need to reproduce the published
# bigWigs exactly, check the original run logs for any non-default
# flags (e.g. --extend, --window, --score) before relying on this.
#
# Usage:
#   ./02_footprint_signals.sh
# (paths and thread count come from ../config.sh)
# ------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config.sh"
activate_tobias_env

run_condition () {
    local label="$1"      # short prefix used in output filenames
    local bam="$2"
    local outdir="${RESULTS_DIR}/results_combined_${label}"

    mkdir -p "${outdir}"

    # --- Tn5 bias correction ---------------------------------------
    # --peaks must be the SAME consensus set used for BINDetect.
    TOBIAS ATACorrect \
        --bam "${bam}" \
        --genome "${GENOME}" \
        --peaks "${PEAKS}" \
        --outdir "${outdir}" \
        --prefix "${label}-combined" \
        --cores "${THREADS}"

    # --- Footprint scoring ------------------------------------------
    TOBIAS ScoreBigwig \
        --signal "${outdir}/${label}-combined_corrected.bw" \
        --regions "${PEAKS}" \
        --output "${outdir}/${label}-combined_footprints.bw" \
        --cores "${THREADS}"
}

run_condition "C2"  "${BAM_CITED2}"
run_condition "GFP" "${BAM_GFP}"

echo "Footprint bigWigs written under ${RESULTS_DIR}/"
