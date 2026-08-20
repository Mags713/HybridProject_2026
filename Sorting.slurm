#!/bin/bash --login
#SBATCH --job-name=Sorting
#SBATCH --output=logs/%x_%A_%a_sorted.out
#SBATCH --error=logs/%x_%A_%a_sorted.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --array=0-12 

#needed modules
module purge
module load SAMtools  


#folder of SNPs
BWAout="${1:-./BWA_Out}"  
BAMout="${2:-./BWA_Out/NewDay}"

mkdir -p "$BAMout"

#pulling sam files into object
mapfile -t SAM_Files < <(find "$BWAout" -maxdepth 1 -type f -iname "*.sam" | sort)

#merging SLURM ID with file ID
IDX="${SLURM_ARRAY_TASK_ID}"
FILE="${SAM_Files[$IDX]}"
SAMPLE=$(basename "$FILE" .sam)

##Need Arry for Sample Name
bam_out="${BAMout}/${SAMPLE}.bam"
samtools view -b "$FILE" > "$bam_out"

sorted_bam="${BAMout}/${SAMPLE}.sorted.bam"
samtools sort -o "$sorted_bam" "$bam_out"
samtools index "$sorted_bam"