#!/bin/bash

# Install Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create necessary directories
sudo mkdir -p /etc/gitlab/config
sudo mkdir -p /etc/gitlab/logs
sudo mkdir -p /etc/gitlab/data

# Create Docker Compose file
cat <<EOL > docker-compose.yml
version: '3'

services:
  gitlab:
    image: gitlab/gitlab-ee:latest  # You can use gitlab/gitlab-ce:latest for the Community Edition
    container_name: "st12-gitlab"
    restart: always
    hostname: "st12.sne.com"
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://10.1.1.202'
        gitlab_rails['gitlab_shell_ssh_port'] = 22
    ports:
      - "80:80"
      - "2222:22"
    volumes:
      - "/srv/gitlab/config:/etc/gitlab"
      - "/srv/gitlab/logs:/var/log/gitlab"
      - "/srv/gitlab/data:/var/opt/gitlab"
EOL

# Run Docker Compose
sudo docker-compose up -d

