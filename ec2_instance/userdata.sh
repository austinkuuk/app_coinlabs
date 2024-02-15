#!/bin/bash
apt-get update
apt-get install -y docker.io awscli
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

ECR_PASS=$(aws ecr get-login-password --region ap-northeast-1)
docker login --username AWS --password $ECR_PASS 552063785821.dkr.ecr.ap-northeast-1.amazonaws.com

mkdir -p /root/nginx

cat << 'EOF' > /root/nginx/default.conf
server {
    listen 80;
    root /var/www/html;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
EOF

cat << 'DOCKERCOMPOSE' > /root/docker-compose.yml
version: '3'
services:
  wordpress:
    ## Change the image URL
    image: 044714231161.dkr.ecr.ap-northeast-1.amazonaws.com/docker_wordpress:v1.0.0-rc
    restart: always
    environment:
      WORDPRESS_DB_HOST: ${db_host}
      WORDPRESS_DB_USER: ${db_username}
      WORDPRESS_DB_PASSWORD: ${db_password}
      WORDPRESS_DB_NAME: ${db_name}
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "9000:9000"
  webserver:
    image: nginx:latest
    restart: always
    volumes:
      - /root/nginx:/etc/nginx/conf.d
      - wordpress_data:/var/www/html
    ports:
      - "80:80"
    depends_on:
      - wordpress
volumes:
  wordpress_data: {}
DOCKERCOMPOSE

docker-compose -f /root/docker-compose.yml up -d
