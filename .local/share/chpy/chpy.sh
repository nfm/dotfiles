#!/usr/bin/env bash

function chpy_bin_path {
    echo "${PYTHONS_DIR}/${CURRENT_CHPY_VERSION}/bin"
}

function chpy {
    NEW_CHPY_VERSION=$1
    PYTHONS_DIR="${HOME}/.pythons"
    CURRENT_CHPY_FILE=${HOME}/.pythons/chpy/current

    if [ -e ${CURRENT_CHPY_FILE} ]
    then
        CURRENT_CHPY_VERSION=$(cat ${CURRENT_CHPY_FILE})
        PATH=$(echo $PATH | sed 's^'$(chpy_bin_path):'^^g')
    fi

    CURRENT_CHPY_VERSION="${NEW_CHPY_VERSION}"
    echo "${CURRENT_CHPY_VERSION}" > "$CURRENT_CHPY_FILE"
    export PATH=$(chpy_bin_path):${PATH}
}

function chpy_reset {
    # TODO
}
