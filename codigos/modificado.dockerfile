FROM ubuntu:22.10

# Change package sources to old-releases.ubuntu.com for unsupported release
RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu/http:\/\/old-releases.ubuntu.com\/ubuntu/' /etc/apt/sources.list
RUN sed -i '/^deb.*security.ubuntu.com/s/^/#/' /etc/apt/sources.list

# Install necessary packages including SSH server and client
RUN apt update && apt install -y sudo net-tools openssh-client openssh-server tshark

# Create a user 'prueba' with password 'prueba'
RUN useradd -m -s /bin/bash prueba && echo "prueba:prueba" | chpasswd && usermod -aG sudo prueba

# Ensure SSH directory exists and has the correct permissions
RUN mkdir -p /var/run/sshd && chmod 0755 /var/run/sshd

# Configure minimal SSH server settings
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN echo "KexAlgorithms diffie-hellman-group1-sha1" >> /etc/ssh/sshd_config
RUN echo "Ciphers 3des-cbc" >> /etc/ssh/sshd_config
RUN echo "MACs hmac-md5" >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
