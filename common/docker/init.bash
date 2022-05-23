#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

INFO="INFO: [init.bash] "

echo "$INFO" "Starting jupyter-smash init.bash"


if [ -x "$(command -v nvidia-smi)" ]; then
    export SEMCADX_CUDA_ADDITIONAL_CARDS=$(nvidia-smi --query-gpu=name --format=csv,noheader -i 0) # -i 0 also works if there is a list
else
    echo "$INFO" "Failed to find nvidia-smi, export SEMCADX_CUDA_ADDITIONAL_CARDS to empty string"
    export SEMCADX_CUDA_ADDITIONAL_CARDS=
fi

export AX_USE_UNSUPPORTED_CARDS=1


echo "$INFO" "AX_USE_UNSUPPORTED_CARDS: $AX_USE_UNSUPPORTED_CARDS"
echo "$INFO" "SEMCADX_CUDA_ADDITIONAL_CARDS: $SEMCADX_CUDA_ADDITIONAL_CARDS"