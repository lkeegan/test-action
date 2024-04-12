#!/bin/bash

# bash script to install static libs on CI
# usage: ./getlibs.sh [SME_DEPS_VERSION]

set -e -x

SME_DEPS_VERSION=$1

if [[ "$RUNNER_OS" == "Linux" ]]; then
    OS=linux
elif [[ "$RUNNER_OS" == "macOS" ]]; then
    OS=osx
elif [[ "$RUNNER_OS" == "Windows" ]]; then
    OS=win64
else
    echo "RUNNER_OS $RUNNER_OS not supported"
    return 1
fi

if [[ "$SME_DEPS_VERSION" == "" ]]; then
    echo "Downloading latest sme_deps for ${RUNNER_OS}"
    wget "https://github.com/spatial-model-editor/sme_deps/releases/latest/download/sme_deps_${OS}.tgz"    
else
    echo "Downloading sme_deps ${SME_DEPS_VERSION} for ${RUNNER_OS}"
    wget "https://github.com/spatial-model-editor/sme_deps/releases/download/${SME_DEPS_VERSION}/sme_deps_${OS}.tgz"
fi

tar xf sme_deps_"$OS".tgz
# copy libs to desired location: workaround for tar -C / not working on msys
if [[ "$RUNNER_OS" == "Windows" ]]; then
    mv c/smelibs /c/
else
    mv opt/* /opt/
fi
rm -f sme_deps_"$OS".tgz