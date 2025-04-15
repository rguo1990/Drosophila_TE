#!/bin/bash

## Specify the job name
#SBATCH --job-name=target

## account to charge
#SBATCH -A grylee_lab 

# Define nodes tasks and cpu_per_task
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=16    ## number of cores the job needs

## Specify which queues you want to submit the jobs too
#SBATCH -p free

# Specify where standard output and error are stored
#SBATCH --error=target.err
#SBATCH --output=target.out

# Pass the current environment variables
#SBATCH --export=ALL

# Go to current working directory 
#SBATCH --chdir=.

## LOAD MODULES or ENVIRONMENTS  ##

## the script is used to extract the target sequence (1-1 match) from the curated library of Drosophila melanogaster
## for multiple target sequences, only the first one is considered

cd /dfs7/grylee/rongg7/Keto/hts.igb.uci.edu/

for folder in P*
do
        echo $folder
        cd ${folder}
        mkdir target
        sed 's/:.*//' P*.insertion.bed | awk '{print $4}' > target.bed

        N=0
        cat target.bed | while read LINE; do
                echo $LINE
                N=$((N+1))
                grep -A1 -w $LINE ~/Keto/TEMP2/transposon/D_mel_transposon_sequence_set_oneline.fa > target/${LINE}.${N}.fa 
        done
        cd /dfs7/grylee/rongg7/Keto/hts.igb.uci.edu/
done
