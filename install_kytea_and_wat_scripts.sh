# Copyright 2020, Salesforce.com, Inc.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
