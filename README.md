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
- To execute the script you should use the following command and files

  &emsp;&emsp;sbatch BWA_2.slurm Reference.fa PathToReadsFolder NameOfOutFolder

&emsp;<ins>Output:</ins>
- sam file per sample

>**Citation for BWA**\
>-Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25, 1754-1760. [PMID: 19451168]. (if you use the BWA-backtrack algorithm)\
>-Li H. and Durbin R. (2010) Fast and accurate long-read alignment with Burrows-Wheeler transform. Bioinformatics, 26, 589-595. [PMID: 20080505]. (if you use the BWA-SW algorithm)\
>-Li H. (2013) Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv:1303.3997v2 [q-bio.GN]. (if you use the BWA-MEM algorithm or the fastmap command, or want to cite the whole BWA package)\



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
