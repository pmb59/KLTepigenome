Uncovering the variation within epigenomic datasets using the Karhunen-Loeve Transform

<h4> Requirements </h4>
<a href="http://www.google.com/"> Bedtools </a> 
bigWigSummary
R package fda
R package ggplot2

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
