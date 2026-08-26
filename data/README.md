# Data

## `promoter_tss_peaks.bed`

Consensus ATAC-seq peaks restricted to promoter / TSS regions — the
`--peaks` argument to BINDetect (step 3). Committed here because it is
small (1,370 regions, 561 kb of genome, mean width 410 bp) and is the
only region set needed to reproduce the published BINDetect run.

Original filename in the project directory:
`combined_Cited2_and_GFP-merged_peks_pooled.pval0.01.300K.bfilt.narrowPeak.bedtools_merge-promoter_tss.bed`

Format: BED3 (chrom, start, end), coordinate-sorted, non-overlapping.
Assembly: GRCm38/mm10, UCSC-style chromosome names (`chr1` … `chrX`).

How it was made:

1. Peak calling on the ATAC-seq libraries produced pooled narrowPeak
   files (p < 0.01, top 300K peaks, blacklist-filtered).
2. All narrowPeaks from both conditions were pooled, coordinate-sorted
   and collapsed with `bedtools merge` — see `scripts/01_merge_peaks.sh`.
3. The merged consensus set was intersected with promoter/TSS regions.

> **Provenance gap:** step 3 was carried out separately by a collaborator
> and the exact promoter definition (TSS flank size, annotation source
> and release) was not recorded in the project directory. Anyone
> reproducing this from raw data should record their own promoter
> definition. The file itself is exactly the one used for the published
> analysis, so BINDetect results are reproducible from this repository
> as-is.

## Files not distributed here

Raw and intermediate ATAC-seq data are not in this repository because of
size. See the Data availability statement of the paper for accession
numbers.

| File | Produced by | Needed for |
|------|-------------|-----------|
| Pooled, deduplicated, chrM-free BAMs per condition | ATAC-seq preprocessing | step 2 |
| `*_corrected.bw`, `*_uncorrected.bw`, `*_expected.bw` | `TOBIAS ATACorrect` | step 2 QC |
| `C2-combined_footprints.bw`, `GFP-combined_footprints.bw` | `TOBIAS ScoreBigwig` | step 3 |
| `GRCm38.primary_assembly.genome.fa` | GENCODE (release M25) | steps 2–3 |
| JASPAR PFM file | `scripts/get_jaspar_motifs.sh` | step 3 |
