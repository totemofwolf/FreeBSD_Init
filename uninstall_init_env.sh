#!/bin/sh
# filename:uninstall_init_env.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

ROOT_PATH="/root"
BOOT_PATH="/boot"
ETC_PATH="/etc"
#BASE_DIR="$ROOT_PATH/work"
BASE_DIR=`pwd`

DATE=`date +%Y%m%d%H%M`

echo "-----------------------OS uninstall init @ $DATE log begin---------------------" | tee -a $BASE_DIR/OS_uninstall.log

########################### $ETC_PATH/make.conf begin ###########################
if [ -f "$ETC_PATH/make.conf" ]; then
	echo "orig $ETC_PATH/make.conf found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	rm -vf $ETC_PATH/make.conf*
	echo "rm $ETC_PATH/make.conf.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/make.conf end ###########################


########################### $ETC_PATH/ssh/sshd_config begin ###########################
if [ -f "$ETC_PATH/ssh/sshd_config.orig" ]; then
	echo "orig $ETC_PATH/ssh/sshd_config found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/ssh/sshd_config.orig $ETC_PATH/ssh/sshd_config | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/ssh/sshd_config.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/ssh/sshd_config end #############################


########################### $ETC_PATH/rc.conf begin ###########################
if [ -f "$ETC_PATH/rc.conf.orig" ]; then
	echo "orig $ETC_PATH/rc.conf found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/rc.conf.orig $ETC_PATH/rc.conf | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/rc.conf.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/rc.conf end #############################


########################### $ROOT_PATH/.cshrc begin ###########################
if [ -f "$ROOT_PATH/.cshrc.orig" ]; then
	echo "orig $ROOT_PATH/.cshrc found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ROOT_PATH/.cshrc.orig $ROOT_PATH/.cshrc | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ROOT_PATH/.cshrc.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ROOT_PATH/.cshrc end #############################


########################### $BOOT_PATH/loader.conf begin ###########################
if [ -f "$BOOT_PATH/loader.conf.orig" ]; then
	echo "orig $BOOT_PATH/loader.conf found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $BOOT_PATH/loader.conf.orig $BOOT_PATH/loader.conf | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $BOOT_PATH/loader.conf.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $BOOT_PATH/loader.conf end ###########################


########################### $ETC_PATH/sysctl.conf begin ###########################
if [ -f "$ETC_PATH/sysctl.conf.orig" ]; then
	echo "orig $ETC_PATH/sysctl.conf found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/sysctl.conf.orig $ETC_PATH/sysctl.conf | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/sysctl.conf.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/sysctl.conf end ###########################


########################### $ETC_PATH/resolv.conf begin ###########################
if [ -f "$ETC_PATH/resolv.conf.orig" ]; then
	echo "orig $ETC_PATH/resolv.conf found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/resolv.conf.orig $ETC_PATH/resolv.conf | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/resolv.conf.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/resolv.conf end ###########################


########################### $ETC_PATH/hosts begin ###########################
if [ -f "$ETC_PATH/hosts.orig" ]; then
	echo "orig $ETC_PATH/hosts found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/hosts.orig $ETC_PATH/hosts | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/hosts.orig done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/make.conf end ###########################


########################### $ETC_PATH/rc.conf begin ###########################
if [ -f "$ETC_PATH/rc.conf.orig" ]; then
	echo "orig $ETC_PATH/rc.conf found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/rc.conf.orig $ETC_PATH/rc.conf | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/rc.conf done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/rc.conf end ###########################


########################### $ETC_PATH/fstab begin ###########################
if [ -f "$ETC_PATH/fstab.orig" ]; then
	echo "orig $ETC_PATH/fstab found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/fstab.orig $ETC_PATH/fstab | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/fstab done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/fstab end ###########################


########################### $ETC_PATH/fstab begin ###########################
if [ -f "$ETC_PATH/portsnap.conf.orig" ]; then
	echo "orig $ETC_PATH/portsnap.conf found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	mv $ETC_PATH/portsnap.conf.orig $ETC_PATH/portsnap.conf | tee -a $BASE_DIR/OS_uninstall.log
	echo "move $ETC_PATH/portsnap.conf done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### $ETC_PATH/portsnap.conf end ###########################


########################### misc begin ###########################
if [ -f "$ROOT_PATH/.vimrc" ]; then
	echo "$ROOT_PATH/.vimrc found,removing..." | tee -a $BASE_DIR/OS_uninstall.log
	rm -v $ROOT_PATH/.vimrc* | tee -a $BASE_DIR/OS_uninstall.log
	echo "rm $ROOT_PATH/.vimrc done!" | tee -a $BASE_DIR/OS_uninstall.log
fi
########################### misc end ###########################

echo "-----------------------OS uninstall init @ $DATE log end---------------------" | tee -a $BASE_DIR/OS_uninstall.log
