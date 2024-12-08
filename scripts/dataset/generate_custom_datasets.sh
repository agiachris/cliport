#!/bin/bash
set -e


DEBUG=1
DISP=False


function run_cmd {
    echo ""
    echo "${CMD}"
    if [[ ${DEBUG} == 0 ]]; then
        if [[ `hostname` == "sc.stanford.edu" ]] || [[ `hostname` == juno* ]]; then
            sbatch scripts/slurm/juno_cpu_light.sh "${CMD}"
        else
            ${CMD}
        fi
    fi
}


function get_base_cmd {
    CMD="python cliport/${script}.py data_dir=${data_dir} mode=${mode} disp=${DISP}"
    CMD="${CMD} n=${n_demos} task=${task} dataset.augment.theta_sigma=${augment}"
}

# Setup.
date="1207"
script="demos"

# Custom datasets.
data_dir="data_custom/${date}"
augment=0.0

LANG_TASKS='packing-boxes-pairs-seen-colors packing-boxes-pairs-unseen-colors packing-seen-google-objects-group packing-unseen-google-objects-group put-block-in-bowl-seen-colors put-block-in-bowl-unseen-colors'
for task in $LANG_TASKS; do
    # Train split.
    mode="train"; n_demos=1000
    get_base_cmd; run_cmd

    # Validation split.
    mode="val"; n_demos=100
    get_base_cmd; run_cmd

    # Test split.
    mode="test"; n_demos=100
    get_base_cmd; run_cmd
done