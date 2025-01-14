#!/bin/bash

set -xe

cd $(dirname $0)

OUTDIR="./out/main"
GPG_EMAIL="kounoike.yuusuke+dtv-ppa@gmail.com"

function get_debreleases() {
    local repo=$1
    local releases_json=$(gh release list -R ${repo} --limit 100 --json name,isDraft,isPrerelease)
    local releases=$(echo "${releases_json}" | jq -r '.[] | select(.isDraft == false and .isPrerelease == false) | .name')
    for rel in ${releases}; do
        local assets_json=$(gh release view -R ${repo} "${rel}" --json assets)
        local assets_url=$(echo "${assets_json}" | jq -r '.assets[] | select(.name | endswith(".deb")) | .url')
        for url in ${assets_url}; do
            if [ -z "${url}" ]; then
                continue
            fi
            curl -sSL -o "${OUTDIR}/$(basename ${url})" "${url}"
        done
    done
}

function make_ppa() {
    cd ${OUTDIR}
    dpkg-scanpackages --multiversion . > Packages
    gzip -k -f Packages

    apt-ftparchive release . > Release
    gpg --default-key "${GPG_EMAIL}" -abs -o - Release > Release.gpg
    gpg --default-key "${GPG_EMAIL}" --clearsign -o - Release > InRelease
}

# main logic

# mkdir
[ ! -d "${OUTDIR}" ] && mkdir -p "${OUTDIR}"

# public key

cp -f KEY.gpg "${OUTDIR}/KEY.gpg"


# kazuki0824/recisdb-rs
get_debreleases kazuki0824/recisdb-rs

# tsukumijima/px4_drv
get_debreleases tsukumijima/px4_drv

# build ppa repository
make_ppa
