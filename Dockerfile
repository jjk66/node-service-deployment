FROM ubuntu:22.04

RUN apt-get update && apt-get install -y openssh-server python3 sudo curl && \
    mkdir /var/run/sshd

# Create the root SSH directory
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy your local Mac public key into the container's authorized_keys
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
