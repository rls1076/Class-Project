#!/bin/bash

screen

conda activate qiime2-amplicon-2026.1

primer="18s"
projname="Estuaries_${primer}"

## Classifiy
reftax=${reftax:-/home/users/jtm1171/refdbs/18s/SILVA/silva-138-99-tax.qza}
refreads=${refreads:-/home/users/jtm1171/refdbs/18s/SILVA/silva-138-99-seqs-pid_0.65-extracted.qza}
sklearn=${sklearn:-/home/users/jtm1171/refdbs/18s/SILVA/silva-138-99-seqs-pid_0.65-classifier.qza}

## copied from qiime2_parameters.sh
maxaccepts=10
query_cov=0.8 
perc_identity=0.90 
weak_id=0.80
threads=12

Option 1:

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads /tmp/GEN711-811_data/refdbs/silva-138-99-seqs-extract-reads.qza \
  --i-reference-taxonomy /tmp/GEN711-811_data/refdbs/silva-138-99-tax.qza \
  --o-classifier silva-138-99_2022.8_nb-classifier.qza

qiime feature-classifier classify-hybrid-vsearch-sklearn \
  --i-query data/results/${projname}_rep-seqs.qza \
  --i-classifier silva-138-99_2022.8_nb-classifier.qza \
  --i-reference-reads /tmp/GEN711-811_data/refdbs/silva-138-99-seqs-extract-reads.qza \
  --i-reference-taxonomy /tmp/GEN711-811_data/refdbs/silva-138-99-tax.qza \
  --p-threads ${threads} \
  --p-query-cov ${query_cov} \
  --p-perc-identity ${perc_identity} \
  --p-maxrejects all \
  --p-maxaccepts ${maxaccepts} \
  --p-maxhits all \
  --p-min-consensus 0.51 \
  --p-confidence 0.7 \
  --o-classification data/results/${projname}_hybrid_taxonomy

Option 2-original:

qiime feature-classifier classify-hybrid-vsearch-sklearn \
  --i-query data/results/${projname}_rep-seqs.qza \
  --i-classifier ${sklearn} \
  --i-reference-reads ${refreads} \
  --i-reference-taxonomy  ${reftax} \
  --p-threads ${threads} \
  --p-query-cov ${query_cov} \
  --p-perc-identity ${perc_identity} \
  --p-maxrejects all \
  --p-maxaccepts ${maxaccepts} \
  --p-maxhits all \
  --p-min-consensus 0.51 \
  --p-confidence 0.7 \
  --o-classification data/results/${projname}_hybrid_taxonomy