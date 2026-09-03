# HybridProject_2026 
## Scripts and Documents Associated with hybrid manuscript: 
### <ins> Genetic Diversity </ins>
&emsp;In order of use: 
- BWA_2.slurm 
- Sorting.slurm 
- GalwMeMaybe.slurm 
- eiGetValues.sh 
- PCA_Visuals.Rmd - Currently Wrong Version as of Sep. 1, 2026 - Would technically work up if plots were pulled out but bottom is the wrong work flow
- PiFilterNew.sh 
- PixyPi.sh 
- PixyPi.Rmd 
- PixyResults.Rmd 

<br>

>Scripts that have been properly edited and annotated thus far:
  >- FinalMap.R
  >- BWA_2.slurm
  >- Sorting.slurm
>  - GalwMeMaybe.slurm
>  - eiGetValues.sh

### <ins> Mapping </ins>
- FinalMap.R

<br>


## Script Descriptions and Usage
### ***BWA_2.slurm***

&emsp;<ins>Description:</ins>
- This script uses BWA to align short read fastq files to a reference genome.
- It needs to be made executable before use. See the source github page for installation and further specific usage.
   -  BWA: https://github.com/lh3/bwa 

&emsp;<ins>Usage:</ins>
- The array number in the script header should be changed to one less the number of samples in your ReadsFolder
- To execute the script you should use the following command and files

      sbatch BWA_2.slurm Reference.fa PathToReadsFolder NameOfBWAOutFolder

&emsp;<ins>Output:</ins>
- sam file per sample

>**Citation for BWA**\
>-Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760. [PMID: 19451168]. (if you use the BWA-backtrack algorithm)\
>-Li H. and Durbin R. (2010) Fast and accurate long-read alignment with Burrows-Wheeler transform. Bioinformatics, 26, 589-595. [PMID: 20080505]. (if you use the BWA-SW algorithm)\
>-Li H. (2013) Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv:1303.3997v2 [q-bio.GN]. (if you use the BWA-MEM algorithm or the fastmap command, or want to cite the whole BWA package)\

<br>

### ***Sorting.slurm***
&emsp;<ins>Description:</ins>
- This script takes the sam files from *BWA_2.slurm* and generates sorted bam files.
- It can be used on a folder of sam files as well.

&emsp;<ins>Usage:</ins>
- Before running make sure that you have the same call for samtools.
  - If yours is different just change it in the script
- The array number in the script header should be changed to one less the number of samples
  - If you are using with *BWA_2.slurm* it should be equivalent to the number that you used then.
- To run the script using the following in command line

      sbatch Sorting.slurm NameOfBWAOutFolder PathToNewSortedBAM_Folder

&emsp;<ins>Output:</ins>
- bam files (.bam)
- sorted bam files (_sorted.bam)
- sorted indexed bam files (_sorted.bai)

>**Citation for SAMtools**\
>-*Twelve years of SAMtools and BCFtools*\
>-Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li. GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008\

<br>

### ***GalwMeMaybe.slurm***
&emsp;<ins>Description:</ins>
- The purpose of this script is to take the output from *Sorting.slurm* and generate a vcf file using Haplotype caller from GATK.
  - Part 1 generates a bam file of reading groups
  - Part 2 using the haplotype caller function to generate the vcf

&emsp;<ins>Usage:</ins>
- Before running check that the array number in the header matches the number of samples that you have
    - if running with *BWA_2.slum* or *Sorting.slurm* it should be the same number that you used for those
- You should also check the calls and versions for required modules (SamTools and GATK, I used GATK ver. 4.5.0.0-GCCcore-12.3.0-Java-17)
- To run the script put the following into commmand line:

      sbatch GalwMeMaybe.slurm Rerference.fa PathToNewSortedBAM_Folder
  
&emsp;<ins>Output:</ins>
- Reading grouped bams (_RG.bam)
- Index of Reading grouped bams (_RG.bai)
- VCF file per bam (vcf.gz)

>**Citation for GATK**\
>-Van der Auwera GA & O'Connor BD. (2020). Genomics in the Cloud: Using Docker, GATK, and WDL in Terra (1st Edition). O'Reilly Media.\
>**Citation for GATK best practices**\
>-Van der Auwera GA, Carneiro M, Hartl C, Poplin R, del Angel G, Levy-Moonshine A, Jordan T, Shakir K, Roazen D, Thibault J, Banks E, Garimella K, Altshuler D, Gabriel S, DePristo M. (2013). From FastQ Data to High-Confidence Variant Calls: The Genome Analysis Toolkit Best Practices Pipeline. Curr Protoc Bioinformatics, 43:11.10.1-11.10.33. DOI: 10.1002/0471250953.bi1110s43.\
>**Citation for SAMtools**\
>-*Twelve years of SAMtools and BCFtools*\
>-Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li. GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008\

<br>

### ADD Geno.sh
<br>

### ***eiGetValues***
&emsp;<ins>Description:</ins>
- It takes the VCF file and using PLINK creates PLINK files
- Then it still with PLINK uses the PLINK files to generate a PCA

&emsp;<ins>Usage:</ins>
- Requires the VCF files from **Geno.sh** to be merged into a single file.
- Before running check the calls module versions for PLINK and VCFtools
- To run this script in command line:

      sbatch eiGetValues.sh VCF_File.vcf

&emsp;<ins>Output:</ins>
- log file (.log)
- eigenvector file (.eigenvec)
- bim file (.bim)
- var file (.var)
- fam file (.fam)
- bed file (.bed)
- eigenvalue file (.eigenval)

>**Citation for Plink**\
>-Package: PLINK/2.00a3.7-gfbf-2023a\
>-Authors: Shaun Purcell, Christopher Chang\
>-URL: www.cog-genomics.org/plink/2.0/\
>-Lit Citation: Chang CC, Chow CC, Tellier LCAM, Vattikuti S, Purcell SM, Lee JJ (2015) Second-generation PLINK: rising to the challenge of larger and richer datasets. GigaScience, 4.\
>**Citation for VCFtools**\
>-Authors for OG VCFtools: Adam Auton and Anthony Marcketta\
>-Lit Citation: The Variant Call Format and VCFtools, Petr Danecek, Adam Auton, Goncalo Abecasis, Cornelis A. Albers, Eric Banks, Mark A. DePristo, Robert Handsaker, Gerton Lunter, Gabor Marth, Stephen T. Sherry, Gilean McVean, Richard Durbin and 1000 Genomes Project Analysis Group, Bioinformatics, 2011\

<br>

### Script Citations:
***BWA_2.slurm*** 
>**Citation for BWA**\
>-Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760. [PMID: 19451168]. (if you use the BWA-backtrack algorithm)\
>-Li H. and Durbin R. (2010) Fast and accurate long-read alignment with Burrows-Wheeler transform. Bioinformatics, 26, 589-595. [PMID: 20080505]. (if you use the BWA-SW algorithm)\
>-Li H. (2013) Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv:1303.3997v2 [q-bio.GN]. (if you use the BWA-MEM algorithm or the fastmap command, or want to cite the whole BWA package)\

<br>

***Sorting.slurm***
>**Citation for SAMtools**\
>-*Twelve years of SAMtools and BCFtools*\
>-Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li. GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008\

<br>

***GalwMeMaybe.slurm***
>**Citation for GATK**\
>-Van der Auwera GA & O'Connor BD. (2020). Genomics in the Cloud: Using Docker, GATK, and WDL in Terra (1st Edition). O'Reilly Media.\
>**Citation for GATK best practices**\
>-Van der Auwera GA, Carneiro M, Hartl C, Poplin R, del Angel G, Levy-Moonshine A, Jordan T, Shakir K, Roazen D, Thibault J, Banks E, Garimella K, Altshuler D, Gabriel S, DePristo M. (2013). From FastQ Data to High-Confidence Variant Calls: The Genome Analysis Toolkit Best Practices Pipeline. Curr Protoc Bioinformatics, 43:11.10.1-11.10.33. DOI: 10.1002/0471250953.bi1110s43.\
>**Citation for SAMtools**\
>-*Twelve years of SAMtools and BCFtools*\
>-Petr Danecek, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, Thomas Keane, Shane A McCarthy, Robert M Davies, Heng Li. GigaScience, Volume 10, Issue 2, February 2021, giab008, https://doi.org/10.1093/gigascience/giab008\

<br>

***eiGetValues.sh***
>**Citation for Plink**\
>-Package: PLINK/2.00a3.7-gfbf-2023a\
>-Authors: Shaun Purcell, Christopher Chang\
>-URL: www.cog-genomics.org/plink/2.0/\
>-Lit Citation: Chang CC, Chow CC, Tellier LCAM, Vattikuti S, Purcell SM, Lee JJ (2015) Second-generation PLINK: rising to the challenge of larger and richer datasets. GigaScience, 4.\
>**Citation for VCFtools**\
>-Authors for OG VCFtools: Adam Auton and Anthony Marcketta\
>-Lit Citation: The Variant Call Format and VCFtools, Petr Danecek, Adam Auton, Goncalo Abecasis, Cornelis A. Albers, Eric Banks, Mark A. DePristo, Robert Handsaker, Gerton Lunter, Gabor Marth, Stephen T. Sherry, Gilean McVean, Richard Durbin and 1000 Genomes Project Analysis Group, Bioinformatics, 2011\
