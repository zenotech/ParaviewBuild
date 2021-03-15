#!/bin/bash

git clone git@github.com:zenotech/paraview-superbuild.git
cd paraview-superbuild; git submodule update --init --recursive; cd ..
git clone git@github.com:zenotech/ParaView.git
cd ParaView; git checkout pv590; git submodule update --init --recursive; cd ..
git clone git@github.com:zCFD/zCFDReader.git
git clone git@github.com:zenotech/hdf5.git
mkdir paraview_build

# Build container
DOCKER_BUILDKIT=1 docker build . -t paraviewclient/centos
MAP_PASSGRP=" " DEFAULT_USER="dev" HOME_MNT=`pwd` ./dev.sh
cd paraview_build
../config.sh
make -j40
ctest3 -R cpack-paraview-TGZ
cd ..

# Build reader
cd zCFDReader
mkdir build
cd build
cmake3 -DCMAKE_INSTALL_PREFIX=install -DHDF5_DIR=/home/dev/paraview_build/install/share/cmake/hdf5 -DParaView_DIR=/home/dev/paraview_build/install/lib/cmake/paraview-5.9 -DCMAKE_CXX_FLAGS="-I/home/dev -I/home/dev/paraview_build/install/include/python3.8" -DBoost_INCLUDE_DIR=/home/dev/paraview_build/install/include -DBoost_LIBRARY_DIR_RELEASE=/home/dev/paraview_build/install/lib -DBoost_PYTHON_LIBRARY_RELEASE=/home/dev/paraview_build/install/lib/libboost_python38.so.1.71.0
make -j40
make install
cd ../..

# Copy reader plugin and libboost* in paraview tarball
cp install/lib/libboost_* _CPack_Packages/Linux/TGZ/ParaView-5.9.0-11-g653d209-Linux-Python3.8-64bit/lib/
cp -r ../zCFDReader/build/install/bin/plugins _CPack_Packages/Linux/TGZ/ParaView-5.9.0-11-g653d209-Linux-Python3.8-64bit/bin/
mkdir _CPack_Packages/Linux/TGZ/ParaView-5.9.0-11-g653d209-Linux-Python3.8-64bit/lib/mesa
mv _CPack_Packages/Linux/TGZ/ParaView-5.9.0-11-g653d209-Linux-Python3.8-64bit/lib/libGL.so* _CPack_Packages/Linux/TGZ/ParaView-5.9.0-11-g653d209-Linux-Python3.8-64bit/lib/mesa/
cd _CPack_Packages/Linux/TGZ/
tar czvf ../../../ParaView-5.9.0-11-g653d209-Linux-Python3.8-64bit.tar.gz ParaView-5.9.0-11-g653d209-Linux-Python3.8-64bit
# Move lib/libGL.* to use hardware rendering
