FROM ubuntu:22.04

# Install SSH server, Python (required for Ansible), and curl/sudo utilities
RUN apt-get update && apt-get install -y openssh-server python3 sudo curl && \
    mkdir /var/run/sshd

# Set root password to 'rootpassword' for Ansible authentication
RUN echo 'root:rootpassword' | chpasswd

# Permit root login over SSH configuration
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH network port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
