## We performed reference-assisted assembly using RagTag.
## install with conda (under environment ragtag_envs)
## conda install -c bioconda ragtag

## Drosophila melanogaster reference genome was downloaded from NCBI: GCF_000001215.4
## The 7 chromosomes were extracted manually to make Drosophila_ref.fasta

ragtag.py scaffold ~/Drosophila_ref.fasta ~/Drosophila_genomes/w1118/assemblies/FilteredResult_relabel_geno.chr.fasta -o ~/Drosophila_genomes/Ragout/bin/ragtag_output

head -n 14 ragtag.scaffold.fasta > w1118_ref.fasta
## w1118_ref.fasta is the chromosomal-scale assembly of w1118, and each gap was filled with 100 Ns.

## stats for /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/ragtag_output/ragtag.scaffold.fasta
## sum = 161781792, n = 98, ave = 1650834.61, largest = 34825399
## N50 = 26933598, n = 3
## N60 = 25937454, n = 4
## N70 = 25937454, n = 4
## N80 = 24106939, n = 5
## N90 = 8181268, n = 6
## N100 = 18114, n = 98
## N_count = 5100
## Gaps = 51

## stats for ../../Ragout/bin/ragtag_output/w1118_ref.fasta
## sum = 151137149, n = 7, ave = 21591021.29, largest = 34825399
## N50 = 26933598, n = 3
## N60 = 26933598, n = 3
## N70 = 25937454, n = 4
## N80 = 24106939, n = 5
## N90 = 24106939, n = 5
## N100 = 1867927, n = 7
## N_count = 5100
## Gaps = 51
