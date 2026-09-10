#!/bin/bash --login
#SBATCH --job-name=GenoQuick
#SBATCH --output=QkGeno_%j.out
#SBATCH --error=QkGeno_%j.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=48G

#Author: Magie Williams
#Last Author Edits: September 9th, 2026
#Intended for use after the GalwMeMaybe.sh
#AI Disclosure: Copilot licensed by Michigan State University was used for Error message trouble shooting
#Purpose: Genotype vcf files into a single file that can be used with eiGetValues.sh 


#setting up workflow
set -euo pipefail

#purge preset modules
module purge
#load proper version of GATK
#In my HPCC interface module spider can get you proper versions
module load GATK/4.5.0.0-GCCcore-12.3.0-Java-17
#Load Samtools
module load SAMtools

#The Contact List - Data input
#Reference fasta - expects .fa
REF_FASTA=$1
#folder of vcf samples per file
VCF_DIR=$2
#extracting folder name
DIR_NAME="$(basename "$VCF_DIR")"
#extracting Final name from whole VCF file
FINAL_GIRL="${VCF_DIR}/${DIR_NAME}_quick.g.vcf.gz"
#defining intervals for future use
INTERVALS="intervals_${DIR_NAME}_quick.list"
#sample locations hard in - this was needed to fix some running errors
MAP=$3
#Name and create the genomic database
GnDB="genomicsdb_${DIR_NAME}_quick"



#need to remove the database before running
#if there is already a database made it will interfere with this run with how the script is written
rm -rf "$GnDB"
#So I can run this multiple times
#same with this index file
rm -f "$FINAL_GIRL" "${FINAL_GIRL}.tbi"

#interval list for GATK
#there should already be a .fai file
cut -f1 "${REF_FASTA}.fai" > "${INTERVALS}"

#Caller ID - Naming
#this is a double checking step to make sure that everything is lining up appropriately 
ls "${VCF_DIR}"/*.g.vcf.gz | awk -F/ '{fname=$NF; sub(".g.vcf.gz","",fname); print fname "\t" $0}' > "${MAP}"
#Step checking call in out file
echo "That is My Map!!"

#prep for genotypings with GATK - this is where the population map is required
gatk GenomicsDBImport \
  --sample-name-map "$MAP" \
  --genomicsdb-workspace-path "$GnDB" \
  --reference "$REF_FASTA" \
  --intervals "$INTERVALS"
#step checking call
echo "Route to Genomic Treasure Found"
#genotyping with GATK
gatk GenotypeGVCFs \
  -R "$REF_FASTA" \
  -V gendb://"$GnDB" \
  -O "$FINAL_GIRL" \
#calling that it made it through the script
echo "Treasure!!!"

#Citation for GATK
#Van der Auwera GA & O'Connor BD. (2020). Genomics in the Cloud: Using Docker, GATK, and WDL in Terra (1st Edition). O'Reilly Media.
#Citation for GATK best practices
#Van der Auwera GA, Carneiro M, Hartl C, Poplin R, del Angel G, Levy-Moonshine A, Jordan T, Shakir K, Roazen D, Thibault J, Banks E, Garimella K, Altshuler D, Gabriel S, DePristo M. (2013). From FastQ Data to High-Confidence Variant Calls: The Genome Analysis Toolkit Best Practices Pipeline. Curr Protoc Bioinformatics, 43:11.10.1-11.10.33. DOI: 10.1002/0471250953.bi1110s43.
#Citation for SAMtools
#Twelve years of SAMtools and BCFtools
#Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li. GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008\
