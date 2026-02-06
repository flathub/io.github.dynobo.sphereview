#!/bin/bash
manifest_yaml="io.github.dynobo.sphereview.yml"
repo_url="https://github.com/dynobo/sphereview.git"

echo -n "Please enter a version to update to (v0.1.1): "
read version

# Fetch the commit hash for the given tag
commit_hash=$(git ls-remote "$repo_url" "refs/tags/$version" | cut -f1)
if [ -z "$commit_hash" ]; then
    echo "Error: Could not find commit hash for tag $version"
    exit 1
fi

# Update yaml
sed -i \
    -e "/name: sphereview/,/^  - name:/ {
        s/tag: v[0-9.]\+/tag: $version/
        s/commit: [0-9a-f]\+/commit: $commit_hash/
    }" \
    "$manifest_yaml"


# Update dependencies
git clone --depth 1 --branch $version $repo_url
flatpak-cargo-generator ./sphereview/Cargo.lock -o cargo-sources.json
flatpak-node-generator npm ./sphereview/resources/photosphereviewer/package-lock.json -o node-sources.json
rm -rf ./sphereview

git add .
