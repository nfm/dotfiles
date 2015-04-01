#!/usr/bin/env bash


function _chpy_bin_path {
    echo "${PYTHONS_DIR}/${CURRENT_CHPY_VERSION}/bin"
}

function chpy {
    PYTHONS_DIR="${HOME}/.pythons"

    NEW_CHPY_VERSION=$1
    if [[ "${NEW_CHPY_VERSION}" != "" && $(_installed_pythons) =~ ${NEW_CHPY_VERSION} ]]
    then
        mkdir -p ${PYTHONS_DIR}/chpy
        CURRENT_CHPY_FILE=${HOME}/.pythons/chpy/current

        if [ -e ${CURRENT_CHPY_FILE} ]
        then
            CURRENT_CHPY_VERSION=$(cat ${CURRENT_CHPY_FILE})
            PATH=$(echo $PATH | sed 's^'$(_chpy_bin_path):'^^g')
        fi

        CURRENT_CHPY_VERSION="${NEW_CHPY_VERSION}"
        echo "${CURRENT_CHPY_VERSION}" > "$CURRENT_CHPY_FILE"
        export PATH=$(_chpy_bin_path):${PATH}
        return 0
    else
        echo "Unavailable Python"
        echo "Installed Pythons:" $(_installed_pythons)
        _current_python
        return 1
    fi
}

function _installed_pythons {
    echo $(find ${PYTHONS_DIR} -maxdepth 1 -type d  | sed 's/.*pythons\///g' |  grep '[0-9].[0-9].[0-9]' | sort)
}

function _current_python {
    echo "Current Python is $(which python)"
}

function chpy-install {

    VERSION=$1
    PYTHONS_DIR=~/.pythons
    CURRENT_DIR=$(pwd)
    DOWNLOAD_URL="https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz"
    if [[ "${VERSION}" == "" ]]
    then
        echo "Please provide a Python version to install"
        return 1
    else
        TEST=$(curl -s --head ${DOWNLOAD_URL})
        if [[ "${TEST}" =~ "200 OK" ]]
        then
            # Download Python version
            curl -o /tmp/python-${VERSION}.tgz https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz

            # Install Python
            tar -xvzf /tmp/python-${VERSION}.tgz -C /tmp
            cd /tmp/Python-${VERSION}/
            ./configure --prefix ${PYTHONS_DIR}/${VERSION}
            make
            make install
            cd ${CURRENT_DIR}

            # Install Pip
            curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
            ${PYTHONS_DIR}/${VERSION}/bin/python /tmp/get-pip.py

            # Install virtualenv
            ${PYTHONS_DIR}/${VERSION}/bin/pip install virtualenv
            return 0
        else
            echo "Unavailable Python version"
            return 2
        fi
    fi
}
