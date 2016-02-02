FROM ubuntu:trusty
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Update existing packages.
RUN apt-get update 

# Ensure UTF-8
RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    export LC_ALL=en_US.UTF-8 && \
    export LANGUAGE=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

# Install packages
RUN DEBIAN_FRONTEND=noninteractive \
    echo exit 0 > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d && \
    apt-get install -y \
        mongodb \
        pwgen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create the database directory    
RUN mkdir -p /data/db

# Add volume for mongodb
VOLUME /data/db

# Add run scripts
COPY run.sh /run.sh
COPY set_mongodb_password.sh /set_mongodb_password.sh
RUN chmod 755 ./*.sh

# Environmental variables
ENV MONGODB_PASS ""

# Expose mongodb port
EXPOSE 27017
EXPOSE 28017

CMD ["/run.sh"]
