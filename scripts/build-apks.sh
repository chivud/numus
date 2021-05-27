#!/usr/bin/env bash

java -jar ~/software/bundletool-all-1.6.1.jar build-apks --bundle=app-release.aab --output=app.apks --ks=~/projects/flutter/numus/numus/keys/upload-keystore.jks --ks-pass=pass:NewLife1990! --ks-key-alias=upload
