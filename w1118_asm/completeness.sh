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

