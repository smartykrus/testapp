# Use an official Python runtime as a parent image
FROM python:3-alpine3.15

# Set the working directory to /app
WORKDIR /app

# Install required packages including OpenSSH
RUN apk add --no-cache \
    openssh \
    bash \
    && apk add --no-cache --virtual .build-deps gcc musl-dev \
    && apk del .build-deps

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Create a new user 'tirex' with a password 'TIREX123'
RUN adduser -D tirex \
    && echo "tirex:TIREX123" | chpasswd

# Configure SSH
RUN mkdir /run/sshd \
    && sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    # Generate SSH host keys
    && ssh-keygen -A

# Expose ports
EXPOSE 9001
EXPOSE 9002


# Start SSH and Flask in the background
CMD ["/bin/sh", "-c", "/usr/sbin/sshd && python src/app.py"]
