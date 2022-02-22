#!/bin/bash

set -eu -o pipefail

PACKAGE_HOME="${PREFIX}/share/${PKG_NAME}"
mkdir -p "${PREFIX}/bin"
mkdir -p "${PACKAGE_HOME}"


# ASTER dependency setup
git submodule update --init --recursive
(
	cd ASTER
	g++ -std=gnu++11 -march=native -Ofast -pthread astral.cpp -o astral
	g++ -std=gnu++11 -march=native -Ofast -pthread astral-pro.cpp -o astral-pro
)
# https://git.wur.nl/bioinformatics/pantools/-/blob/a96f1dcbd6273ce484c513c42c3bb7c3d8abe119/README.md#building-a-runnable-jar
# this will generate 2 JAR files:
# * 'original-pantools-X.Y.Z.jar'
# * 'pantools-X.Y.Z.jar' <- JAR to package
mvn package

# rename 'pantools-X.Y.Z.jar' to 'pantools.jar'
cp target/pantools-*.jar "${PACKAGE_HOME}/pantools.jar"
cp "${RECIPE_DIR}/pantools.py" ${PREFIX}/bin/pantools
chmod 0755 ${PREFIX}/bin/pantools
