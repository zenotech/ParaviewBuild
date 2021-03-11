#!/bin/bash
cmake3 -DENABLE_boost=ON -DENABLE_embree=ON -DENABLE_hdf5=ON -DENABLE_mesa=ON -DENABLE_ospray=ON -DENABLE_ospraymaterials=ON -DENABLE_paraview=ON -DENABLE_python3=ON -DENABLE_qt5=ON -Dparaview_SOURCE_SELECTION=source -Dparaview_SOURCE_DIR=/home/dev/ParaView -DPARAVIEW_BUILD_EDITION=CANONICAL /home/dev/paraview-superbuild
