FROM centos:7

RUN yum groupinstall -y "Development Tools"
RUN yum install -y epel-release
RUN yum install -y cmake3 which sudo
RUN yum install -y mesa-libGL-devel libXrender-devel libxcb-render-devel libxcb-render-util-devel libxkbcommon-devel libxkbcommon-x11-devel libfontconfig libfreetype libXext-devel libxcb-devel libX11-xcb-devel libSM-devel libICE-devel libX11-devel
 
# Setup home environment
RUN useradd -m dev && echo "dev:dev" | chpasswd && mkdir -p /home/dev/BUILD && chown -R dev:dev /home/dev
RUN usermod -aG wheel dev
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#
WORKDIR /home/dev
ENV HOME /home/dev
#
USER dev

