#!/bin/bash

for sample in H3K27ac H2AK5ac H3K18ac H3K4me2 H2BK120ac H2BK12ac H2BK15ac H2BK20ac H2BK5ac H3K23me2 H3K4ac H3K56ac H3K79me1 H3K79me2 H4K20me1 H4K5ac H4K91ac H3K14ac H3K23ac H4K8ac H2A.Z H3K4me1 H3K4me3 H3K36me3 H3K27me3 H3K9ac H3K9me3; do
  for genes in pc nc rb intronic; do

    Rscript KLTepigenome.r ${sample}_H1_norm.bw tss_hg19.${genes}.bed 5000 100 T T ${sample}_H1_${genes} 50 5 100

  done
done
