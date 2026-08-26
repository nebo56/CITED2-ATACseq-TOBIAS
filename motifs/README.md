# Motifs

Motif files are **not committed** — download them with
`scripts/get_jaspar_motifs.sh [2020|2024]`.

`jaspar_md5sums.txt` holds MD5 checksums of the exact files used in the
published analysis, so a fresh download can be verified.

## Why JASPAR 2020

The published analysis is pinned to **JASPAR 2020 CORE vertebrates
(non-redundant, 746 PFMs)** for consistency with the other motif
analyses in the paper. Motif IDs are versioned and change between
JASPAR releases, so results are not directly comparable across
versions. Concrete examples from these two files:

| TF | JASPAR 2020 | JASPAR 2024 |
|----|-------------|-------------|
| ZBTB7C | MA0695.1 | MA0695.2 |
| POU2F3 | MA0627.2 | MA0627.3 |

JASPAR 2024 CORE vertebrates non-redundant contains 879 PFMs — 133 more
than 2020 — so a 2024 re-run also tests a different number of motifs,
which changes the multiple-testing correction as well as the individual
motif models.

To re-run against the current release:

```bash
./scripts/get_jaspar_motifs.sh 2024
JASPAR_VERSION=2024 ./scripts/03_bindetect_promoter.sh
```

Output goes to a separate `BINDetect_promoter_jaspar2024/` directory, so
the two runs can coexist.
