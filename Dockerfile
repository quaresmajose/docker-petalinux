# https://docs.xilinx.com/r/en-US/ug1144-petalinux-tools-reference-guide/Installation-Requirements
FROM ubuntu:22.04

ARG PETA_RUN_FILE

# Use bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# prepare
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
        autoconf \
        automake \
        bash-completion \
        bc \
        bison \
        build-essential \
        chrpath \
        cpio \
        debianutils \
        dbus-x11 \
        diffstat \
        expect \
        flex \
        gawk \
        gcc \
        gcc-multilib \
        git \
        gnupg \
        gzip \
        iproute2 \
        iputils-ping \
        libegl1-mesa \
        libncurses5-dev \
        libsdl1.2-dev \
        libselinux1 \
        libssl-dev \
        libtinfo5 \
        libtool \
        locales \
        lsb-release \
        make \
        nano \
        net-tools \
        pax \
        pylint \
        python3 \
        python3-git \
        python3-jinja2 \
        python3-pexpect \
        python3-pip \
        rsync \
        screen \
        socat \
        sudo \
        tar \
        texinfo \
        tftpd \
        unzip \
        wget \
        xterm \
        xvfb \
        xz-utils \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 && update-locale

# make the vivado user
RUN addgroup --gid 1000 vivado && \
    adduser --disabled-password --firstuid 1000 --gid 1000 --gecos '' vivado && \
    usermod -aG sudo vivado && \
    echo "vivado ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vivado

# run the install
COPY accept-eula.sh ${PETA_RUN_FILE} /
RUN chmod a+rx /${PETA_RUN_FILE} && \
    chmod a+rx /accept-eula.sh && \
    mkdir /opt/Xilinx && \
    chmod 777 /tmp /opt/Xilinx && \
    cd /tmp && \
    sudo -u vivado -i /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
    rm -f /${PETA_RUN_FILE} /accept-eula.sh

# default settings
USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
RUN mkdir /home/vivado/projects
WORKDIR /home/vivado/projects
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/vivado/.bashrc
# fix xsct PATH in /opt/Xilinx/petalinux/settings.sh
RUN echo "PATH=\${XSCT_TOOLCHAIN}/bin:\${PATH}" >> /home/vivado/.bashrc
# fix rlwrap: warning: your $TERM is 'xterm' but rlwrap couldn't find it in the terminfo database. Expect some problems.
RUN echo "export TERMINFO=/lib/terminfo" >> /home/vivado/.bashrc
