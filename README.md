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

<h5> Output: </h5>

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
<h4> FPCcorrelation.r </h5>
</li>

<h5> Parameters required</h5>
<p> [1...N]: List of N *_pc_scores.txt files with principal component scores  </p> 
 

<h5> Example: </h5>

<code>
Rscript FPCcorrelation.r H3K4me1 H3K4me2 H3K4me3
</code>

<h5> Output files: </h5>
<p> 
Understand how to handle big data and improve organizational agility to support demands of a dynamic enterprise. Read our eBook today.

    Post a comment
    Email Article
    Print Article
    Share ArticlesShare articles

How To Change Text Color Using HTML and CSS

By HTMLGoodies Staff

Cascading Style Sheets (CSS) is the preferred method of changing text color, so first we will show the (archival) method of changing text color using inline HTML color codes, then we will move on to how to achieve the same effect using CSS.
Using Text Color (Hex) Codes

In order to change text colors, you will need two things:

1. A command to change the text.
2. A color (hex) code.

The color codes, as I mentioned above, are technically called hex codes. The codes are not very user friendly, so you'll need a chart to tell you what code makes what color. Well, I happen to have one right here: Click to go.

So You Want A Color Code, Huh?

Drop by, grab a six-pack of color code, and come on back.
Old School: Changing Text Colors on the Whole Page

You have the ability to change full-page text colors over four levels:

<TEXT="######"> -- This denotes the full-page text color.

<LINK="######"> -- This denotes the color of the links on your page.

<ALINK="######"> -- This denotes the color the link will flash when clicked upon.

<VLINK="######"> -- This denotes the colors of the links after they have been visited.

These commands come right after the <TITLE> commands. Again, in that position they affect everything on the page. Also... place them all together inside the same command along with any background commands. Something like this:

< BODY BGCOLOR="######" TEXT="######" LINK="######" VLINK="######">

Please note: When you write these codes, you can write them with a # sign in front of the hex code or not. It used to be that the symbol was required, but not any more. I still use it just because I started that way. You may want to just go with the six-digit code. Also make sure to place a space between each command and be sure to enclose it in quotation marks, like so:

<VLINK="#FFFFFF">
Old School: Changing Specific Word Color

But I only want to change one word's color

!

You'll use a color (hex) code to do the trick. Follow this formula:

<FONT COLOR="#800080">tcor_Scores.csv </FONT>: A  </p>
<p> cor_Scores_#Eigenfunctions.csv:  </p>
<p> cor_Eigenfunctions.csv:  </p>


</ul>
