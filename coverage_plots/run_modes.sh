#!/bin/bash
#$ -cwd
#$ -m e
#$ -pe local 7
#$ -l mem_free=10G,h_vmem=30G,h_fsize=20G
#$ -N map-run_modes-covPlots
echo "**** Job starts ****"
date

mkdir -p logs

Rscript run_modes.R

echo "**** Job ends ****"
date

# Move log files
mv map-run_modes.* logs/
