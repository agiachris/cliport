#!/bin/bash

#SBATCH --partition=juno --qos=normal
#SBATCH --account=juno
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time="7-0"
#SBATCH --mem=8G
#SBATCH --job-name="cliport_dataset"
#SBATCH --output=logs/juno-%j.out
#SBATCH --mail-user="cagia@stanford.edu"
#SBATCH --mail-type=END,FAIL,REQUEUE

# List out some useful information.
echo "SLURM_JOBID=${SLURM_JOBID}"
echo "SLURM_JOB_NODELIST=${SLURM_JOB_NODELIST}"
echo "SLURM_NNODES=${SLURM_NNODES}"
echo "Working directory: ${SLURM_SUBMIT_DIR}"
echo ""
echo ${1}
echo ""

# Activate conda environment and run command.
export CLIPORT_ROOT="/juno/u/cagia/projects/cliport"
conda activate cliport
eval ${1}
conda deactivate

# Send an email upon completion.
MAIL_SUBJECT="'SLURM Job_id=${SLURM_JOBID} Log'"
MAIL_FILE="$(pwd -P)/logs/juno-${SLURM_JOBID}.out"
MAIL_CMD="mail -s ${MAIL_SUBJECT} cagia@stanford.edu < ${MAIL_FILE}"
~/ssh-bohg-ws-12.py "${MAIL_CMD}"
