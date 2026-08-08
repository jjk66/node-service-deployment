FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH, Python, sudo, curl, and sysvinit-utils to act as our stable init manager
RUN apt-get update && apt-get install -y \
    openssh-server \
    python3 \
    sudo \
    curl \
    sysvinit-utils \
    && rm -rf /var/lib/apt/lists/*

# Fix SSH service configurations and generate missing host keys
RUN mkdir /var/run/sshd
RUN ssh-keygen -A

# Ensure root login via keys is completely allowed by the daemon
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Setup SSH keys
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22

# Start SSH daemon and use init tail to keep the container permanently running smoothly
CMD /usr/sbin/sshd && tail -f /dev/null
