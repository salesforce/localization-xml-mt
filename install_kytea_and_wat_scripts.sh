#!/bin/sh

mkdir tools
cd tools
SCRIPT_DIR=$(cd $(dirname $0); pwd)

git clone https://github.com/hassyGo/WAT-scripts.git

mkdir kytea_models
cd kytea_models

wget http://www.phontron.com/kytea/download/model/jp-0.4.2-utf8-1.mod.gz
gunzip jp-0.4.2-utf8-1.mod.gz

wget http://www.phontron.com/kytea/download/model/msr-0.4.0-1.mod.gz
gunzip msr-0.4.0-1.mod.gz

cd ..

wget http://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz
tar zxvf kytea-0.4.7.tar.gz
cd kytea-0.4.7
./configure --prefix=${SCRIPT_DIR}/local
make -j
make install
