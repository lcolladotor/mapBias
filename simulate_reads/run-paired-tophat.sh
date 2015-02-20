#!/bin/sh

# Directories
MAINDIR=/dcs01/ajaffe/mapBias/simulate_reads

# Define variables
CORES=4

# GTF file (align reads to transcriptome first)
ANNOTATIONPATH=/amber2/scratch/jleek/iGenomes-index
GTF=$ANNOTATIONPATH/Homo_sapiens/UCSC/hg19/Annotation/Genes/genes.gtf


smallGTF=/dcs01/ajaffe/mapBias/select_genes/twenty_genes.gtf
incompleteGTF=/dcs01/ajaffe/mapBias/select_genes/incomplete_genes.gtf

# Bowtie2 index
INDEX=$ANNOTATIONPATH/Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome


#for THmode in G GaT noG incG
for THmode in G GaT incG
do
    for sampledir in default_1 default_2 rnaf_1 rnaf_2
    do
        DATADIR=${MAINDIR}/${THmode}/${sampledir}
        WDIR=${MAINDIR}/tophat/${THmode}/${sampledir}
        mkdir -p ${WDIR}

        if [[ "${THmode}" == "G" ]]
        then
            tophatopt="-G ${GTF}"
        elif [[ "${THmode}" == "GaT" ]]
        then
            tophatopt="-G ${GTF} -T"
        elif [[ "${THmode}" == "noG" ]]
        then
            tophatopt=""
        elif [[ "${THmode}" == "incG" ]]
        then
            tophatopt="-G ${incompleteGTF}"
        else
            echo "Incorrect option"
        fi
        

        # Change to data dir
        cd ${DATADIR}

        # Construct shell files
        cat paired.txt | while read x
        	do
        	cd ${WDIR}
        	libname=$(echo "$x" | cut -f3)
        	# Setting paired file names
        	file1=$(echo "$x" | cut -f1)
        	file2=$(echo "$x" | cut -f2)
        	# Actually create the script
        	echo "Creating script for ${libname}"
            sname="map-th-${THmode}-${sampledir}-${libname}"
        	cat > ${WDIR}/.${sname}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=5G,h_vmem=10G,h_fsize=10G
#$ -pe local ${CORES}
#$ -N ${sname}
echo "**** Job starts ****"
date


module load tophat/2.0.13
# run tophat
tophat ${tophatopt} -p ${CORES} -o ${libname} ${INDEX} ${DATADIR}/${file1} ${DATADIR}/${file2}

cd ${WDIR}/${libname}

## create .bam.bai file
module load samtools/1.1
samtools index accepted_hits.bam

## run cufflinks for estimating FPKM for 20 genes of interest
module load cufflinks/2.2.1
cufflinks -q -G ${smallGTF} accepted_hits.bam

echo "**** Job ends ****"
date

# move log files
mkdir -p ${WDIR}/${libname}/logs/
mv ${WDIR}/${sname}.* ${WDIR}/${libname}/logs/
EOF
        	call="qsub ${WDIR}/.${sname}.sh"
        	echo $call
        	$call
        done
    done
done