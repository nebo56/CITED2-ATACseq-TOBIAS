# CITED2-ATACseq-TOBIAS

**Differential transcription factor footprinting of Cited2 vs GFP
ATAC-seq at promoter/TSS regions, using
[TOBIAS](https://github.com/loosolab/TOBIAS) and JASPAR 2020 motifs.**

This repository contains the footprinting pipeline used in:

> Müller F, McLachlan E, Costa AC, Qu J, et al. **CITED2 is a druggable
> epigenetic switch coupling neuronal maturation to regenerative
> decline.** *EMBO Molecular Medicine* (2026).
> doi:[10.1038/s44321-026-00385-w](https://doi.org/10.1038/s44321-026-00385-w)

The scope is deliberately narrow: everything needed to reproduce the
promoter-restricted BINDetect run, and nothing else. ATAC-seq read
processing and peak calling are upstream of this repository; see the
paper's Methods.

## Pipeline

```
per-condition narrowPeak files
   │  01_merge_peaks.sh                  → consensus peaks (bedtools merge)
   │  + promoter/TSS intersection         (see data/README.md)
   ▼
data/promoter_tss_peaks.bed  ────────────────────┐
                                                 │
pooled ATAC-seq BAMs (Cited2, GFP)               │
   │  02_footprint_signals.sh                    │
   │    TOBIAS ATACorrect   → *_corrected.bw     │
   │    TOBIAS ScoreBigwig  → *_footprints.bw    │
   ▼                                             │
footprint bigWigs ───────────────────────────────┤
                                                 │
JASPAR 2020 CORE vertebrates PFMs ───────────────┤
   (scripts/get_jaspar_motifs.sh)                │
                                                 ▼
                                    03_bindetect_promoter.sh
                                       TOBIAS BINDetect
                                                 │
                                                 ▼
                              per-TF differential binding scores
                              + bound/unbound site BEDs per condition
```

The same consensus peak set is used for bias correction and for
BINDetect — TOBIAS requires this, since the signals being compared must
be defined over identical regions.

## Quick start

```bash
git clone https://github.com/<user>/CITED2-ATACseq-TOBIAS.git
cd CITED2-ATACseq-TOBIAS

# 1. edit paths (genome, BAMs, conda env) for your system
$EDITOR config.sh

# 2. fetch the motif database used in the paper
./scripts/get_jaspar_motifs.sh 2020

# 3. bias correction + footprint scoring (needs the BAMs)
./scripts/02_footprint_signals.sh

# 4. differential binding at promoter peaks
./scripts/03_bindetect_promoter.sh
#   or, on a PBS cluster:  qsub scripts/03_bindetect_promoter.sh
```

All paths live in `config.sh`; no script contains a hard-coded path.
Every variable can also be overridden from the environment, e.g.
`THREADS=16 GENOME=/data/mm10.fa ./scripts/03_bindetect_promoter.sh`.

## Requirements

- [TOBIAS](https://github.com/loosolab/TOBIAS) ≥ 0.14 (conda:
  `conda create -n TOBIAS_ENV -c bioconda tobias`)
- [bedtools](https://bedtools.readthedocs.io) (step 1 only)
- GRCm38/mm10 primary assembly FASTA (GENCODE)
- ~12 GB RAM, 8 cores; the published BINDetect run took under 18 h

## Reproducibility notes

**Motif database is pinned to JASPAR 2020.** The rest of the paper's
motif analyses use JASPAR 2020, and JASPAR motif IDs are versioned and
change between releases (ZBTB7C: MA0695.1 → MA0695.2; POU2F3: MA0627.2
→ MA0627.3), so mixing releases would make results non-comparable.
A 2024 re-run is supported via `JASPAR_VERSION=2024` and writes to a
separate output directory. See `motifs/README.md`.

**`--peak_header` is not used.** The peak file is plain BED3, so
BINDetect uses default chrom/start/end column names. Supplying annotated
peaks would require a matching header file.

**Condition order matters.** `--signals` and `--cond_names` are given in
the same order (Cited2 first, GFP second); the sign of the differential
binding score follows from this.

**Reconstructed step.** The original ATACorrect/ScoreBigwig scripts were
not recovered from the project directory. `02_footprint_signals.sh` is
reconstructed from the bigWig filenames that BINDetect consumes and uses
TOBIAS defaults — see the note at the top of that script.

## Data availability

Sequencing data accessions are given in the Data availability statement
of the paper. The only data file distributed here is the promoter/TSS
consensus peak set (`data/promoter_tss_peaks.bed`, 1,370 regions); BAMs,
bigWigs, the genome FASTA and the JASPAR PFMs are not committed. See
`data/README.md`.

## Citation

If you use this pipeline, please cite the paper above, plus TOBIAS and
JASPAR:

> Bentsen M, Goymann P, Schultheis H, et al. **ATAC-seq footprinting
> unravels kinetics of transcription factor binding during zygotic
> genome activation.** *Nature Communications* 11:4267 (2020).
> doi:10.1038/s41467-020-18035-1

> Fornes O, Castro-Mondragon JA, Khan A, et al. **JASPAR 2020: update of
> the open-access database of transcription factor binding profiles.**
> *Nucleic Acids Research* 48(D1):D87–D92 (2020).
> doi:10.1093/nar/gkz1001

## Author

Nejc Haberman, Department of Brain Sciences, Imperial College London.
