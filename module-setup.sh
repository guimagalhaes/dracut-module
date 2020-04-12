#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    # not added by default, it must be added by 'dracut --add my_module ...'
    return 255
}

depends() {
    return 0
}

install() {
    # add a configuration file to the initramfs image
    inst $moddir/file.conf /etc/file.conf
    # install a hook script
    inst_hook pre-pivot 60 "$moddir/my_hook_script.sh"
}
