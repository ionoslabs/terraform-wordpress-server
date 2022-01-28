This project installs wordpress onto an IONOS server instance in the US/Newark location using

1. wp-terraform.tf = main terraform file
2. variables.tf = sets terraform variables and sensitivity for IONOS credential variables
3. cloud-init-wp-install.yaml = cloud init yaml configuration that configures initial boot to:
        - Install apache2
        - git clone https://github.com/ionoslabs/wp-install to /tmp/wp-install
        - change wp-install.sh script to executable
        - run the wp-install script

In order to run this terraform apply correctly, you will need to configure the following:

1. Locally created SSH key, enter path to public key on line 38
2. On local machine set enviornment variables for username and password, you may also not set these and will be prompted for ionos account username and password
