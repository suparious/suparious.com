FROM amazonlinux

LABEL version="1.0"
LABEL author="Jay Thomas"
LABEL system="Python 3.6, Amazon AMI 2"
LABEL description="Grid Sort Batch Tools"

ENV cloudwatch=true

ARG env

RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

COPY cuda.repo /etc/yum.repos.d/cuda.repo

ENV CUDA_VERSION 10.2.89
ENV CUDA_PKG_VERSION 10-2-$CUDA_VERSION-1
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a

RUN yum update -y
RUN yum install -y \
            python3.x86_64 \
            libSM-1.2.2-2.amzn2.x86_64 \
            libXrender-0.9.10-1.amzn2.0.2.x86_64 \
            libXext-1.3.3-3.amzn2.0.2.x86_64 \
            python-setuptools \
            postgresql.x86_64 \
            aws-cli \
            util-linux-2.30.2-2.amzn2.0.4.x86_64 \
            gzip \
            cuda-cudart-$CUDA_PKG_VERSION \
            cuda-compat-10-2 \
            libgomp \
            && \
                ln -s cuda-10.2 /usr/local/cuda && \
                rm -rf /var/cache/yum/*

# nvidia-docker 1.0
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV PYTHONPATH /

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"

COPY requirements.txt /opt/requirements.txt

RUN pip3 install --upgrade pip && pip3 install -r /opt/requirements.txt --use-feature=2020-resolver

ARG REDSHIFT_PASSWORD

ENV RUNTIME_ENVIRONMENT=${RUNTIME_ENVIRONMENT:-local}

ENV REDIS_HOST=${REDIS_HOST:-}
ENV REDIS_PORT=${REDIS_PORT}
ENV REDIS_DB=${REDIS_DB}
ENV REDIS_ENCODING=${REDIS_ENCODING}
ENV REDIS_DECODE_RESPONSES=${REDIS_DECODE_RESPONSES}

ENV CLOUDWATCH_LOG_GROUP=${CLOUDWATCH_LOG_GROUP}
ENV CLOUDWATCH_APPLICATION_NAME=${CLOUDWATCH_APPLICATION_NAME}

ENV REDSHIFT_HOST_NAME=${REDSHIFT_HOST_NAME}
ENV REDSHIFT_PORT_NUM=${REDSHIFT_PORT_NUM}
ENV REDSHIFT_DB_NAME=${REDSHIFT_DB_NAME}
ENV REDSHIFT_IAM_ROLE=${REDSHIFT_IAM_ROLE}
ENV REDSHIFT_USER=${REDSHIFT_USER}
ENV REDSHIFT_PASSWORD=${REDSHIFT_PASSWORD}

ENV S3_READ_INVENTORY_BUCKET_NAME=${S3_READ_INVENTORY_BUCKET_NAME}
ENV S3_READ_INVENTORY_KEY=${S3_READ_INVENTORY_KEY}
ENV S3_READ_INVENTORY_INVENTORY_FILE_PREFIX=${S3_READ_INVENTORY_INVENTORY_FILE_PREFIX}
ENV S3_READ_BLACKLIST_BUCKET_NAME=${S3_READ_BLACKLIST_BUCKET_NAME}
ENV S3_READ_BLACKLIST_KEY=${S3_READ_BLACKLIST_KEY}
ENV S3_READ_BLACKLIST_FILE=${S3_READ_BLACKLIST_FILE}
ENV S3_WRITE_BUCKET_NAME=${S3_WRITE_BUCKET_NAME}
ENV S3_WRITE_KEY=${S3_WRITE_KEY}

ENV DIS_RECOV_BUCKET=${DIS_RECOV_BUCKET}

ENV CLOUDWATCH_LOG_GROUP_CLTV=${CLTV_CLOUDWATCH_LOG_GROUP}
ENV SNSARN_CLTV=${CLTV_SNS_ARN}
ENV SLACK_CHANNEL_CLTV=${CLTV_SLACK_CHANNEL}

RUN mkdir /tmp/output

ARG APP_DIR=/recommender
COPY . $APP_DIR

ENV PYTHONPATH $APP_DIR/lib/python3/src
WORKDIR $APP_DIR
CMD ["bash"]

