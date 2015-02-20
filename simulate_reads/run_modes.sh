#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=10G,h_vmem=20G,h_fsize=10G
#$ -N map-run_modes
echo "**** Job starts ****"
date

mkdir -p logs

Rscript run_modes.R

echo "**** Job ends ****"
date

# Move log files
mv map-run_mods.* logs/
