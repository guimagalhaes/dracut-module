#!/bin/bash

set -e

INIT_FILE=/boot/initramfs-$(uname -r).img
SCRIPT_CWD=$(dirname $0)
# if the folder below changes, remove the older folder first
DRACUT_MY_MODULE=/usr/lib/dracut/modules.d/98my_module/

# Validate root permission to update the initramfs file
if [ $(id -u) -ne 0 ]; then
    echo "Requires root privileges."
    exit 1
fi

tool=$(which dracut)
if [ $? -ne 0 ]; then
    echo "Make sure the dracut package is installed."
    echo "Run: 'apt-get/yum install -f dracut'."
    exit 1
fi

# backup original initramfs if not yet done
if [ ! -f ${INIT_FILE}.bak ]; then
    cp ${INIT_FILE} ${INIT_FILE}.bak
fi

# install new Dracut module
mkdir -p ${DRACUT_MY_MODULE}
cp ${SCRIPT_CWD}/my_hook_script.sh ${DRACUT_MY_MODULE}
cp ${SCRIPT_CWD}/file.conf ${DRACUT_MY_MODULE}
cp ${SCRIPT_CWD}/module-setup.sh ${DRACUT_MY_MODULE}

echo "Updating initramfs file \"${INIT_FILE}\"..."

# add My Module to the initramfs
# explicitly add all required and not default modules every time an initramfs image is created
dracut --add my_module -f ${INIT_FILE}

echo "Done"

exit 0
