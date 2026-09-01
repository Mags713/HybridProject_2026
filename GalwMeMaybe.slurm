#!/bin/bash --login
#SBATCH --job-name=CallMeMaybe
#SBATCH --output=logs/%x_%A_%a.out
#SBATCH --error=logs/%x_%A_%a.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --array=0-12  

#Author: Magie Williams
#Date of Last Author Edit: September 1st, 2026
#Purpose is for Variant calling
#Fun Fact: Galw in welsh is call like "Pwy Sy'n Galw" would be "Who is callin' me?"
#So besides being a call back to Carly Rae Jepsen, it is also a question hoping the script would work at a certain point
#AI Disclosure - Copilot through Michigan State University Licensing was used for optimization and troubleshooting

#FIRST!!!
#CHANGE array TO 0-(NUMBER OF SAMPLES - 1)
#Slurm starts counting at zero not one

#making sure everything works
#not needed but kept
set -euo pipefail

#clear preloaded modules
module purge
#load GATK
#if not on MSU HPCC check that this is the correct version for you
module load GATK/4.5.0.0-GCCcore-12.3.0-Java-17
#load SAMtools
module load SAMtools

#The Contact List - Data input
#The reference you aligned to
#you can either call it in the command line or change the file name what I have is calling the reference inside another directory
REF_FASTA="${1:-./Bmac_DB/BMac_assembly-v2.fa}"
#Define the directory the folder of the converted bam files is in
BAM_DIR="${2:-./BWA_Out}"

#Caller ID - Naming
#Similar to the other times we used mapfile in the previous two scripts
mapfile -t BAM_FILES < <(find "$BAM_DIR" -maxdepth 1 -type f -iname "*.sorted.bam" | sort)

#Time to make some calls
#essentially typing in the phone number
#This is again calling the jobs simutaneously
IDX="${SLURM_ARRAY_TASK_ID}"
#Idenitfying bam files
BAM_FILE="${BAM_FILES[$IDX]}"
#getting sample name
SAMPLE_NAME="$(basename "$BAM_FILE" .sorted.bam)"
#making reading group output file
RG_BAM="${BAM_DIR}/${SAMPLE_NAME}.sorted_RG.bam"
#making vcf output
VCF_FILE="${BAM_DIR}/${SAMPLE_NAME}.g.vcf.gz"

#Running GATK Part 1 - Sorting those contacts into groups
#This is identifying read groups
gatk AddOrReplaceReadGroups \
  -I "$BAM_FILE" \
  -O "$RG_BAM" \
  --RGID "$SAMPLE_NAME" \
  --RGLB "lib1" \
  --RGPL "ILLUMINA" \
  --RGPU "unit1" \
  --RGSM "$SAMPLE_NAME" \
  --CREATE_INDEX true

echo "${SAMPLE_NAME} has be queued for call on $(hostname)"

echo "${SAMPLE_NAME} is calling"

#Now we are officially calling that our contact or sample
#Haploype caller is idenifying variants using the read groups we made above
gatk HaplotypeCaller \
  -R "$REF_FASTA" \
  -I "$RG_BAM" \
  -O "$VCF_FILE" \
  --emit-ref-confidence GVCF

echo "Leave a Message at the Beep"

#Citation for GATK
#Van der Auwera GA & O'Connor BD. (2020). Genomics in the Cloud: Using Docker, GATK, and WDL in Terra (1st Edition). O'Reilly Media.
#Citation for GATK best practices
#Van der Auwera GA, Carneiro M, Hartl C, Poplin R, del Angel G, Levy-Moonshine A, Jordan T, Shakir K, Roazen D, Thibault J, Banks E, Garimella K, Altshuler D, Gabriel S, DePristo M. (2013). From FastQ Data to High-Confidence Variant Calls: The Genome Analysis Toolkit Best Practices Pipeline. Curr Protoc Bioinformatics, 43:11.10.1-11.10.33. DOI: 10.1002/0471250953.bi1110s43.
#Citation for SAMtools
#Twelve years of SAMtools and BCFtools
#Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li
#GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008
