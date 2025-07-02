# This Dockerfile builds a Hugo site and serves it with Nginx.
# syntax=docker/dockerfile:1

###################
##### Stage 1 #####
###################
# The first stage installs Hugo, creates a new site, and builds it.

# Stage 1: build the Hugo site
FROM ubuntu:22.04 AS hugo-builder

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

###############################
# Add directory structure
# Copy the shell script into the container
COPY folders.sh /folders.sh

# Make the script executable
RUN chmod +x /folders.sh

# Execute the script to create directories
RUN /folders.sh
# Done Directory Structure 
################################

# Add Structure of baseof.html
COPY baseof.html /var/www/intranet/themes/ananke/layouts/_default/baseof.html

# Add Styles 
COPY styles.css /var/www/intranet/static/css/styles.css

# Build hugo site
RUN cd /var/www/intranet && hugo


###################
##### Stage 2 #####
###################
# This stage uses the built Hugo site and serves it with Nginx

# Stage 2: nginx serving the hugo site
FROM nginx:stable

# Copy the built hugo site to nginx html
COPY --from=hugo-builder /var/www/intranet/public /usr/share/nginx/html

# Copy the static files (CSS, images, etc.) to nginx html
COPY --from=hugo-builder /var/www/intranet/static /usr/share/nginx/html/static

# Optionally override the nginx config
# If you want to replicate the exact server block:
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
# End of Dockerfile