<h3>Uncovering correlated variability in epigenomic datasets using the Karhunen-Loeve Transform</h3>

<h5> Requirements </h5>
- <a href="http://cran.r-project.org/web/packages/fda/index.html"> R package fda </a> 
- <a href="http://cran.r-project.org/web/packages/ggplot2/index.html"> R package ggplot2 </a> 
- <a href="http://github.com/BIMSBbioinfo/genomation"> R package genomation </a>  
- <a href="http://cran.r-project.org/web/packages/RColorBrewer/index.html"> R package RColorBrewer </a> 
- <a href="http://bedtools.readthedocs.org/en/latest/"> Bedtools </a> 
- <a href="http://hgdownload.cse.ucsc.edu/admin/exe/"> UCSC bigWigSummary </a> 

<p> Scripts: </p> 

<ul style="list-style-type:circle">
<li>
<h4> KLTepigenome.r </h5>
</li>

<h5> Parameters required</h5>
<p> [1]: bigWig File </p> 
<p> [2]: File with regions in BED Format (columns 1,2,3,6 are required: chr, start, end, strand) </p> 
<p> [3]: Length of genomic regions to analyze (Integer)</p> 
<p> [4]: Number of B-spline basis (Integer)</p> 
<p> [5]: Check integrity of the files (T/F). If True, requires a *.chrom.sizes file in the folder.</p> 
<p> [6]: Remove ENCODE Blacklisted regions (T/F)</p> 
<p> [7]: Prefix of output files</p> 
<p> [8]: Number of functional principal components to compute</p> 
<p> [9]: Number of functional principal components to plot</p> 
<p> [10]: Number of bins to be used in the heatmap</p> 

<h5> Example: </h5>

<code>
$ Rscript KLTepigenome.r H3K4me3.bw regions.bed 5000 100 T T H3K4_mark 50 5 100
</code>

<h5> Output files: </h5>
<p> X:  </p>
<p> Y:   </p>
<p> Z:  </p>





<li>
<h4> propVarPlot.r </h5>
</li>

<h5> Parameters required</h5>
<p> [1...N]: List of N *_varprop.txt files with proportions of variance </p> 

<h5> Example: </h5>

<code>
$ Rscript propVarPlot.r H3K4me3_mark_varprop.txt H3K27me3_mark_varprop.txt H2A.Z_mark_varprop.txt
</code>

<h5> Output files: </h5>
propVarPlot.pdf: A scatterplot of the Component number vs the Cumulative sum of variance explained (%)



<li>
<h4> KLTmaxCorrelation.r </h5>
</li>

<h5> Parameters required</h5>
<p> [1...N]: List of N *_pc_scores.txt files with principal component scores  </p> 
 

<h5> Example: </h5>

<code>
$ Rscript KLTmaxCorrelation.r H3K4me1 H3K4me2 H3K4me3
</code>

<h5> Output files: </h5>
<p> cor_Scores.csv: matrix of maximum values of Pearson correlation coefficients between functional principal component scores  </p>
<p> cor_Scores_#Eigenfunctions.csv: order of the Eigenfunctions in which the maximum correlation takes place   </p>
<p> cor_Eigenfunctions.csv: Pearson correlation coefficients between the eigenfunctions in cor_Scores_#Eigenfunctions.csv </p>


</ul>
