#!/bin/bash
# SEE http://redsymbol.net/articles/unofficial-bash-strict-mode/

set -euo pipefail
IFS=$'\n\t'
INFO="INFO: [$(basename "$0")] "


# Trust all notebooks in the notebooks folder
echo "$INFO" "trust all notebooks in path..."
find "${NOTEBOOK_BASE_DIR}" -name '*.ipynb' -type f | xargs -I % /bin/bash -c 'jupyter trust % || true'


# Configure
# Prevents notebook to open in separate tab
mkdir -p "$HOME/.jupyter/custom"
cat > "$HOME/.jupyter/custom/custom.js" <<EOF
define(['base/js/namespace'], function(Jupyter){
    Jupyter._target = '_self';
});
EOF

#https://github.com/jupyter/notebook/issues/3130 for delete_to_trash
#https://github.com/nteract/hydrogen/issues/922 for disable_xsrf
cat > .jupyter_config.json <<EOF
{
    "FileCheckpoints": {
        "checkpoint_dir": "/home/jovyan/._ipynb_checkpoints/"
    },
    "KernelSpecManager": {
        "ensure_native_kernel": false
    },
    "Session": {
        "debug": false
    },
    "VoilaConfiguration" : {
        "enable_nbextensions" : true
    },
    "ServerApp": {
        "quit_button": false,
        "extra_static_paths": ["/static"],
        "ip": "0.0.0.0",
        "port": 8888,
        "base_url": "",
        "token": "",
        "open_browser": false,
        "disable_check_xsrf": true,
        "webbrowser_open_new": 0,
        "notebook_dir": "${NOTEBOOK_BASE_DIR}",
        "root_dir": "${NOTEBOOK_BASE_DIR}",
        "preferred_dir": "${NOTEBOOK_BASE_DIR}/workspace/"
    }
}
EOF

set +e
if [ -z "${SPEAG_LICENSE_FILE-}" ]; then
    for SERVER in "${SERVERS[@]}"; do
        echo "Testing ${SERVER}"
        SERVER_FOUND=`nc -z "${SERVER}" "${PORT}"`
        if [ "$?" -eq 0 ]; then
            echo "$INFO License server found at ${SERVER}:${PORT}"
            export SPEAG_LICENSE_FILE="${PORT}"@"${SERVER}"
            break
        else
            echo "$INFO License server NOT found at ${SERVER}:${PORT}"
        fi
    done
fi
set -e

echo "$INFO SPEAG_LICENSE_FILE evaluates to" "${SPEAG_LICENSE_FILE:-}"

if [ "${SC_BOOT_MODE:-0}" = "test-boot-script" ]
then
    echo "$INFO" "Test mode, not starting service, printing env instead"
    echo "$INFO" "$(env)"
    exit 0
fi

#   In the future, we should have a option in the dashboard to configure how jupyter should be
#   initiated (only for the owner of the coresponding study)
VOILA_NOTEBOOK="${NOTEBOOK_BASE_DIR}"/workspace/voila.ipynb

if [ "${DY_BOOT_OPTION_BOOT_MODE}" -ne 0 ]; then
    echo "$INFO" "Found DY_BOOT_OPTION_BOOT_MODE=${DY_BOOT_OPTION_BOOT_MODE}... Trying to start in voila mode"
fi

if [ "${DY_BOOT_OPTION_BOOT_MODE}" -eq 1 ] && [ -f "${VOILA_NOTEBOOK}" ]; then
    echo "$INFO" "Found ${VOILA_NOTEBOOK}... Starting in voila mode"
    voila "${VOILA_NOTEBOOK}" --enable_nbextensions=True --port 8888 --Voila.ip="0.0.0.0" --no-browser
else
    # call the notebook with the basic parameters
    start-notebook.sh --config .jupyter_config.json "$@" --LabApp.default_url='/lab/tree/workspace/README.ipynb'
fi