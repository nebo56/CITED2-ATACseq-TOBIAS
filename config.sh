#!/bin/bash
# ------------------------------------------------------------------
# Central configuration for the TOBIAS footprinting pipeline.
#
# Edit the paths below to match your system, then source this file
# from any of the scripts in scripts/ (they do this automatically).
# Nothing else in the pipeline contains a hard-coded path.
# ------------------------------------------------------------------

# Root of this repository / working directory for outputs
PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# Where TOBIAS results are written
RESULTS_DIR="${RESULTS_DIR:-${PROJECT_DIR}/results}"

# --- Reference genome ----------------------------------------------
# GENCODE mouse primary assembly (GRCm38/mm10), uncompressed FASTA.
# Download: https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M25/GRCm38.primary_assembly.genome.fa.gz
GENOME="${GENOME:-${PROJECT_DIR}/genome/GRCm38.primary_assembly.genome.fa}"

# --- Motifs ---------------------------------------------------------
# JASPAR2020 is the version used in the published analysis.
# Set JASPAR_VERSION=2024 to re-run against the current release.
JASPAR_VERSION="${JASPAR_VERSION:-2020}"
JASPAR_MOTIFS="${JASPAR_MOTIFS:-${PROJECT_DIR}/motifs/JASPAR${JASPAR_VERSION}_CORE_vertebrates_non-redundant_pfms_jaspar.txt}"

# --- Peaks ----------------------------------------------------------
# Promoter/TSS-overlapping consensus peaks (see data/README.md).
PEAKS="${PEAKS:-${PROJECT_DIR}/data/promoter_tss_peaks.bed}"

# --- Input BAMs (not distributed; see Data availability in README) ---
# Pooled, deduplicated, mitochondria-free ATAC-seq BAMs per condition.
BAM_CITED2="${BAM_CITED2:-${PROJECT_DIR}/data/combined_bam/C2-combined.bam}"
BAM_GFP="${BAM_GFP:-${PROJECT_DIR}/data/combined_bam/GFP-combined.bam}"

# --- Condition names (order must match --signals order downstream) ---
COND1="Cited2"
COND2="GFP"

# --- Compute --------------------------------------------------------
THREADS="${THREADS:-8}"

# --- Conda environment containing TOBIAS -----------------------------
CONDA_ENV="${CONDA_ENV:-TOBIAS_ENV}"

activate_tobias_env() {
    # Adjust if your conda lives elsewhere (e.g. module load anaconda3)
    if [ -n "${MODULESHOME:-}" ] && command -v module >/dev/null 2>&1; then
        module load miniforge/3 || true
    fi
    eval "$("${HOME}"/miniforge3/bin/conda shell.bash hook)"
    conda activate "${CONDA_ENV}"
}
