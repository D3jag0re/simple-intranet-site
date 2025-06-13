#!/bin/bash
# This is for use with a ubuntu VM
# If exec into a container for testing, remove sudo as well as use "service nginx start" as systemctl does not exist in container 

# Install Nginx
sudo apt update
sudo apt install -y nginx
# Start and enable Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx
# Install Hugo 
# (wrong version) sudo apt install -y hugo

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

