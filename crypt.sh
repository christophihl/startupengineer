#!/usr/bin/env bash
set -e

source ./config/_default/credentials

npm install -g staticrypt

find ./public/_repos/tech_ent -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded" | openssl enc -d -base64) --short -d ./public/_repos/tech_ent --template-instructions "Access to Course Materials" --template-color-primary "#005E73" --template-color-secondary "#2DC6D6" --template-button "LOGIN" \;

find ./public/_repos/gbwl -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_1" | openssl enc -d -base64) --short -d ./public/_repos/gbwl --template-instructions "Access to Course Materials" --template-color-primary "#005E73" --template-color-secondary "#2DC6D6" --template-button "LOGIN" \;

find ./public/_repos/dat_sci_1 -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_2_1" | openssl enc -d -base64) --short -d ./public/_repos/dat_sci_1 --template-instructions "Access to Course Materials" --template-color-primary "#005E73" --template-color-secondary "#2DC6D6" --template-button "LOGIN" \;
find ./public/_repos/dat_sci_2 -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_2_2" | openssl enc -d -base64) --short -d ./public/_repos/dat_sci_2 --template-instructions "Access to Course Materials" --template-color-primary "#005E73" --template-color-secondary "#2DC6D6" --template-button "LOGIN" \;
find ./public/_repos/dat_sci_3 -type f -name "*.html" -exec staticrypt {} -p $(echo "$password_encoded_2_3" | openssl enc -d -base64) --short -o {} -d ./public/_repos/dat_sci_3 --template-instructions "Access to Course Materials" --template-color-primary "#005E73" --template-color-secondary "#2DC6D6" --template-button "LOGIN" \;

find ./public/_repos/ent_fin -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_3" | openssl enc -d -base64) --short -d ./public/_repos/ent_fin --template-instructions "Access to Course Materials" --template-color-primary "#005E73" --template-color-secondary "#2DC6D6" --template-button "LOGIN" \;
