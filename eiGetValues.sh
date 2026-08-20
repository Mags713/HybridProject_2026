#!/bin/bash --login
#SBATCH --job-name=eiGetValues
#SBATCH --output=IgetValues_%j.out
#SBATCH --error=IgetValues_%j.err
#SBATCH --time=02:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=1

# Load modules
module purge
module load PLINK/2.00a3.7-gfbf-2023a
module load VCFtools/0.1.16-GCC-12.3.0

# Define variables
VCF_FILE=$1
BASENAME=$(basename "$VCF_FILE" .vcf)
OUTDIR="pca_out/${BASENAME}"
PLINK_PREFIX="${OUTDIR}/${BASENAME}_plink"
PCA_OUT="${OUTDIR}/${BASENAME}_pca"

# Make sure output directory exists
#for when teaching - p means path so you are making the directory path
mkdir -p "${OUTDIR}"

# Step 1: Convert VCF to PLINK binary format
plink --vcf "${VCF_FILE}" \
      --double-id \
      --allow-extra-chr \
      --make-bed \
      --out "${PLINK_PREFIX}"

# Step 2: Run PCA on the PLINK files
#I think the pca number should be changed to n = sample size - 1
plink --bfile "${PLINK_PREFIX}" \
      --allow-extra-chr \
      --pca 12 var-wts \
      --out "${PCA_OUT}"
