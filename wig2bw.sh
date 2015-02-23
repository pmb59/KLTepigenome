#!/bin/bash

#convert all wig files to bw

#get chrom.sizes information
wget http://genome.ucsc.edu/goldenpath/help/hg19.chrom.sizes

n=$(ls *.wig | sed -e 's/\..*$//')

for FILE in $(echo $n) ; do
wigToBigWig ${FILE}.wig hg19.chrom.sizes ${FILE}.bw
done
