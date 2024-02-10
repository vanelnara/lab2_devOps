#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/n>
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

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
        external_url 'http://st12.sne.com'
        gitlab_rails['gitlab_shell_ssh_port'] = 22
    ports:
      - "80:80"
      - "22:22"
    volumes:
      - "/srv/gitlab/config:/etc/gitlab"
      - "/srv/gitlab/logs:/var/log/gitlab"
      - "/srv/gitlab/data:/var/opt/gitlab"
EOL

# Run Docker Compose
sudo docker-compose up -d

