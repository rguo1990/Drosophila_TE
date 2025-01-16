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



## The completeness of the w1118 assembly was measured using compleasm:
## Specify the job name
#SBATCH --job-name=compleasm

## account to charge
#SBATCH -A grylee_lab 

# Define nodes tasks and cpu_per_task
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=16    ## number of cores the job needs

## Specify which queues you want to submit the jobs too
#SBATCH -p standard

# Specify where standard output and error are stored
#SBATCH --error=compleasm.err
#SBATCH --output=compleasm.out

# Pass the current environment variables
#SBATCH --export=ALL

# Go to current working directory 
#SBATCH --chdir=.

## LOAD MODULES or ENVIRONMENTS  ##

source /opt/apps/miniconda3/23.5.2/etc/profile.d/conda.sh
conda activate compleasm
## conda install -c bioconda compleasm

ASM=w1118_ref.fasta
compleasm run -a $ASM -o w1118_compleasm -t 16 -l diptera

## The completeness was measured as below:
## lineage: diptera_odb10
## S:99.73%, 3276
## D:0.24%, 8
## F:0.00%, 0
## I:0.00%, 0
## M:0.03%, 1
## N:3285

## we checked the missing BUSCO: 34597at7147. Kelch repeat type 1.
## in Drosophila melanogaster's reference genome: it's kelch like family member 10, and located on the scaffold unmapped scaffold 8, forward strand.

