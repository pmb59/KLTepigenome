#!/bin/bash

for sample in $(seq 1 73) ; do

Rscript KLTepigenome.r $sample

done
