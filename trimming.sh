#!/bin/bash

## Specify the job name
#SBATCH --job-name=trimming

## account to charge
#SBATCH -A grylee_lab 

# Define nodes tasks and cpu_per_task
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=16    ## number of cores the job needs

## Specify which queues you want to submit the jobs too
#SBATCH -p free

# Specify where standard output and error are stored
#SBATCH --error=trim.err
#SBATCH --output=trim.out

# Pass the current environment variables
#SBATCH --export=ALL

# Go to current working directory 
#SBATCH --chdir=.

## LOAD MODULES or ENVIRONMENTS  ##
module load cutadapt/2.10

source /opt/apps/miniconda3/23.5.2/etc/profile.d/conda.sh
conda activate fastx_toolkit
cd /dfs7/grylee/rongg7/Keto/hts.igb.uci.edu/merged
for sample in *P[0-1][0,7-9][0-9]*-READ1-All.txt
do
        echo $sample
        describer=$(echo ${sample} | sed 's/-READ1-All.txt//')
        echo $describer

        ## fastx_trimmer: cut the first 15 bp
        fastx_trimmer -i ${describer}-READ1-All.txt -o trimming/${describer}-READ1-cut.fq -f 16
        fastx_trimmer -i ${describer}-READ2-All.txt -o trimming/${describer}-READ2-cut.fq -f 16 
        ## Nextera adapter trimming
        cutadapt -a CTGTCTCTTATACACATCT -A AGATGTGTATAAGAGACAG -o trimming/${describer}-READ1-trim.tmp.fq  -p trimming/${describer}-READ2-trim.tmp.fq trimming/${describer}-READ1-cut.fq trimming/${describer}-READ2-cut.fq --minimum-length 100 --maximum-length 160 -q 20
        cutadapt -a AGATGTGTATAAGAGACAG -A CTGTCTCTTATACACATCT -o trimming/${describer}-READ1-trim.fq -p trimming/${describer}-READ2-trim.fq trimming/${describer}-READ1-trim.tmp.fq trimming/${describer}-READ2-trim.tmp.fq --minimum-length 100 --maximum-length 160 -q 20
done

## need to re-run fastqc to see the improvement
