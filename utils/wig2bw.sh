#!/bin/bash

#convert all .wig.gz files in the current directory to bigWig (.bw) format

gunzip *.wig.gz

#get chrom sizes information for hg19
wget http://genome.ucsc.edu/goldenpath/help/hg19.chrom.sizes
#get UCSC wigToBigWig for Linux x86 64
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64.v287/wigToBigWig
#get UCSC wigToBigWig for mac OSX x86 64
#wget http://hgdownload.cse.ucsc.edu/admin/exe/macOSX.x86_64/wigToBigWig

n=$(ls *.wig | sed -e 's/\..*$//')

for FILE in $(echo $n) ; do
    wigToBigWig ${FILE}.wig hg19.chrom.sizes ${FILE}.bw
done
