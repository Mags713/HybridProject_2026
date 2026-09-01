#!/bin/bash --login
#SBATCH --job-name=eiGetValues
#SBATCH --output=IgetValues_%j.out
#SBATCH --error=IgetValues_%j.err
#SBATCH --time=02:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=1

#Author: Magie Williams
#This takes the output from GalwMeMaybe and gives eigenvalues etc. 
#AI diclosure - Copilot Licesnsed by Michigan State University was used for syntax checking and troubleshooting

#Clear modules
module purge
#If not on MSU HPCC check that this is the right version for you
module load PLINK/2.00a3.7-gfbf-2023a
#If not on MSU HPCC check that this is the right version for you
module load VCFtools/0.1.16-GCC-12.3.0

# Define variables
#This is going to be the final VCF file from GATK - there should only be one
#how written you need to define in the command line with the first position after the script
#otherwise you can change it directly to the file name here
VCF_FILE=$1
#extracting basename to use on output files
BASENAME=$(basename "$VCF_FILE" .vcf)
#Naming an out directory
OUTDIR="pca_out/${BASENAME}"
#giving an output prefix
PLINK_PREFIX="${OUTDIR}/${BASENAME}_plink"
#naming an outfile
PCA_OUT="${OUTDIR}/${BASENAME}_pca"

# Make sure output directory exists
#for when teaching - p means path so you are making the directory path
#make the directory
mkdir -p "${OUTDIR}"

# Convert VCF to PLINK binary format
# I have allow-extra-chr because I am working with a tetraploid, those with diploids may need to comment it out, I don't know.
# I have make-bed because I did not make the bed files ahead of time
plink --vcf "${VCF_FILE}" \
      --double-id \
      --allow-extra-chr \
      --make-bed \
      --out "${PLINK_PREFIX}"

# Run PCA on the PLINK files
#I think the pca number should be changed to n = sample size - 1
#same deal as above with allowing for the extra chromosomes
#check plink documentation to adjust types of output
plink --bfile "${PLINK_PREFIX}" \
      --allow-extra-chr \
      --pca 12 var-wts \
      --out "${PCA_OUT}"

#Citation for Plink
#Package: PLINK <version>
#Authors: Shaun Purcell, Christopher Chang
#URL: www.cog-genomics.org/plink/2.0/
#Chang CC, Chow CC, Tellier LCAM, Vattikuti S, Purcell SM, Lee JJ (2015) Second-generation PLINK: rising to the challenge of larger and richer datasets. GigaScience, 4.

#Citation for VCFtools
#Authors for OG VCFtools: Adam Auton and Anthony Marcketta
#The Variant Call Format and VCFtools, Petr Danecek, Adam Auton, Goncalo Abecasis, Cornelis A. Albers, Eric Banks, Mark A. DePristo, Robert Handsaker, Gerton Lunter, Gabor Marth, Stephen T. Sherry, Gilean McVean, Richard Durbin and 1000 Genomes Project Analysis Group, Bioinformatics, 2011
