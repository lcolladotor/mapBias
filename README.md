README
======

This repository has code for reproducing a part of [polyester_code](https://github.com/alyssafrazee/polyester_code). In particular figures in section 3.1.

The goal was to reproduce these figures, try another seed, and try to determine a measure that we can calculate by gene to see if there is information. Particularly, if there is more information than what we would expect by chance.

Folders [NA06985](/NA06985), [NA12144](/NA12144), [NA12776](/NA12776), [NA18858](/NA18858), [NA20542](/NA20542), [NA20772](/NA20772), and [NA20815](/NA20815) are taking as available from [polyester_code](https://github.com/alyssafrazee/polyester_code). Their output is reproduced (described below) for 20 genes instead of 10. The same is true for [countmat.rda](/countmat.rda). [sequences.rda](/sequences.rda) was not used.

# Step 1: select genes

[select_genes](/select_genes) has the files for selecting the 20 genes to use. It selects the 10 that were used in [polyester_code](https://github.com/alyssafrazee/polyester_code) and another 10 genes with FPKM > 20 in the Geuvadis data. See [select_genes.Rmd](/select_genes/select_genes.Rmd) for the details.

# Step 2: re-align Geuvadis

[geuvadis](/geuvadis) has the files for re-aligning the selected 7 samples from Geuvadis. [subset_pop.Rmd](/geuvadis/subset_pop.Rmd) subsets the info to just hte 7 samples. Then [run_tophat.sh](/geuvadis/run_tophat.sh) is used for aligning the data in 4 different TopHat modes:

* G: using –G with the full annotation of hg19
* noG: without using –G
* GaT: using –G with the full annotation of hg19 and also using –T (so it doesn’t look beyond the known transcripts)
* incG: using –G with an incomplete annotation of hg19. It’s the full annotation minus the information for the 20 genes selected.

# Step 3: Simulate reads

[simulate_reads](/simulate_reads) has the files for simulating the reads with `polyester`. See [simulate_reads.Rmd](/simulate_reads/simulate_reads.Rmd) for the details. Once the reads are simulated, they are aligned using [run-paired-tophat.sh](/simulate_reads/run-paired-tophat.sh).

[compare_countmats.Rmd](/simulate_reads/compare_countmats.Rmd) compares the count matrices from the 4 TopHat modes.

# Step 4: Make coverage plots

[coverage_plots](/coverage_plots) has the files for making the coverage plots using `derfinderPlot`. [coverage_plots.Rmd](/coverage_plots/coverage_plots.Rmd) creates plots by gene (20), gene by sample (20 * 7), by exon (250), by exon by sample (250 * 7), and some other plots. The HTML files are not version controlled because they are about 350 MB in size.

To reproduce the actual figure instead of using `derfinderPlot`, see [reproduce_fig.Rmd](/coverage_plots/reproduce_fig.Rmd).

# Step 5: explore measures

This step explores some measures such as correlation, $R^2$, root mean square distance (first by scaling by the maximum), fitting ARIMA models, and comparing against chance. See [predict_coverage.Rmd](/coverage_plots/predict_coverage.Rmd).


