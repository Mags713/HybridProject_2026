#!/bin/bash --login
#SBATCH --job-name=Filter4Pi
#SBATCH --nodes=3
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --output=PiFilter_%j.out
#SBATCH --error=PiFilter_%j.err

#Modified from Script from Maya Wilson-Brown, Michigan State University
#Final Author: Magie Williams
#Most Recent Author Edit: September 10th, 2026
#Purpose: Merge vcf files from BWA into one that is not genotyped, and filter out missing sites

# purge modules
module purge
# load modules
#check version
module load BCFtools/1.18-GCC-12.3.0
#finding VCF files and merging and indexing
bcftools concat -Oz -o cohort_full.vcf.gz BWA_Out_*.vcf.gz
bcftools index cohort_full.vcf.gz
#confirmng invariants are present - this is checking that the merge and BWA did everything correctly
bcftools query -l cohort_full.vcf.gz | wc -l         # samples
bcftools view -H cohort_full.vcf.gz | head           # confirm invariant blocks present
#remove low depth reads
bcftools filter -e 'FMT/DP < 3' --set-GTs . cohort_full.vcf.gz \
-Oz -o cohort_dp_filtered.vcf.gz
bcftools index cohort_dp_filtered.vcf.gz
#filtering out missing sites or with 10% missing genotypes
bcftools view -i 'F_MISSING < 0.1' cohort_dp_filtered.vcf.gz \
-Oz -o cohort_missing_filtered.vcf.gz
bcftools index cohort_missing_filtered.vcf.gz
#making final VCF to be used with Pixy
bcftools view -M2 cohort_missing_filtered.vcf.gz \
-Oz -o cohort_biallelic.vcf.gz
bcftools index cohort_biallelic.vcf.gz

#BCFtools Citation
#Twelve years of SAMtools and BCFtools
#Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li
#GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008
