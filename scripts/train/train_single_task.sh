#!/bin/bash
set -e


DISP=False
DEBUG=0
JUNO1=1
JUNO2=0


function run_cmd {
    echo ""
    echo ${CMD}
    if [[ ${DEBUG} == 0 ]]; then
        if [[ `hostname` == "sc.stanford.edu" ]]; then
            if [[ ${JUNO1} == 1 ]]; then
                sbatch scripts/slurm/juno1.sh "${CMD}"
            elif [[ ${JUNO2} == 1 ]]; then
                sbatch scripts/slurm/juno2.sh "${CMD}"
            else
                sbatch scripts/slurm/juno.sh "${CMD}"
            fi
        else
            eval ${CMD}
        fi
    fi
}


function train_cliport_single_task {
    for task in "${TASKS[@]}"; do
        for seed in "${SEEDS[@]}"; do
            for n_demos in "${N_DEMOS[@]}"; do
                CMD="python cliport/${script}.py train.task=${task} train.agent=cliport date=${date} seed=${seed}"
                CMD="${CMD} train.attn_stream_fusion_type=add train.trans_stream_fusion_type=conv train.lang_fusion_type=mult"
                CMD="${CMD} train.n_demos=${n_demos} train.n_steps=${train_steps} train.data_dir=$(pwd)/${data_dir}/${data_date}"
                CMD="${CMD} dataset.augment.theta_sigma=${augment} dataset.cache=${cache}"
                run_cmd
            done
        done
    done
}


# Setup.
date="1207"
script="train"
data_date="1201"
data_dir="data_custom"

# Tasks.
TASKS=(
    "packing-boxes-pairs-seen-colors"
    "packing-boxes-pairs-unseen-colors"
    "packing-seen-google-objects-group"
    "packing-unseen-google-objects-group"
    "put-block-in-bowl-seen-colors"
    "put-block-in-bowl-unseen-colors"    
)
SEEDS=(0)
N_DEMOS=(1000)

# Experiment.
cache=False
augment=0.0
train_steps=201000
train_cliport_single_task