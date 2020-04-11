#!/usr/bin/env bash
set -e

source ./config/_default/credentials

npm install -g https://github.com/christophihl/staticrypt

find ./public/_syllabi/tech_ent -type f -name "index.html" -exec staticrypt {} $(echo "$password_encoded" | openssl enc -d -base64) -o {} -t "Access to Course Notes & Materials" -i "Enter the Course Password" \;
