docker run -ti --rm -e DISPLAY=$DISPLAY --net="host" -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/vivado/.Xauthority -v /media/data/peta:/home/vivado/projects petalinux:2022.2 /bin/bash