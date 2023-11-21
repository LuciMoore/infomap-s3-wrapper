#!/bin/bash -l
#SBATCH -J SyncTM
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -c 2
#SBATCH --mem=180G
#SBATCH --tmp=100gb
#SBATCH -t 72:00:00
#SBATCH -p amd512,amdsmall,amdlarge,ram256g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lmoore@umn.edu
#SBATCH -o output_logs/syncTM_%A_%a.out
#SBATCH -e output_logs/syncTM_%A_%a.err
#SBATCH -A faird

cd run_files.syncTM

module load matlab/R2019a

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
