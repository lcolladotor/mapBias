#!/bin/sh
set -e
module load cufflinks
cufflinks -q -G ../ten_genes.gtf -o ./ NA12144_accepted_hits.bam
