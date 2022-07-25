FROM simcore/services/dynamic/common:0.0.0 as service-base

LABEL maintainer="Andrei Neagu <neagu@itis.swiss>"

COPY --chown=$NB_UID:$NB_GID requirements.txt ${NOTEBOOK_BASE_DIR}/requirements.txt
COPY --chown=$NB_UID:$NB_GID CHANGELOG.md ${NOTEBOOK_BASE_DIR}/CHANGELOG.md

# Change to NB_USER, otherwise packages installed below will belong to root
USER $NB_USER
## TODO: ensure is up-to-date before copying it
RUN $HOME/.pyenv/versions/lab-venv/bin/pip --no-cache install \
    -r ${NOTEBOOK_BASE_DIR}/requirements.txt

USER root