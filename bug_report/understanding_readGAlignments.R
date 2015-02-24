library('GenomicRanges')
library('GenomicAlignments')

## Basically http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-6/NA06985_accepted_hits.bam
## You have to create the bam.bai file
bam <- BamFile('geuvadis/tophat/G/NA06985/accepted_hits.bam')

## Info from a given gene (CD83 from hg19)
gr <- GRanges(seqnames = 'chr6', IRanges(start = c(14117865, 14118181, 14131751, 14133880, 14135342, 14117487, 14118181, 14131751, 14133880, 14135339, 14117865, 14118181, 14131751, 14133880, 14135339), end = c(14118079, 14118296, 14131979, 14133986, 14137148, 14117530, 14118296, 14131979, 14133986, 14137148, 14118079, 14118296, 14131979, 14133986, 14137148)), strand = '+')

## Read alignments
aln <- readGAlignments(bam, param = ScanBamParam(which = gr, what = 'qname'))

## Should be getting similar if I used the range, no?
range(gr)
aln_range <- readGAlignments(bam, param = ScanBamParam(which = range(gr), what = 'qname'))

## Or even a bit more if I add some padding for reads that map a long distance away
aln_range_resize <- readGAlignments(bam, param = ScanBamParam(which = resize(range(gr), width = width(range(gr)) + 2e6, fix = 'center'), what = 'qname'))

length(aln)
length(aln_range)
## Padding helps, but why was it not necessary with the individual ranges?
length(aln_range_resize)

## Maximum coverage changes
max(coverage(aln)[['chr6']][start(range(gr)):end(range(gr))])
max(coverage(aln_range)[['chr6']][start(range(gr)):end(range(gr))])
## Max is the same with padding
max(coverage(aln_range_resize)[['chr6']][start(range(gr)):end(range(gr))])

## Mean?
mean(coverage(aln)[['chr6']][start(range(gr)):end(range(gr))])
mean(coverage(aln_range)[['chr6']][start(range(gr)):end(range(gr))])
## So is the mean.. hm..
mean(coverage(aln_range_resize)[['chr6']][start(range(gr)):end(range(gr))])

## QNAME?
max(table(mcols(aln)$qname))
max(table(mcols(aln_range)$qname))
max(table(mcols(aln_range_resize)$qname))

## One range at a time
one <- lapply(gr, function(x) { 
    coverage(readGAlignments(bam, param = ScanBamParam(which = x)))[['chr6']][start(range(gr)):end(range(gr))]
})
## Compare between coverage one at a time versus using which = gr
Reduce('+', one) - coverage(aln)[['chr6']][start(range(gr)):end(range(gr))]

## Aha! Reads are being duplicated!

## It's because some ranges overlap
countOverlaps(gr)

devtools::session_info()
