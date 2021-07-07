#!/usr/bin/bash
echo "Please Enter the Mount Directory Name"
read MOUNTDIR
[[ "$MOUNTDIR" = /* ]] && mkdir "${MOUNTDIR}" || { echo "Please enter the full directory Ex /calls" ; exit 1; }

echo "This is the Mount Directory $MOUNTDIR"

echo "Please Enter the FULL USB Directory"

read USBDIR
[[ "$USBDIR" = /*/* ]] || { rm -rf "$MOUNTDIR" && echo "Please enter the full directory Ex /dev/sda" ; exit 1; }

find "${USBDIR}" -name "sda" 1> /dev/null && echo "The Directory is set PLEASE WAIT FOR THE INSTALLATION" || { rm -rf "$MOUNTDIR" && echo "Please check the USB Directory using fdisk -l" ; exit 1; }
yum install -y dosfstools
mkfs.fat -I "$USBDIR"
mount -t vfat -o umask=020 "${USBDIR}" "${MOUNTDIR}"
echo "mount -t vfat -o umask=020 "${USBDIR}" "${MOUNTDIR}"" >> /etc/rc.local
sed -i -e 's#'/var/spool/asterisk/monitor'#'"${MOUNTDIR}"'#g' /var/www/html/modules/monitoring/libs/paloSantoMonitoring.class.php
sed -i -e 's#'/var/spool/asterisk'#'"${MOUNTDIR}"'#g' /etc/asterisk/asterisk.conf
echo "The Storage Installation Is Complete
