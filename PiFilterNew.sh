#!/bin/bash --login
#SBATCH --job-name=Filter4Pi
#SBATCH --nodes=3
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --output=PiFilter_%j.out
#SBATCH --error=PiFilter_%j.err

# purge modules
module purge
# load modules
module load BCFtools/1.18-GCC-12.3.0

bcftools concat -Oz -o cohort_full.vcf.gz BWA_Out_*.vcf.gz
bcftools index cohort_full.vcf.gz

bcftools query -l cohort_full.vcf.gz | wc -l         # samples
bcftools view -H cohort_full.vcf.gz | head           # confirm invariant blocks present

bcftools filter -e 'FMT/DP < 3' --set-GTs . cohort_full.vcf.gz \
-Oz -o cohort_dp_filtered.vcf.gz
bcftools index cohort_dp_filtered.vcf.gz

bcftools view -i 'F_MISSING < 0.1' cohort_dp_filtered.vcf.gz \
-Oz -o cohort_missing_filtered.vcf.gz
bcftools index cohort_missing_filtered.vcf.gz

bcftools view -M2 cohort_missing_filtered.vcf.gz \
-Oz -o cohort_biallelic.vcf.gz
bcftools index cohort_biallelic.vcf.gz