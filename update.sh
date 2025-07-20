#!/bin/bash
echo -n "Make sure to update the version in sphereview.yml first!"
echo -n "Please enter a version to update to (v0.1.1): "
read version
git clone --depth 1 --branch $version https://github.com/dynobo/sphereview.git
flatpak-cargo-generator ./sphereview/Cargo.lock -o cargo-sources.json
flatpak-node-generator npm ./sphereview/resources/photosphereviewer/package-lock.json -o node-sources.json
rm -rf ./sphereview
git add .
