#!/bin/bash --login
#SBATCH --job-name=PiWindow
#SBATCH --nodes=1
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --output=PiPixie_%j.out
#SBATCH --error=PiPixie_%j.err

#windows by population

#made a fresh conda environment 
source ~/miniconda3/etc/profile.d/conda.sh
conda activate pixy-env


pixy \
    --stats pi fst dxy \
    --vcf cohort_biallelic.vcf.gz \
    --populations sample_IDs.txt \
    --window_size 10000 \
    --output_folder pixy_out \
    --output_prefix all_pops \
    --n_cores 8

