#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=25G,h_vmem=50G,h_fsize=10G
#$ -N map-run_modes-sim
echo "**** Job starts ****"
date

mkdir -p logs

Rscript run_modes.R

echo "**** Job ends ****"
date

# Move log files
mv map-run_modes.* logs/
