#!/bin/bash --login
#SBATCH --job-name=PiWindow
#SBATCH --nodes=1
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --output=PiPixie_%j.out
#SBATCH --error=PiPixie_%j.err

#Author: Magie Williams
#Date of Last Author Edit: September 10th, 2026
#Ai-Disclosure - Did not use AI, only pixy documentation
#Purpose: Take the final file from PiFilterNew.sh and run pi
#Additional Notes: Pi is being run by population and windowed because of the file size and processing memory required
#windows by population

#made a fresh conda environment 
#This is something that needs to be made ahead of time
#Guide to Conda Environments: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
source ~/miniconda3/etc/profile.d/conda.sh
conda activate pixy-env

#Running pi with pixy so there will be three output files for pi, fst, and dxy
#This requires a "map" or the sample_IDs.txt
#This also requires pre-downloading pixy
#Pixy documents: https://pixy.readthedocs.io/en/latest/
pixy \
    --stats pi fst dxy \
    --vcf cohort_biallelic.vcf.gz \
    --populations sample_IDs.txt \
    --window_size 10000 \
    --output_folder pixy_out \
    --output_prefix all_pops \
    --n_cores 8

#Citation for Pixy
#Korunes, K.L. and Samuk, K. (2021), pixy: Unbiased estimation of nucleotide diversity and divergence in the presence of missing data. Molecular Ecology Resources. Accepted Author Manuscript. 
#https://doi.org/10.1111/1755-0998.13326
