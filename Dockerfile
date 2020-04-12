FROM ubuntu:18.04

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# install GLX-Gears
RUN apt-get update && apt-get install -y --no-install-recommends mesa-utils x11-apps && rm -rf /var/lib/apt/lists/*

# install useful tool
RUN apt-get update && apt-get install -y git vim

COPY ./assets/bashrc /root/.bashrc
COPY ./assets/inputrc /root/.inputrc

WORKDIR /home
