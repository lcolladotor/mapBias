#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=10G,h_vmem=30G,h_fsize=20G
#$ -N map-run_modes-pred
#$ -hold_jid map-run_modes-covPlots
echo "**** Job starts ****"
date

mkdir -p logs

Rscript run_modes-pred.R

echo "**** Job ends ****"
date

# Move log files
mv map-run_modes-pred.* logs/
