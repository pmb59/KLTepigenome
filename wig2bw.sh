#!/bin/bash

#convert all .wig.gz files in the current directory to bigWig (.bw) format

gunzip *.wig.gz

#get chrom.sizes information
wget http://genome.ucsc.edu/goldenpath/help/hg19.chrom.sizes

n=$(ls *.wig | sed -e 's/\..*$//')

for FILE in $(echo $n) ; do
wigToBigWig ${FILE}.wig hg19.chrom.sizes ${FILE}.bw
done
