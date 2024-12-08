#!/bin/bash
set -e


# Setup.
DEBUG=1
DISP=False
date="1201"


function run_cmd {
    echo ""
    echo "${CMD}"
    if [[ ${DEBUG} == 0 ]]; then
        if [[ `hostname` == "sc.stanford.edu" ]] || [[ `hostname` == juno* ]]; then
            sbatch scripts/slurm/generate_datasets_juno.sh "${CMD}"
        else
            ${CMD}
        fi
    fi
}


### Original CLIPort datasets.
DATA_DIR="data"

# Language-Conditioned Tasks
LANG_TASKS='align-rope assembling-kits-seq-seen-colors assembling-kits-seq-unseen-colors packing-shapes packing-boxes-pairs-seen-colors packing-boxes-pairs-unseen-colors packing-seen-google-objects-seq packing-unseen-google-objects-seq packing-seen-google-objects-group packing-unseen-google-objects-group put-block-in-bowl-seen-colors put-block-in-bowl-unseen-colors stack-block-pyramid-seq-seen-colors stack-block-pyramid-seq-unseen-colors separating-piles-seen-colors separating-piles-unseen-colors towers-of-hanoi-seq-seen-colors towers-of-hanoi-seq-unseen-colors'

for task in $LANG_TASKS
    do
        CMD="python cliport/demos.py n=1000 task=${task} mode=train data_dir=${DATA_DIR} disp=${DISP} date=${date}"
        run_cmd
        CMD="python cliport/demos.py n=100  task=${task} mode=val   data_dir=${DATA_DIR} disp=${DISP} date=${date}"
        run_cmd
        CMD="python cliport/demos.py n=100  task=${task} mode=test  data_dir=${DATA_DIR} disp=${DISP} date=${date}"
        run_cmd
    done
echo "Finished Language Tasks."


# Demo-Conditioned Tasks
DEMO_TASKS='align-box-corner assembling-kits block-insertion manipulating-rope packing-boxes palletizing-boxes place-red-in-green stack-block-pyramid sweeping-piles towers-of-hanoi'

for task in $DEMO_TASKS
    do
        CMD="python cliport/demos.py n=1000 task=${task} mode=train data_dir=${DATA_DIR} disp=${DISP} date=${date}"
        run_cmd
        CMD="python cliport/demos.py n=100  task=${task} mode=val   data_dir=${DATA_DIR} disp=${DISP} date=${date}"
        run_cmd
        CMD="python cliport/demos.py n=100  task=${task} mode=test  data_dir=${DATA_DIR} disp=${DISP} date=${date}"
        run_cmd
    done
echo "Finished Demo Tasks."