<h3>Uncovering the variation within epigenomic datasets using the Karhunen-Loeve Transform</h3>

<h5> Requirements </h5>
- <a href="http://cran.r-project.org/web/packages/fda/index.html"> R package fda: Functional Data Analysis </a> 
- <a href="http://cran.r-project.org/web/packages/ggplot2/index.html"> R package ggplot2 </a> 
- <a href="http://cran.r-project.org/web/packages/RColorBrewer/index.html"> R package RColorBrewer </a> 
- <a href="http://bedtools.readthedocs.org/en/latest/"> Bedtools </a> 
- <a href="http://hgdownload.cse.ucsc.edu/admin/exe/"> bigWigSummary </a> 

<h4> KLTepigenome.r </h5>

<h5> Parameters </h5>
<p> [1]: Bigwig File </p> 
<p> [2]: File with regions in BED Format (columns 1,2,3,6 are required: chr, start, end, strand) </p> 
<p> [3]: Length of genomic regions to analyze (Integer)</p> 
<p> [4]: Number of B-spline basis (Integer)</p> 
<p> [5]: Check integrity of the files (T/F). If True, requires a *.chrom.sizes file in the folder.</p> 
<p> [6]: Remove ENCODE Blacklisted regions (T/F)</p> 
<p> [7]: Prefix of out files</p> 

<h5> Example: </h5>

<code>
$ Rscript KLTepigenome.r H3K4me3.bw regions.bed 1500 150 T T H3K4_mark
</code>

<h5> Output: </h5>

<h4> propVarPlot.r </h5>

<h4> corrMatrix.r </h5>
