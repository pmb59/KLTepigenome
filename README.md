# KLTepigenome

<h3>Uncovering correlated variability in epigenomic datasets using the Karhunen-Loeve Transform</h3>
Next-generation sequencing is enabling the scientific community to go a step further in the understanding of molecular mechanisms controlling transcriptional and epigenetic regulation. Chromatin immunoprecipitation followed by sequencing (ChIP-seq) is commonly applied to map histone modifications or transcription factor binding sites for a protein of interest. **KLTepigenome** is a set of R scripts allowing to explore patterns of epigenomic variability and covariability in next-generation sequencing data sets by means of a functional eigenvalue decomposition of genomic data. The script KLTepigenome.r must be run first on each bigWig file, before using the rest of scripts.


<h5> Dependencies </h5>
- <a href="http://cran.r-project.org/web/packages/fda/index.html"> R package fda </a> 
- <a href="http://cran.r-project.org/web/packages/ggplot2/index.html"> R package ggplot2 </a> 
- <a href="http://github.com/BIMSBbioinfo/genomation"> R package genomation </a>  
- <a href="http://cran.r-project.org/web/packages/RColorBrewer/index.html"> R package RColorBrewer </a> 
- <a href="http://bedtools.readthedocs.org/en/latest/"> Bedtools </a> 
- <a href="http://hgdownload.cse.ucsc.edu/admin/exe/"> UCSC bigWigSummary </a> 



## KLTepigenome.r

<h5> Parameters required</h5>
<p> [1]: bigWig Formatted File </p> 
<p> [2]: File with regions in BED Format (columns 1,2,3,6 are required: chr, start, end, strand) </p> 
<p> [3]: Length (base pairs) of genomic regions to analyze (integer)</p> 
<p> [4]: Number of B-spline basis (integer)</p> 
<p> [5]: Check integrity of the files (T/F). If True (T), requires a *.chrom.sizes file in the folder.</p> 
<p> [6]: Remove ENCODE Blacklisted regions (T/F)</p> 
<p> [7]: Prefix of output files</p> 
<p> [8]: Number of functional principal components to compute</p> 
<p> [9]: Number of functional principal components to plot</p> 
<p> [10]: Number of bins to be used in the heatmap</p> 

<h5> Example </h5>

    $ Rscript KLTepigenome.r H3K4me3.bw regions.bed 5000 100 T T H3K4me3_mark 50 5 100
    

<h5> Output files </h5>
<p> {prefix}_intersect.bed: Final set of genomic regions (if input parameters [5,6] are FALSE, then this file is the same as the initial BED file) </p>
<p> {prefix}_heatmap.pdf: Heat map showing the genomic regions (read-enrichment profiles) considered in the analysis </p>
<p> {prefix}_varprop.txt: Proportions of variance explained by the functional principal components   </p>
<p> {prefix}_scores.txt: Matrix of functional principal component scores for each genomic region  </p>
<p> {prefix}_components.txt: Value of principal components at each nucleotide </p>
<p> {prefix}_components.pdf: Plot of functional principal components as indicated in input parameter [9]</p>
<p> {prefix}_mean_sd.png: Plot of the functional mean of the data, and the interval indicating the functional standard deviation. </p>
<p> {prefix}_barplot.pdf: Barplot of proportion (%) of variance explained by the components computed (input parameter [8]) </p> 



## propVarPlot.r

<h5> Parameters required</h5>
<p> [1...N]: List of N *_varprop.txt files with proportions of variance, obtained after running KLTepigenome.r </p> 

<h5> Example </h5>

    $ Rscript propVarPlot.r H3K4me3_mark_varprop.txt H3K27me3_mark_varprop.txt H2A.Z_mark_varprop.txt
    


<h5> Output files </h5>
<p> propVarPlot.pdf: A scatterplot of the Component number vs the Cumulative sum of variance explained (%) </p>




## KLTmaxCorrelation.r 


<h5> Parameters required</h5>
<p> [1...N]: List of N prefixes of *_pc_scores.txt files with principal component scores, obtained after running KLTepigenome.r  </p> 
 

<h5> Example </h5>

    $ Rscript KLTmaxCorrelation.r H3K4me1_mark H3K4me2_mark H3K4me3_mark
    

<h5> Output files </h5>
<p> cor_Scores.csv: matrix with maximum values of pairwise Pearson correlation coefficients between functional principal component scores  </p>
<p> cor_Scores_#Eigenfunctions.csv: order of the eigenfunctions in which the maximum correlation takes place   </p>
<p> cor_Eigenfunctions.csv: Pearson correlation coefficients between the eigenfunctions in cor_Scores_#Eigenfunctions.csv. This value is used to measure the co-localization of the eigenfunctions </p>

# Citation:
Madrigal P, Krajewski P (2015) Uncovering correlated variability in epigenomic datasets using the Karhunen-Loeve transform. **BioData Mining** 8:20. DOI: <a href="10.1186/s13040-015-0051-7"> http://dx.doi.org/10.1186/s13040-015-0051-7 </a> 
