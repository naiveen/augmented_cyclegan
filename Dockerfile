# MAINTAINER Perouz Taslakian <perouz@elementai.com>

# Use TensorFlow 1.3.0-RC0 on Python 3
# Visit https://hub.docker.com/r/tensorflow/tensorflow/tags/
# to see available version.

ARG HYPHEN_GPU=-gpu
FROM tensorflow/tensorflow:1.8.0${HYPHEN_GPU}-py3
# FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# Set the working directory to `/eai/project`.
WORKDIR /eai/project
# Set the HOME environment variable.
ENV HOME /eai/project

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
        # Install git to be able to find the current commit and things like
        # that in scripts.
        git \
        # Keras OCR example
        libcairo2 \
        python3-tk \
        libffi-dev \
        python3-pil \
        wget \
        python \
        # allows setting the locale to UTF-8
        locales \
        vim \
        curl grep sed dpkg \
        zip unzip \
    && rm -rf /var/lib/apt/lists/*


# Set the Conda environment 
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --no-check-certificate --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash $HOME/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm $HOME/Miniconda3-latest-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH

# Add Python dependencies files and install them.
# NOTE: These lines need to be placed _after_ the `apt-get` call since the
#       dependencies listed in those files might themselves depend on some
#       distribution's own packages.
# NOTE: At this point, the working directory (`WORKDIR`) is set to `/eai/project`, which
#       is empty. Copy the dependencies files to it before calling `pip`.
COPY requirements.txt /eai/project/
COPY setup.py /eai/project/
# Install dependencies
RUN pip install --upgrade pip
RUN pip install --requirement requirements.txt 

# Set the locale to UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
