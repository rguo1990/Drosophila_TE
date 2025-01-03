## The raw HiFi reads are saved as: ~/Drosophila_genomes/w1118/demultiplex.bc1017--bc1017.hifi_reads_fastq

## Assembler: Hifiasm
## Filter criteria: reads should be longer than 6kb
## Filtering was done by cutadapt:
cutadapt -m 6000 -o ../w1118.filter.fastq demultiplex.bc1017--bc1017.hifi_reads_fastq

## The script used to run Hifiasm:
## Two options: with filtering or not

## With FILTERING:
#!/bin/bash

#SBATCH --job-name=hifiasm       ## Name of the job.
#SBATCH -A grylee_lab      ## CHANGE account to charge 
#SBATCH -p free               ## partition name
#SBATCH --nodes=1             ## (-N) number of nodes to use
#SBATCH --ntasks=1            ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=10     ## number of cores the job needs
#SBATCH --error=slurm-%J.err  ## error log file
#SBATCH --output=slurm-%J.out ## output log file

hifiasm -o w1118.filter.asm -t32 --write-ec ../w1118.filter.fastq 2>w1118.filter.asm.log

## Without FILTERING:
hifiasm -o w1118.asm -t32 --write-ec demultiplex.bc1017--bc1017.hifi_reads.fastq 2>w1118.asm.log

## saved in: ~/Drosophila_genomes/w1118

## the statistics of the primary contigs:
## stats for /data/homezvol0/rongg7/Drosophila_genomes/w1118/w1118.asm.fasta
## sum = 164268009, n = 193, ave = 851129.58, largest = 27963721
## N50 = 21563735, n = 4
## N60 = 15399632, n = 5
## N70 = 7362488, n = 6
## N80 = 1299991, n = 13
## N90 = 429469, n = 32
## N100 = 18114, n = 193
## N_count = 0
## Gaps = 0

## stats for /data/homezvol0/rongg7/Drosophila_genomes/w1118/w1118.filter.asm.fasta
## sum = 164601684, n = 206, ave = 799037.30, largest = 27963719
## N50 = 21563737, n = 4
## N60 = 15399646, n = 5
## N70 = 7362488, n = 6
## N80 = 1230914, n = 14
## N90 = 383150, n = 35
## N100 = 18385, n = 206
## N_count = 0
## Gaps = 0

## If only considering the stats, it looks better when we don't filter the raw reads, so we will take w1118.asm.fasta for future analysis.

## Next, we did some filtering using GenomeFLTR (Dotan et al, 2023). Align the scaffolds against NCBI nr database, 
## and filter out those mapped scaffolds with Kraken standard, (i.e. all complete bacterial, archeal, and viral genomes in Refseq)
## The filtered 149 scaffolds were saved as: ~/Drosophila_genomes/w1118/assemblies/FilteredResults.fasta

## Then, we performed reference-assisted assembly using RagTag.
## install with conda (under environment ragtag_envs)
## conda install -c bioconda ragtag

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

## The completeness of the w1118 assembly was measured using compleasm



