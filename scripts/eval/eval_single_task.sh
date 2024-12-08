#!/bin/bash
set -e


DISP=False
DEBUG=1
JUNO1=0
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


function eval_single_task {
    for task in "${TASKS[@]}"; do
        for seed in "${SEEDS[@]}"; do
            for n_demos in "${N_DEMOS[@]}"; do
                CMD="python cliport/${script}.py eval_task=${task} mode=${mode} date=${train_date} seed=${seed}"
                CMD="${CMD} agent=${agent} checkpoint_type=${checkpoint_type} n_demos=${n_demos} train_demos=${train_demos}" 
                CMD="${CMD} exp_folder=${exp_dir} data_dir=$(pwd)/${data_dir}/${data_date} record.save_video=${save_video}"
                run_cmd
            done
        done
    done
}


# Setup.
script="eval"
data_date="1201"
data_dir="data_custom"
train_date="1207"
exp_dir="exps"

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
N_DEMOS=(100)

# CLIPort experiment.
agent="cliport"
train_demos=1000

# Validation experiment.
mode=val
checkpoint_type="val_missing"
save_video=False
eval_single_task

# Test experiment.
mode=test
checkpoint_type="test_best"
save_video=True
eval_single_task