#!/bin/bash --login
#SBATCH --job-name=CallMeMaybe
#SBATCH --output=logs/%x_%A_%a.out
#SBATCH --error=logs/%x_%A_%a.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --array=0-12  

set -euo pipefail

# Load GATK and other required modules
module purge
module load GATK/4.5.0.0-GCCcore-12.3.0-Java-17
module load SAMtools

#The Contact List - Data input
REF_FASTA="${1:-./Bmac_DB/BMac_assembly-v2.fa}"
BAM_DIR="${2:-./BWA_Out}"

#Caller ID - Naming
mapfile -t BAM_FILES < <(find "$BAM_DIR" -maxdepth 1 -type f -iname "*.sorted.bam" | sort)

IDX="${SLURM_ARRAY_TASK_ID}"
BAM_FILE="${BAM_FILES[$IDX]}"
SAMPLE_NAME="$(basename "$BAM_FILE" .sorted.bam)"
RG_BAM="${BAM_DIR}/${SAMPLE_NAME}.sorted_RG.bam"
VCF_FILE="${BAM_DIR}/${SAMPLE_NAME}.g.vcf.gz"

gatk AddOrReplaceReadGroups \
  -I "$BAM_FILE" \
  -O "$RG_BAM" \
  --RGID "$SAMPLE_NAME" \
  --RGLB "lib1" \
  --RGPL "ILLUMINA" \
  --RGPU "unit1" \
  --RGSM "$SAMPLE_NAME" \
  --CREATE_INDEX true

echo "${SAMPLE_NAME} has entered the chat on $(hostname)"


echo "${SAMPLE_NAME} is calling"

gatk HaplotypeCaller \
  -R "$REF_FASTA" \
  -I "$RG_BAM" \
  -O "$VCF_FILE" \
  --emit-ref-confidence GVCF

echo "Leave a Message at the Beep"
