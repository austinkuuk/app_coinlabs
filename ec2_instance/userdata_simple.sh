#!/bin/bash

set -x

# install deps
apt-get update
apt-get install -y docker.io awscli
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# handle condition
if [ -z "${docker_image}" ]; then
  # compose_default_image
  echo "
version: '3'
services:
  wordpress:
    image: wordpress:6-apache
    restart: always
    environment:
      WORDPRESS_DB_HOST: ${db_host}
      WORDPRESS_DB_NAME: ${db_name}
      WORDPRESS_DB_USER: ${db_username}
      WORDPRESS_DB_PASSWORD: ${db_password}
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - '80:80'
volumes:
  wordpress_data: {}
" > /root/docker-compose.yml

else
  # compose_custom_image
  export EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
  export EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"
  export AWS_ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)

  aws ecr get-login-password --region $EC2_REGION | docker login -u AWS --password-stdin "$AWS_ACCOUNT.dkr.ecr.$EC2_REGION.amazonaws.com"

  mkdir -p /root/nginx

  echo "
server {
  listen 80;
  root /var/www/html;
  index index.php;

  location / {
    try_files \$uri \$uri/ /index.php?\$args;
  }

  location ~ \.php$ {
    try_files \$uri =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass wordpress:9000;
    fastcgi_index index.php;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    fastcgi_param PATH_INFO \$fastcgi_path_info;
  }
}
" > /root/nginx/default.conf

  echo "
version: '3'
services:
  wordpress:
    image: ${docker_image}
    restart: always
    environment:
      WORDPRESS_DB_HOST: ${db_host}
      WORDPRESS_DB_USER: ${db_username}
      WORDPRESS_DB_PASSWORD: ${db_password}
      WORDPRESS_DB_NAME: ${db_name}
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - '9000:9000'
  nginx:
    image: nginx:latest
    restart: always
    volumes:
      - /root/nginx:/etc/nginx/conf.d
      - /home/ubuntu:/var/www/html
    ports:
      - '80:80'
    depends_on:
      - wordpress
volumes:
  wordpress_data: {}
" > /root/docker-compose.yml

fi

docker-compose -f /root/docker-compose.yml up -d
