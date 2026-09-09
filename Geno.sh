#!/bin/bash --login
#SBATCH --job-name=GenoQuick
#SBATCH --output=QkGeno_%j.out
#SBATCH --error=QkGeno_%j.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=48G

set -euo pipefail

# Load GATK and other required modules
module purge
module load GATK/4.5.0.0-GCCcore-12.3.0-Java-17
module load SAMtools

#The Contact List - Data input
REF_FASTA=$1
VCF_DIR=$2
DIR_NAME="$(basename "$VCF_DIR")"
FINAL_GIRL="${VCF_DIR}/${DIR_NAME}_quick.g.vcf.gz"
INTERVALS="intervals_${DIR_NAME}_quick.list"
MAP=$3
GnDB="genomicsdb_${DIR_NAME}_quick"



#need to remove the database before running
rm -rf "$GnDB"
#So I can run this multiple times
rm -f "$FINAL_GIRL" "${FINAL_GIRL}.tbi"

#interval list for GATK
cut -f1 "${REF_FASTA}.fai" > "${INTERVALS}"

#Caller ID - Naming
ls "${VCF_DIR}"/*.g.vcf.gz | awk -F/ '{fname=$NF; sub(".g.vcf.gz","",fname); print fname "\t" $0}' > "${MAP}"

echo "That is My Map!!"

gatk GenomicsDBImport \
  --sample-name-map "$MAP" \
  --genomicsdb-workspace-path "$GnDB" \
  --reference "$REF_FASTA" \
  --intervals "$INTERVALS"

echo "Route to Genomic Treasure Found"

gatk GenotypeGVCFs \
  -R "$REF_FASTA" \
  -V gendb://"$GnDB" \
  -O "$FINAL_GIRL" \

echo "Treasure!!!"