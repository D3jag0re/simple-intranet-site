# This Dockerfile builds a Hugo site and serves it with Nginx.
# syntax=docker/dockerfile:1

# Stage 1: build the Hugo site
FROM ubuntu:22.04 as hugo-builder

ENV DEBIAN_FRONTEND=noninteractive

# Install hugo build dependencies
RUN apt update && \
    apt install -y wget git tar

# Install Hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.128.1/hugo_extended_0.128.1_Linux-64bit.tar.gz && \
    tar -xvzf hugo_extended_0.128.1_Linux-64bit.tar.gz && \
    mv hugo /usr/local/bin/hugo

# Create Hugo site
RUN hugo new site /var/www/intranet && \
    cd /var/www/intranet && \
    git init && \
    git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke && \
    echo "theme = 'ananke'" >> hugo.toml

# Add directory structure for testing
RUN cd /var/www/intranet && \
    mkdir -p \
      content/Phone-List \
      content/Location/Tap \
      content/Location/Reports \
      content/Location/Services \
      content/Company-HR \
      content/MS-Office-and-Teams-Training \
      content/Sharepoint-365-Shortcuts \
      content/Sharepoint-Shortcuts \
      content/Support/Software

# Build hugo site
RUN cd /var/www/intranet && hugo

# Stage 2: nginx serving the hugo site
FROM nginx:stable

# Copy the built hugo site to nginx html
COPY --from=hugo-builder /var/www/intranet/public /usr/share/nginx/html

# Optionally override the nginx config
# If you want to replicate the exact server block:
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
# End of Dockerfile
