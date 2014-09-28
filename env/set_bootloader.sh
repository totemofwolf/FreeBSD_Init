#!/bin/sh
# filename:set_bootloader.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

BOOT_PATH="/boot"
ETC_PATH="/etc"
#BASE_DIR="/root/work"

DATE=`date +%Y%m%d%H%M`

echo "====================================Ⅶ $BOOT_PATH/loader.conf===========================================" | tee -a $LOGFILE
echo "-----------------------add fstab & loader.conf proc log begin---------------------" | tee -a $LOGFILE

# kernel tuning
if cat $BOOT_PATH/loader.conf | grep "hczdyw add"; then
	echo -e "\033[1;40;31mInfo:	@$BOOT_PATH/loader.conf hczdyw add exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av $BOOT_PATH/loader.conf $BOOT_PATH/loader.conf.orig
echo "Add loader.conf..." | tee -a $LOGFILE
cat >> $BOOT_PATH/loader.conf << EOF
# hczdyw add
autoboot_delay="5"
loader_logo="beastie"
ataahci_load="YES"
ataintel_load="YES"
vpo_load="YES"          # Parallel to SCSI interface driver
accf_data_load="YES"    # Wait for data accept filter
accf_dns_load="YES"     # Wait for full DNS request accept filter
accf_http_load="YES"    # Wait for full HTTP request accept filter
# FreeBSD 9+
# New Congestion Control for FreeBSD
cc_htcp_load="YES"		# Use HTCP congestion control,also need to set 'net.inet.tcp.cc.algorithm=htcp' in sysctl
aio_load="YES"          # Asynchronous I/O
fdescfs_load="YES"      # Filedescriptors filesystem
procfs_load="YES"       # Process filesystem
#acpi_dsdt_load="YES"
# FreeBSD 9.x+
# Increase interface send queue length
# See commit message http://svn.freebsd.org/viewvc/base?view=revision&revision=207554
#net.link.ifqmaxlen=1024
kern.ipc.semmni=60
kern.ipc.semmns=640 #kern.ipc.semmns=540 # For 500 pg clients modify @20140808
kern.ipc.semume=60
kern.ipc.semmnu=180
kern.maxproc=32768
kern.ipc.shmmni=600
# ZFS
# Enable prefetch. Useful for sequential load type i.e fileserver.
# FreeBSD sets vfs.zfs.prefetch_disable to 1 on any i386 systems and 
# on any amd64 systems with less than 4GB of available memory
# See: http://old.nabble.com/Samba-read-speed-performance-tuning-td27964534.html
vfs.zfs.prefetch_disable=0
# syncache tuning
net.inet.tcp.syncache.hashsize=32768
net.inet.tcp.syncache.bucketlimit=32
net.inet.tcp.syncache.cachelimit=1048576
# TCP control-block Hash table tuning
# See: http://serverfault.com/questions/372512/why-change-net-inet-tcp-tcbhashsize-in-freebsd
net.inet.tcp.tcbhashsize=524288
EOF

echo "====================================Ⅶ $BOOT_PATH/loader.conf===========================================" tee -a $LOGFILE

if kldstat | grep "aio"; then
	echo "aio already exists" | tee -a $LOGFILE
else
	kldload aio | tee -a $LOGFILE
fi
if kldstat | grep "accf_http"; then
	echo "accf_http already exists" | tee -a $LOGFILE
else
	kldload accf_http | tee -a $LOGFILE
fi
echo "Add loader.conf done!!" | tee -a $LOGFILE
echo -e "\033[1;40;31mInfo:	@$BOOT_PATH/loader.conf Add the following lines:\033[0m" | tee -a $LOGFILE
tail -n 10 $BOOT_PATH/loader.conf | tee -a $LOGFILE
fi

############################# add tmpfs support begin #############################
if cat $ETC_PATH/fstab | grep "tmpfs"; then
	echo -e "\033[1;40;31mInfo:	@$ETC_PATH/fstab tmpfs exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av $ETC_PATH/fstab $ETC_PATH/fstab.orig | tee -a $LOGFILE
echo '# hczdyw add' >> $ETC_PATH/fstab
echo 'tmpfs /tmp tmpfs rw,mode=0777 0 0' >> $ETC_PATH/fstab
echo "Add tmpfs done" | tee -a $LOGFILE
umount /tmp | tee -a $LOGFILE
mount /tmp | tee -a $LOGFILE
if file /var/tmp | grep "directory"; then
	mv /var/tmp/* /tmp/ | tee -a $LOGFILE
	rm -rvf /var/tmp | tee -a $LOGFILE
	ln -sf /tmp /var/tmp | tee -a $LOGFILE
else
	RST=`file /var/tmp | grep "link"`
	echo "$RST" | tee -a $LOGFILE
fi

fi
############################# add tmpfs support end #############################

echo "-----------------------add fstab & loader proc log end---------------------" | tee -a $LOGFILE
echo "====================================Ⅶ $BOOT_PATH/loader.conf===========================================" | tee -a $LOGFILE
