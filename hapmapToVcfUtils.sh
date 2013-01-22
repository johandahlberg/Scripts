#!/bin/bash -l

#*********************************************
# Script for converting hapmap genotype files to vcf and lifting them over
# to a new reference genome.
# It also makes one hapmap individual per vcf fles, for the individuals specified.
#*********************************************

INPUT_GENOTYPES=$1

SAMPLES_TO_SELECT="NA11992 NA10860"

OUTPUT_VCF=${INPUT_GENOTYPES%.txt}".b36.vcf"
LIFT_OVER_VCF=${OUTPUT_VCF%.b36.vcf}".b37.vcf"

echo "INPUT_GENOTYPES="$INPUT_GENOTYPES
echo "OUTPUT_VCF="$OUTPUT_VCF
echo "LIFT_OVER_VCF="$LIFT_OVER_VCF

NEW_REFERENCE="human_g1k_v37.concat"
OLD_REFERENCE="human_b36_both"
CHAIN_FILE="b36tob37.chain"
GATK_LOCATION="../SnpSeqPipeline/gatk/"
GATK_JAR=${GATK_LOCATION}"dist/GenomeAnalysisTK.jar"

#-----------------------------------------------------------------
# Convert to vcf
#-----------------------------------------------------------------
java -Xmx2g -jar ${GATK_JAR} \
   -T VariantsToVCF \
   -R human_b36_both.fasta \
   -o ${OUTPUT_VCF} \
   --variant:RawHapMap ${INPUT_GENOTYPES}

#-----------------------------------------------------------------
# Lift over
#-----------------------------------------------------------------

mkdir tmp

${GATK_LOCATION}/public/perl/liftOverVCF.pl -vcf ${OUTPUT_VCF} \
  -chain b36tob37.chain \
  -out ${LIFT_OVER_VCF} \
  -gatk ${GATK_LOCATION} \
  -newRef ${NEW_REFERENCE} \
  -oldRef ${OLD_REFERENCE} \
  -tmp ./tmp

rm -r ./tmp

#-----------------------------------------------------------------
# Select only one sample from the vcf
#-----------------------------------------------------------------

for SAMPLE in ${SAMPLES_TO_SELECT}
do
	java -jar ${GATK_JAR} -T SelectVariants \
		-V ${LIFT_OVER_VCF} \
		--sample_name ${SAMPLE} \
		-R ${NEW_REFERENCE}.fasta > ${LIFT_OVER_VCF}.${SAMPLE}
done

