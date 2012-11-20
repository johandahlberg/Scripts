#!/bin/bash -l
#SBATCH -A a2009002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 148:00:00
#SBATCH -J AddReadGroups
#SBATCH -o AddReadGroups-%j.out
#SBATCH -e AddReadGroups-%j.error

INPUT=$1
OUTPUT=${INPUT%.bam}.with.rg.bam
LIBRARY="UNKNOWN"
PLATFORM="Illumina"
PLATFORM_UNIT="UNKOWN"
FILE_NAME=$(basename ${INPUT})
SAMPLE_NAME=${FILE_NAME%".bam"}
SEQUENCEING_CENTER="SNPSEQ Platform"

echo "INPUT: " ${INPUT}
echo "FILE NAME: " ${FILE_NAME}
echo "SAMPLE NAME: " ${SAMPLE_NAME}

#VALIDATION_STRINGENCY=LENIENT is required if reads were aligned with bwa, otherwise it will fail.
java -Xmx3g -jar /bubo/sw/apps/bioinfo/picard/1.69/kalkyl/AddOrReplaceReadGroups.jar VALIDATION_STRINGENCY=LENIENT INPUT=${INPUT} OUTPUT=${OUTPUT} RGLB=${LIBRARY} RGPL=${PLATFORM} RGPU=${PLATFORM_UNIT} RGSM=${SAMPLE_NAME} RGCN=${SEQUENCEING_CENTER} 

