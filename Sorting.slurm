#!/bin/bash --login
#SBATCH --job-name=Sorting
#SBATCH --output=logs/%x_%A_%a_sorted.out
#SBATCH --error=logs/%x_%A_%a_sorted.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --array=0-12

#Author: Magie Williams
#Date of Last Author Edit: September 1st, 2026
#Purpose of Script is to sort the BWA outfiles into cleaned up BAM files
#AI disclosure - Copilot through Michigan State University Licensing was used for syntax maintenance and optimization

#FIRST!!!!!
#CHANGE array TO 0-(NUMBER OF SAMPLES - 1)

#Clear modules
module purge
#load needed module
module load SAMtools  

#Call BWA output
#you can either do this in the command line or you can change BWA_Out to your folder name for you BWA output
BWAout="${1:-./BWA_Out}"  

#define and create the new output folder the bam files
BAMout="${2:-./BWA_Out/BAM_Out}"
mkdir -p "$BAMout"

#pulling sam files into object
#this is the same type of command as in BWA_2.slurm where we created the map of R1 and R2 files
mapfile -t SAM_Files < <(find "$BWAout" -maxdepth 1 -type f -iname "*.sam" | sort)

#merging SLURM ID with file ID
#calling the "tasks" so we can run them simutaneously
IDX="${SLURM_ARRAY_TASK_ID}"
#idenifying sam files
FILE="${SAM_Files[$IDX]}"
#pulling sample name
SAMPLE=$(basename "$FILE" .sam)

#defining output
bam_out="${BAMout}/${SAMPLE}.bam"

#using sam tools to convert files to bams
samtools view -b "$FILE" > "$bam_out"

#defining second output
sorted_bam="${BAMout}/${SAMPLE}.sorted.bam"
#sorting the reads in the bam file
samtools sort -o "$sorted_bam" "$bam_out"
#indexing the bam files (will need later)
samtools index "$sorted_bam"

#Citation for SAMtools
#Twelve years of SAMtools and BCFtools
#Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li
#GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008
