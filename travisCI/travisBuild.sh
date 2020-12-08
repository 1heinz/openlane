#!/bin/bash
# Copyright 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
mkdir pdks
export PDK_ROOT=$(pwd)/pdks
export RUN_ROOT=$(pwd)
export IMAGE_NAME=openlane:rc6
export STD_CELL_LIBRARY=sky130_fd_sc_hd
export SPECIAL_VOLTAGE_LIBRARY=sky130_fd_sc_hvl
export IO_LIBRARY=sky130_fd_io
echo $PDK_ROOT
echo $RUN_ROOT
make openlane
cd  $PDK_ROOT
cnt=0
until rm -rf skywater-pdk; do
	cnt=$((cnt+1))
	if [ $cnt -eq 5 ]; then
		exit 2
	fi
	git clone https://github.com/google/skywater-pdk.git skywater-pdk
	cd $PDK_ROOT/skywater-pdk
	git submodule update --init libraries/$STD_CELL_LIBRARY/latest
	git submodule update --init libraries/$IO_LIBRARY/latest
	git submodule update --init libraries/$SPECIAL_VOLTAGE_LIBRARY/latest
	make -j$(nproc) timing
done
cd  $PDK_ROOT
rm -rf open_pdks
git clone https://github.com/RTimothyEdwards/open_pdks.git open_pdks
cd $RUN_ROOT
docker run -it -v $RUN_ROOT:/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) $IMAGE_NAME bash -c "make build-pdk"
echo "done installing"
cd $RUN_ROOT
exit 0