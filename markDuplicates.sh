#!/bin/bash -l
#SBATCH -A a2009002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 120:00:00
#SBATCH -J MarkDuplicates
#SBATCH -o markDuplicates-%j.out
#SBATCH -e markDuplicates-%j.error

INPUT=$1
OUTPUT=${INPUT%.bam}.markDup.bam

#VALIDATION_STRINGENCY=LENIENT is required if reads were aligned with bwa, otherwise it will fail.
java -Xmx3g -jar /bubo/sw/apps/bioinfo/picard/1.69/kalkyl/MarkDuplicates.jar VALIDATION_STRINGENCY=LENIENT INPUT=${INPUT} OUTPUT=${OUTPUT} METRICS_FILE=${OUTPUT}.markDuplicateStats
