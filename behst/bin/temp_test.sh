#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#
set -o nounset -o pipefail -o errexit
set -o xtrace

sh script_multi_project_run_input_parameters.sh "../data/pressto_PANCREAS_enhancers_SHUFFLED.bed" -1 -1 -1

# returned 0 genes

sh script_multi_project_run_input_parameters.sh "../data/pressto_STOMACH_enhancers.bed" -1 -1 -1

sh script_multi_project_run_input_parameters.sh "../data/pressto_STOMACH_enhancers_SHUFFLED.bed" -1 -1 -1

sh script_multi_project_run_input_parameters.sh "../data/randomlyShuffledNew_pressto_STOMACH_enhancers.bed" -1 -1 -1