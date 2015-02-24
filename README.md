<h3>Uncovering the variation within epigenomic datasets using the Karhunen-Loeve Transform</h3>

<h4> Requirements </h4>
<a href="http://bedtools.readthedocs.org/en/latest/"> Bedtools </a> 
<a href="http://hgdownload.cse.ucsc.edu/admin/exe/"> bigWigSummary </a> 
<a href="http://cran.r-project.org/web/packages/fda/index.html"> R package fda: Functional Data Analysis </a> 
<a href="http://cran.r-project.org/web/packages/ggplot2/index.html"> R package ggplot2 </a> 

<h4> Parameters </h4>
1: Bigwig File
2: File with regions in Bed Format
3: Length of genomic regions to analyze (Integer)
4: B-spline basis (Integer)
5: Check integrity of the files (TRUE/FALSE). If tru requires a *.chrom.sizes file.
6: Remove ENCODE Blacklisted regions (TRUE/FALSE)

<h4> Example </h4>

<code>
Rscript KLTepigenome.r H3K4me3.bw regions.bed 1500 150 TRUE
</code>
