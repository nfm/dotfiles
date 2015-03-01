function chpy_install {

    VERSION=$1
    PYTHONS_DIR=~/.pythons
    CURRENT_DIR=$(pwd)

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
}
