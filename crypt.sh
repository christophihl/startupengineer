#!/usr/bin/env bash
set -e

source ./config/_default/credentials

npm install -g staticrypt

find ./public/_repos/tech_ent -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded" | openssl enc -d -base64) --short -o {} --template-instructions "Access to Course Materials" \;

find ./public/_repos/gbwl -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_1" | openssl enc -d -base64) --short -o {} --template-instructions "Access to Course Materials" \;

find ./public/_repos/dat_sci_1 -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_2_1" | openssl enc -d -base64) --short -o {} --template-instructions "Access to Course Materials" \;
find ./public/_repos/dat_sci_2 -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_2_2" | openssl enc -d -base64) --short -o {} --template-instructions "Access to Course Materials" \;
find ./public/_repos/dat_sci_3 -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_2_3" | openssl enc -d -base64) --short -o {} --template-instructions "Access to Course Materials" \;

find ./public/_repos/ent_fin -maxdepth 1 -type f -name "index.html" -exec staticrypt {} -p $(echo "$password_encoded_3" | openssl enc -d -base64) --short -o {} --template-instructions "Access to Course Materials" \;
