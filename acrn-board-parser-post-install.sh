#!/bin/bash

# c-basic-offset: 4; tab-width: 4; indent-tabs-mode: t
# vi: set shiftwidth=4 tabstop=4 noexpandtab:
# :indentSize=4:tabSize=4:noTabs=false:

set -ex

CHROOTPATH=$1
export HOOKDIR=$(dirname $0)

# Have the installer image wait 5 seconds for users to change the boot
# command for debugging.
echo "timeout 5" >> ${CHROOTPATH}/boot/loader/loader.conf

# Add pre-login message to inform user of how to run the installer.
echo "Welcome to the Clear Linux* OS live image running the board parser of ACRN offline configuration tool

 * Documentation:     https://clearlinux.org/documentation
                      https://projectacrn.github.io
                      https://projectacrn.github.io/latest/tutorials/acrn_configuration_tool.html

" >> $1/etc/issue

BOOTENTRY=$(ls ${CHROOTPATH}/boot/loader/entries/Clear-linux-*.conf)
# Add a delay to the installer kernel commandline.
sed -i 's/^options /options rootwait /' ${BOOTENTRY}

# Fall back to acpi_idle and acpi-cpufreq drivers to get the Cx and Px data respectively.
sed -i 's/^options /options idle=nomwait intel_idle.max_cstate=0 intel_pstate=disable /' ${BOOTENTRY}

# Pull the ACRN source repository.
git clone --depth 1 https://github.com/projectacrn/acrn-hypervisor.git \
                    ${CHROOTPATH}/opt/workspace/acrn-hypervisor

# Set up to run ACRN board parser at boot startup.
cp ${HOOKDIR}/acrn-board-parser.service ${CHROOTPATH}/etc/systemd/system
cp ${HOOKDIR}/acrn-board-parser.sh ${CHROOTPATH}/opt/workspace
mkdir -p ${CHROOTPATH}/etc/systemd/system/default.target.wants/
ln -s /etc/systemd/system/acrn-board-parser.service ${CHROOTPATH}/etc/systemd/system/default.target.wants

echo "acrn-board-parser" > ${CHROOTPATH}/etc/hostname

chroot $CHROOTPATH systemd-machine-id-setup

exit 0
