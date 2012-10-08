#!/bin/bash -l
#SBATCH -A a2009002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 120:00:00
#SBATCH -J CoverageCalculator
#SBATCH -o calcCov-%j.out
#SBATCH -e calcCov-%j.error

java -jar gatk/dist/GenomeAnalysisTK.jar -T DepthOfCoverage -R [reference] -I [input] -o [output].coverage
