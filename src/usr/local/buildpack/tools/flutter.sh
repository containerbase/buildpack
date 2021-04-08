#!/bin/bash

set -e

require_root

if [[ -d "/usr/local/flutter" ]]; then
  echo "Skipping, already installed"
  exit 0
fi

export_env FLUTTER_ROOT "/usr/local/flutter"

mkdir $FLUTTER_ROOT

FLUTTER_SDK_CHANNEL="stable"
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra/releases/${FLUTTER_SDK_CHANNEL}/linux/flutter_linux_v${TOOL_VERSION}-${FLUTTER_SDK_CHANNEL}.tar.xz"
FLUTTER_SDK_ARCHIVE=flutter.tar.xz

curl -sSL $FLUTTER_SDK_URL -o $FLUTTER_SDK_ARCHIVE
tar -C $FLUTTER_ROOT --strip 1 -xf $FLUTTER_SDK_ARCHIVE
rm $FLUTTER_SDK_ARCHIVE

export_path "${FLUTTER_ROOT}/bin"

# required for upgrade lock
#chmod g=u $FLUTTER_ROOT/bin/cache

# disable auto upgrade
#sed -i 's/(upgrade_flutter)/# (upgrade_flutter)/' $FLUTTER_ROOT/bin/flutter

# we need write access to flutter :-(
chown -R root.root $FLUTTER_ROOT
chmod -R g=u $FLUTTER_ROOT

echo '{ "firstRun": false, "enabled": false }' > ~/.flutter
echo '{ "firstRun": false, "enabled": false }' > /home/${USER_NAME}/.flutter
chown ${USER_NAME} /home/${USER_NAME}/.flutter
chmod -R g=u /home/${USER_NAME}/.flutter

flutter --version


su -c 'flutter --version' ${USER_NAME}