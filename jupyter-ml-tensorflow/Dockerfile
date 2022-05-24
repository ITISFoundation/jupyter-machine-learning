FROM simcore/services/dynamic/common:0.0.0 as service-base

LABEL maintainer="Andrei Neagu <neagu@itis.swiss>"

COPY --chown=$NB_UID:$NB_GID requirements.txt ${NOTEBOOK_BASE_DIR}/requirements.txt
COPY --chown=$NB_UID:$NB_GID CHANGELOG.md ${NOTEBOOK_BASE_DIR}/CHANGELOG.md

## TODO: ensure is up-to-date before copying it
RUN $HOME/.pyenv/versions/lab-venv/bin/pip --no-cache install \
    -r ${NOTEBOOK_BASE_DIR}/requirements.txt

USER root

# Fixes issue with missing lib SEE https://stackoverflow.com/q/63199164/2855718
RUN ln -s \
    /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcusolver.so.10 \
    /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcusolver.so.11