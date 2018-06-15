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

RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
        # The base TensorFlow image already comes with Python 3.5, but
        # we want 3.6, therefore install it.
        python3.6 \
        python3.6-dev \
        # Install git to be able to find the current commit and things like
        # that in scripts.
        git \
        # Keras OCR example
        libcairo2 \
        python3.6-tk \
        libffi-dev \
        # ImageMagick
        libmagickwand-dev \
        python3-pil \
        wget \
        # allows setting the locale to UTF-8
        locales \
        vim \
        curl grep sed dpkg \
        zip unzip \
    && rm -rf /var/lib/apt/lists/*


# Set the Conda environment 
# RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
#    wget --no-check-certificate --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
#    /bin/bash $HOME/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
#    rm $HOME/Miniconda3-latest-Linux-x86_64.sh
#ENV PATH /opt/conda/bin:$PATH


# Install pip3.6
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3.6 get-pip.py && \
    rm get-pip.py

# Reinstall all pip3.5 packages with pip3.6
RUN pip3.5 freeze | pip3.6 install -r /dev/stdin

# Make python3.6 the default python and python3 executable
RUN ln -sf $(which python3.6) $(which python3) \
    && ln -sf $(which python3) $(which python)


# Add Python dependencies files and install them.
# NOTE: These lines need to be placed _after_ the `apt-get` call since the
#       dependencies listed in those files might themselves depend on some
#       distribution's own packages.
# NOTE: At this point, the working directory (`WORKDIR`) is set to `/eai/project`, which
#       is empty. Copy the dependencies files to it before calling `pip`.
COPY requirements.txt /eai/project/
COPY setup.py /eai/project/
# Install dependencies
# RUN pip install --upgrade pip
RUN pip install --requirement requirements.txt 

# Set the locale to UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
