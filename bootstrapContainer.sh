#!/bin/bash
# This is for use with a ubuntu container with manual injection of the script

# Install Dependencies 
apt update
apt install wget -y
apt install vim -y
apt install git -y

# Install Nginx
apt install nginx -y

# Start and enable Nginx service
service nginx start

# Install Hugo 
wget https://github.com/gohugoio/hugo/releases/download/v0.128.1/hugo_extended_0.128.1_Linux-64bit.tar.gz
tar -xvzf hugo_extended_0.128.1_Linux-64bit.tar.gz
mv hugo /usr/local/bin/

# Create a directory for the Hugo site
hugo new site /var/www/intranet

# Add a theme (you can choose any theme you like)
cd /var/www/intranet
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml


##########################
## Below is for testing ##
##########################

# Build Directory (Change As Needed )
mkdir -p content/Phone-List
mkdir -p content/Location/Tap
mkdir -p content/Location/Reports
mkdir -p content/Location/Services
mkdir -p content/Company-HR
mkdir -p content/MS-Office-and-Teams-Training
mkdir -p content/Sharepoint-365-Shortcuts
mkdir -p content/Sharepoint-Shortcuts
mkdir -p content/Support/Software

##############################
##
##############################


vim /etc/nginx/sites-available/default 

server {
    listen 80;
    server_name localhost;

    root /var/www/intranet/public;  # Make sure this is correct
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Create symbolic link to enable the site
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Setup site 
cd /var/www/intranet
hugo 

#####################
# At this point you will have default hugo site with the ananke theme installed.
# Now need to add content to the site..
