#!/bin/bash

# ---
# see also AppImage kit https://github.com/AppImage/AppImageKit/releases
# ---
export LENS_VERSION="5.0.0-alpha.2"
export LENS_VERSION="4.2.2"
# https://github.com/lensapp/lens/releases
# curl -L https://github.com/lensapp/lens/archive/refs/tags/v${LENS_VERSION}.tar.gz -o ./lens-v${LENS_VERSION}.tar.gz

export FILENAME=$(curl -L https://github.com/lensapp/lens/releases/download/v${LENS_VERSION}/latest-linux.yml | grep 'url:' | awk '{print $NF}')

curl -LO https://github.com/lensapp/lens/releases/download/v${LENS_VERSION}/${FILENAME}


chmod a+x ${FILENAME}
./${FILENAME}

# export INSTALLATION_LENS_IDE=$(mktemp -d -t "INSTALLATION_LENS_IDE-XXXXXXXXXX")
# cp ${FILENAME} ${INSTALLATION_LENS_IDE}
# ${INSTALLATION_LENS_IDE}/${FILENAME}
sudo mkdir -p /usr/local/bin/lens-${LENS_VERSION}/

sudo ln -s /usr/local/bin/lens-${LENS_VERSION}/bin/lens /usr/local/bin/lens
# --- #
# 

# --- # 
# desktop shortcut

# in ~/.local/share/applications/ or /usr/share/applications

mkdir -p ~/.local/share/applications/
cat <<EOF > ./lens.desktop
[Desktop Entry]
Name=Lens
Exec=<path/to/executable> %U
Terminal=false
Type=Application
Icon=lens
StartupWMClass=Lens
Comment=Lens - The Kubernetes IDE
MimeType=x-scheme-handler/lens;
Categories=Network;
EOF

xdg-settings set default-url-scheme-handler lens lens.desktop

cp ./lens.desktop ~/.local/share/applications/
rm ./lens.desktop

# ~/.local/share/applications/lens.desktop
