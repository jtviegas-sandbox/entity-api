#!/bin/sh

this_folder=$(dirname $(readlink -f $0))
if [ -z  $this_folder ]; then
  this_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
fi

PACKAGE_NAME="entity-api"
SRC_DIR=${this_folder}
AWS_SDK_MODULE_PATH=$SRC_DIR/node_modules/aws-sdk
ARTIFACTS_DIR=${SRC_DIR}/artifacts



echo "starting [ $0 ]..."
_pwd=`pwd`

echo "...leaving $_pwd to $SRC_DIR..."
cd "$SRC_DIR"
echo "...wrapping up the package: $PACKAGE_NAME ..."

npm install &>/dev/null
__r=$?
if [ "$__r" -eq "0" ] ; then
  if [ -d "${AWS_SDK_MODULE_PATH}" ]; then
      rm -rf "$AWS_SDK_MODULE_PATH"
  fi
  if [ ! -d "$ARTIFACTS_DIR" ]; then
    mkdir -p "$ARTIFACTS_DIR"
  fi
  rm -f "${ARTIFACTS_DIR}/${PACKAGE_NAME}.zip"
  zip -9 -q -r "${ARTIFACTS_DIR}/${PACKAGE_NAME}.zip" index.js package.json node_modules &>/dev/null
  __r=$?
fi
if [ "$__r" -eq "0" ] ; then
  echo "packaged in: ${ARTIFACTS_DIR}/${PACKAGE_NAME}.zip"
  # reinstall aws
  npm install &>/dev/null
fi

echo "...package $PACKAGE_NAME wrapping up done..."
echo "...returning to $_pwd..."
cd "$_pwd"
echo "...[ $__r ] done."