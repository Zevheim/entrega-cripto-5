FROM ubuntu:22.10

RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu/http:\/\/old-releases.ubuntu.com\/ubuntu/' /etc/apt/sources.list
RUN sed -i '/^deb.*security.ubuntu.com/s/^/#/' /etc/apt/sources.list

RUN apt update && apt install -y sudo net-tools openssh-client openssh-server tshark

# Create user 'prueba' with password 'prueba'
RUN useradd -m -s /bin/bash prueba && echo "prueba:prueba" | chpasswd && usermod -aG sudo prueba

# Ensure SSH directory exists and has the correct permissions
RUN mkdir -p /var/run/sshd && chmod 0755 /var/run/sshd

# Allow password authentication (optional, usually not recommended)
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start the SSH service
CMD ["/usr/sbin/sshd", "-D"]
