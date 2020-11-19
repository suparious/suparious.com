# The official install talks about Fedora packages, so let's see
# if Centos is close enough...
FROM centos:8

# Setup nvidia repo gpg key
RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict  -

COPY cuda.repo /etc/yum.repos.d/cuda.repo

ENV CUDA_VERSION 10.2.89
ENV CUDA_PKG_VERSION 10-2-$CUDA_VERSION-1

RUN yum upgrade -y && yum install -y \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-2 \
    && ln -s cuda-10.2 /usr/local/cuda \
    && yum clean all \
    && rm -rf /var/cache/yum/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441"

# We will need Git to pull the repo
RUN yum -y -q install wget redhat-lsb-core

# Create a user to do the build
ENV BUILD_FOLDER=/build
ENV APP_FOLDER=/app
ENV APP_USER=mlgpu
ENV TREX_VERSION=0.18.9
ENV CUDA_VERSION=10.0

# Now switch to the app user and check out the git repo
USER $APP_USER

# Clone from the git repo
RUN cd $BUILD_FOLDER && \
    wget https://github.com/trexminer/T-Rex/releases/download/"$TREX_VERSION"/t-rex-"$TREX_VERSION"-linux-cuda"$CUDA_VERSION".tar.gz && \
    tar xzvf t-rex-$TREX_VERSION-linux-cuda"$CUDA_VERSION".tar.gz

ENV TREX_FOLDER=$BUILD_FOLDER

# Copy the binary to the /app folder

USER root

RUN mkdir $APP_FOLDER && \
    chown $APP_USER.users $APP_FOLDER && \
    cp $TREX_FOLDER/t-rex $APP_FOLDER

# Get the non-devel versions of the libraries that we need
RUN yum -y -q install openssl zlib libgomp &&  \
    yum clean all && \
    rm -rf /var/cache/yum

# Copy the rendering configuration
COPY config $APP_FOLDER

# Symlink the app to /usr/local/bin
RUN ln -s $APP_FOLDER/t-rex /usr/local/bin/t-rex && \
    chown -R root.root $APP_FOLDER

# Recreate and switch to the app user for this build
RUN adduser $APP_USER
USER $APP_USER

CMD [ "t-rex", "-c", "config" ]
