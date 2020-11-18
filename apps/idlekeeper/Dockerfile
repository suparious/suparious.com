# The official install talks about Fedora packages, so let's see
# if Centos is close enough...
FROM centos:7

# We will need Git to pull the repo
RUN yum -y -q install wget

# The packages mentioned in the INSTALL phase, except:
# jansson-devel - We're going to build our own since the version 2.4.x doesn't have json_array_foreach
# make - Added it because Centos doesn't have it even after getting autoconf/automake
#RUN yum -y -q install gcc gcc-c++ make wget autoconf automake install openssl-devel libcurl-devel zlib-devel

# Create a user to do the build
ENV BUILD_FOLDER=/minerbuild
ENV APP_FOLDER=/app
ENV APP_USER=minerbuilder
ENV TREX_VERSION=0.18.9
ENV CUDA_VERSION=10.0

RUN adduser $APP_USER && \
    mkdir $BUILD_FOLDER && \
    chown $APP_USER.users $BUILD_FOLDER

# Now switch to the builder and check out the git repo
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

# Switch to a multistage build with the runtime image
FROM nvidia/cuda:10.2-runtime-centos7

# Redefine the app user and folder - note app folder must be the same as the first stage
ENV APP_FOLDER=/app
ENV APP_USER=miner

# Copy the stuff that we built
COPY --from=0 $APP_FOLDER $APP_FOLDER
COPY --from=0 /usr/local/lib /usr/local/lib

# Get the non-devel versions of the libraries that we need
RUN yum -y -q install openssl libcurl zlib libgomp &&  \
    yum clean all && \
    rm -rf /var/cache/yum

# Load the Jansson library that's now built
RUN echo /usr/local/lib > /etc/ld.so.conf.d/userlocal.conf && \
    ldconfig

# Copy the rendering configuration
COPY config $APP_FOLDER

# Symlink the app to /usr/local/bin
RUN ln -s $APP_FOLDER/t-rex /usr/local/bin/t-rex && \
    chown -R root.root $APP_FOLDER

# Recreate and switch to the app user for this build
RUN adduser $APP_USER
USER $APP_USER



CMD [ "t-rex", "-c", "config" ]