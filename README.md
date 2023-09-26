# petalinux-docker

## Usage
Copy petalinux-vYYYY.M-TIME-installer.run file to this folder. Then run:
```
docker build -t petalinux --build-arg PETA_RUN_FILE="$(echo petalinux-*.run)" -t petalinux:latest .
```

After installation, launch petalinux with:
```
docker run -ti --rm --net=host -v /src/project:/home/vivado/projects petalinux:latest
```
