# Install base image
ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY domain.conf /etc/nginx/conf.d/default.conf

# Set domain name
ARG DOMAIN_NAME

RUN sed "/server_name symfony.local;/c\    server_name ${DOMAIN_NAME};" -i /etc/nginx/conf.d/default.conf

# Set workdir
WORKDIR /app
