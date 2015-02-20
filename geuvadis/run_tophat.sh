#!/bin/bash
## run tophat on the GEUVADIS data 

# file listing run IDs and hapmap IDs (also has populations)
# same as pop_data_withuniqueid.txt, in main folder, but no header and no sample_id column
PDATA=pop_data_annot_subset7.txt

# GTF file (align reads to transcriptome first)
ANNOTATIONPATH=/amber2/scratch/jleek/iGenomes-index
GTF=$ANNOTATIONPATH/Homo_sapiens/UCSC/hg19/Annotation/Genes/genes.gtf

smallGTF=/dcs01/ajaffe/mapBias/select_genes/twenty_genes.gtf
incompleteGTF=/dcs01/ajaffe/mapBias/select_genes/incomplete_genes.gtf

# Bowtie2 index
INDEX=$ANNOTATIONPATH/Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome

# directory where downloaded reads should go
ROOTDIR=/dcs01/ajaffe/mapBias/geuvadis
DATADIR=${ROOTDIR}/fastq

# number of cores to use for tophat
CORES=1

while read sampledata
do
    RUNID=`echo $sampledata | cut -d ' ' -f 1`
    SHORTNAME=`echo $RUNID | cut -c1-6`
    SAMPLE=`echo $sampledata | cut -d ' ' -f 2`
    sname="map-down-${SAMPLE}"
    cat > .${sname}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=20G,h_vmem=20G,h_fsize=100G
#$ -N ${sname}

echo '**** Job starts ****'
date

### download the fastq files:
mkdir -p ${DATADIR}
mkdir -p ${DATADIR}/logs

cd ${DATADIR}
wget --passive-ftp ftp://ftp.sra.ebi.ac.uk/vol1/fastq/$SHORTNAME/$RUNID/${RUNID}_1.fastq.gz
wget --passive-ftp ftp://ftp.sra.ebi.ac.uk/vol1/fastq/$SHORTNAME/$RUNID/${RUNID}_2.fastq.gz

echo '**** Job ends ****'
date

# Move log files into the logs directory
mv ${ROOTDIR}/${sname}.* ${DATADIR}/logs/
EOF
    call="qsub .${sname}.sh"
    echo $call
    #$call
    
    sname2="map-tophat-noG-${SAMPLE}"
    OUTDIR=/dcs01/ajaffe/mapBias/geuvadis/tophat/noG/${SAMPLE}
    mkdir -p ${OUTDIR}
    
    cat > .${sname2}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=5G,h_vmem=10G,h_fsize=100G
#$ -N ${sname2}
#$ -pe local ${CORES}
#$ -hold_jid ${sname}

echo '**** Job starts ****'
date

cd ${OUTDIR}
mkdir -p ${OUTDIR}/logs
module load tophat/2.0.13

### run TopHat 
#tophat -p ${CORES} -o ${OUTDIR} ${INDEX} ${DATADIR}/${RUNID}_1.fastq.gz ${DATADIR}/${RUNID}_2.fastq.gz

## create .bam.bai file
module load samtools/1.1
#samtools index accepted_hits.bam

## run cufflinks for estimating FPKM for 20 genes of interest
module load cufflinks/2.2.1
cufflinks -q -G ${smallGTF} accepted_hits.bam

echo '**** Job ends ****'
date

# Move log files into the logs directory
mv ${ROOTDIR}/${sname2}.* ${OUTDIR}/logs/
EOF
    call="qsub .${sname2}.sh"
    echo $call
    $call
    
    sname3="map-tophat-G-${SAMPLE}"
    OUTDIR=/dcs01/ajaffe/mapBias/geuvadis/tophat/G/${SAMPLE}
    mkdir -p ${OUTDIR}
    
    cat > .${sname3}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=5G,h_vmem=10G,h_fsize=100G
#$ -N ${sname3}
#$ -pe local ${CORES}
#$ -hold_jid ${sname}

echo '**** Job starts ****'
date

cd ${OUTDIR}
mkdir -p ${OUTDIR}/logs
module load tophat/2.0.13

### run TopHat 
#tophat -G $GTF -p ${CORES} -o ${OUTDIR} ${INDEX} ${DATADIR}/${RUNID}_1.fastq.gz ${DATADIR}/${RUNID}_2.fastq.gz

## create .bam.bai file
module load samtools/1.1
#samtools index accepted_hits.bam

## run cufflinks for estimating FPKM for 20 genes of interest
module load cufflinks/2.2.1
cufflinks -q -G ${smallGTF} accepted_hits.bam

echo '**** Job ends ****'
date

# Move log files into the logs directory
mv ${ROOTDIR}/${sname3}.* ${OUTDIR}/logs/
EOF
    call="qsub .${sname3}.sh"
    echo $call
    $call
    
    sname4="map-tophat-GaT-${SAMPLE}"
    OUTDIR=/dcs01/ajaffe/mapBias/geuvadis/tophat/GaT/${SAMPLE}
    mkdir -p ${OUTDIR}
    
    cat > .${sname4}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=5G,h_vmem=10G,h_fsize=100G
#$ -N ${sname4}
#$ -pe local ${CORES}
#$ -hold_jid ${sname}

echo '**** Job starts ****'
date

cd ${OUTDIR}
mkdir -p ${OUTDIR}/logs
module load tophat/2.0.13

### run TopHat 
#tophat -G $GTF -T -p ${CORES} -o ${OUTDIR} ${INDEX} ${DATADIR}/${RUNID}_1.fastq.gz ${DATADIR}/${RUNID}_2.fastq.gz

## create .bam.bai file
module load samtools/1.1
#samtools index accepted_hits.bam

## run cufflinks for estimating FPKM for 20 genes of interest
module load cufflinks/2.2.1
cufflinks -q -G ${smallGTF} accepted_hits.bam

echo '**** Job ends ****'
date

# Move log files into the logs directory
mv ${ROOTDIR}/${sname4}.* ${OUTDIR}/logs/
EOF
    call="qsub .${sname4}.sh"
    echo $call
    $call
    
    sname5="map-tophat-incG-${SAMPLE}"
    OUTDIR=/dcs01/ajaffe/mapBias/geuvadis/tophat/incG/${SAMPLE}
    mkdir -p ${OUTDIR}
    
    cat > .${sname5}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=5G,h_vmem=10G,h_fsize=100G
#$ -N ${sname5}
#$ -pe local ${CORES}
#$ -hold_jid ${sname}

echo '**** Job starts ****'
date

cd ${OUTDIR}
mkdir -p ${OUTDIR}/logs
module load tophat/2.0.13

### run TopHat 
#tophat -G ${incompleteGTF} -p ${CORES} -o ${OUTDIR} ${INDEX} ${DATADIR}/${RUNID}_1.fastq.gz ${DATADIR}/${RUNID}_2.fastq.gz

## create .bam.bai file
module load samtools/1.1
#samtools index accepted_hits.bam

## run cufflinks for estimating FPKM for 20 genes of interest
module load cufflinks/2.2.1
cufflinks -q -G ${smallGTF} accepted_hits.bam

echo '**** Job ends ****'
date

# Move log files into the logs directory
mv ${ROOTDIR}/${sname5}.* ${OUTDIR}/logs/
EOF
    call="qsub .${sname5}.sh"
    echo $call
    $call
done < $PDATA

