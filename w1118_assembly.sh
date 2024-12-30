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
#SBATCH -A rongg7      ## CHANGE account to charge 
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

