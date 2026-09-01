#!/bin/bash --login
#SBATCH --job-name=BWA_Array
#SBATCH --output=logs/%x_%A_%a.out
#SBATCH --error=logs/%x_%A_%a.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --array=0-12 

#Author: Magie Williams
#Date of Last Author Edit: September 1st, 2026
#AI disclosure - CoPilot through Michigan State University licensing was used for troubleshooting and syntax checking, and some organization
#Annotation was done by human
#Most Errors were also made by the human
#the purpose of this script is to align reads returned from the RTSF to the reference genome
#Generated for Publication:

#FIRST!!!!
#CHANGE ARRAY TO BE 0-(1-NUMBER OF SAMPLES)

#clearing out modules
module purge

#BWA needs to be downloaded ahead of time
#YOU CANNOT MAKE BWA IN THE SLURM SCRIPT
#my BWA directory was bwa/bwa
#I used BWA2
#BWA also needs to be made executable prior to running the script
#This is where to get BWA: https://github.com/lh3/bwa
#There is a note that a new software will becoming to replace bwa for shortreads with minibwa
#No Date was listed
#YOU CANNOT MAKE BWA IN THE SLURM SCRIPT
#COPY THE COMMANDS BELOW INTO COMMAND LINE
#git clone https://github.com/lh3/bwa.git
#cd bwa; make
#./bwa index ref.fa
#ref.fa should be your reference

#This is to make sure that BWA was made correctly
set -euo pipefail

#fasta file
#This is what you are aligning the SNPs to
#It needs to be indexed before running the script
#you would type this in after the the script filename
REF="$1"

#folder of SNPs
#All the SNPs need to be in one folder
#you can either call this by typing out the file path to yout reads or replacing /READS with your folder name
READS="${2:-./READS}"  

#Create an outfolder
#You can call this in the command line or change /BWA_TM_Out to your desired outfolder name
#I suggest using BWA to denote what was used then something to indicate it is an outfolder and what reference you used
BWAout="${3:-./BWA_TM_Out}" 
mkdir -p BWAout

#FIND R1 AND R2 FILES
#When we get our files back from RTSF they are given in the format SampleName_R1.fastq.gz with a sister file replacing R1 with R2
#This first command is creating a "Map" of the file pairs
#If you received your read files with a different naming scheme you should adjust accordingly
mapfile -t R1_FILES < <(find "$READS" -maxdepth 1 -type f \
  \( -iname "*R1*.fastq" -o -iname "*R1*.fastq.gz" \) | sort)

mapfile -t R2_FILES < <(find "$READS" -maxdepth 1 -type f \
  \( -iname "*R2*.fastq" -o -iname "*R2*.fastq.gz" \) | sort)

#STRIP READ MARKER TO CREATE PAIRING KEYS
#This in a way is a step in creating a master sample key
strip_read_marker() {
  local f="$1"
  local base
  base="$(basename "$f")"
  base="${base%.fastq}"
  base="${base%.fastq.gz}"
  base="$(echo "$base" | sed -E 's/([._-])R[12]([._-]|$)/\1SAMPLE\2/')"
  base="$(echo "$base" | sed -E 's/([._-])001([._-]|$)/\1\2/')"
  echo "$base"
}

# BUILD MAPPING FOR R1 → sample key and R2 → same sample key
declare -A MAP_R1 MAP_R2 

for f in "${R1_FILES[@]}"; do
  k="$(strip_read_marker "$f")"
  MAP_R1["$k"]="$f"
done
for f in "${R2_FILES[@]}"; do
  k="$(strip_read_marker "$f")"
  MAP_R2["$k"]="$f"
done

#CREATE ORDERED LIST OF PAIRED SAMPLES
#This is like finding twins or matching up all the keys 
pairs=()
while IFS= read -r key; do
  if [[ -n "${MAP_R1[$key]:-}" && -n "${MAP_R2[$key]:-}" ]]; then
    pairs+=("$key")
  fi
done < <(printf "%s\n" "${!MAP_R1[@]}" | sort)

NUM_PAIRS="${#pairs[@]}"

# SELECT SAMPLE FOR THIS ARRAY INDEX
#Now we are simutaneously aligning all the samples to the reference
#IDX is calling the "task"
IDX="${SLURM_ARRAY_TASK_ID}"
#Idenifying sample pairs
KEY="${pairs[$IDX]}"
R1="${MAP_R1[$KEY]}"
R2="${MAP_R2[$KEY]}"
#making the master sample name
SAMPLE="$(basename "$KEY" | sed -E 's/SAMPLE//g' | sed -E 's/[._-]+$//')"

echo "=== Running sample $SAMPLE ==="
echo "R1 = $R1"
echo "R2 = $R2"

out_file="${BWAout}/${SAMPLE}.sam"

#this is where we are finally calling BWA
bwa/bwa mem "$REF" "$R1" "$R2" > "$out_file"

#Citation for BWA
#Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760. [PMID: 19451168]. (if you use the BWA-backtrack algorithm)
#Li H. and Durbin R. (2010) Fast and accurate long-read alignment with Burrows-Wheeler transform. Bioinformatics, 26, 589-595. [PMID: 20080505]. (if you use the BWA-SW algorithm)
#Li H. (2013) Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv:1303.3997v2 [q-bio.GN]. (if you use the BWA-MEM algorithm or the fastmap command, or want to cite the whole BWA package)
