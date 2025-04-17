#!/bin/bash

## Specify the job name
#SBATCH --job-name=extract_reads

## account to charge
#SBATCH -A grylee_lab 

# Define nodes tasks and cpu_per_task
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=32    ## number of cores the job needs

## Specify which queues you want to submit the jobs too
#SBATCH -p standard

# Specify where standard output and error are stored
#SBATCH --error=extract_reads.err
#SBATCH --output=extract_reads.out

# Pass the current environment variables
#SBATCH --export=ALL

# Go to current working directory 
#SBATCH --chdir=.

## LOAD MODULES or ENVIRONMENTS  ##

## the script is used to extract reads (fastq) mapped to the TE regions, (from sam file) 
## and locally assembled them by SPAdes assembler

module load samtools/1.10

cd /dfs7/grylee/rongg7/Keto/hts.igb.uci.edu/
for folder in P0[7-9]*
do
        echo $folder
        cd ${folder} 
        mkdir bedfiles
        cd bedfiles
        sed -i '/^#/d' ../P*.insertion.bed
        split ../P*.insertion.bed -l 1 -d -a 4
        for sample in x*
        do 
                samtools view -L ${sample} ../P*.sorted.bam > ${sample}.sam
                awk '{print $1}' ${sample}.sam > ${sample}.reads
                grep -A 3 --no-group-separator -f ${sample}.reads ../../merged/trimming/*${folder}-READ1-trim.fq > ${sample}_1.fq
                grep -A 3 --no-group-separator -f ${sample}.reads ../../merged/trimming/*${folder}-READ2-trim.fq > ${sample}_2.fq
                ## sed -n '1~5s/^@/>/p;2~5p' ${sample}_1.fq > ${sample}_1.fa
                ## sed -n '1~5s/^@/>/p;2~5p' ${sample}_2.fq > ${sample}_2.fa
                python /data/homezvol0/rongg7/Keto/SPAdes-4.1.0-Linux/bin/spades.py -1 ${sample}_1.fq -2 ${sample}_2.fq -o ${sample}_spades -t 48
        done
        cd ../../  
done
