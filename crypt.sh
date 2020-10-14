#!/usr/bin/env bash
set -e

source ./config/_default/credentials

npm install -g https://github.com/christophihl/staticrypt

# find ./public/_repos/tech_ent/z_cases -type f -name "index.html" -exec staticrypt {} $(echo "$password_encoded" | openssl enc -d -base64) -o {} -t "Access to Course Materials" -i "Enter the Course Password" \;

find ./public/_repos/gbwl -type f -name "index.html" -exec staticrypt {} $(echo "$password_encoded_1" | openssl enc -d -base64) -o {} -t "Access to Course Materials" -i "Enter the Course Password" \;

find ./public/_repos/dat_sci -maxdepth 1 -type f -name "index.html" -exec staticrypt {} $(echo "$password_encoded_2" | openssl enc -d -base64) -o {} -t "Access to Course Materials" -i "Enter the Course Password" \;

find ./public/_repos/ent_fin -maxdepth 1 -type f -name "index.html" -exec staticrypt {} $(echo "$password_encoded_3" | openssl enc -d -base64) -o {} -t "Access to Course Materials" -i "Enter the Course Password" \;
