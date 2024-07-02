FROM ubuntu:18.10

# Esto permite usar repositorios viejos
RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y openssh-client
RUN echo 'root:prueba' | chpasswd
RUN mkdir /var/run/sshd