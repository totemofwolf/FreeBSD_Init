#!/bin/sh
# filename:init_env.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

RELEASE_VER=`uname -r | awk -F '-' '{print $1}'` # 9.2
ARCH=`uname -m | awk -F '-' '{print $1}'`
ROOT_PATH="/root"
ETC_PATH="/etc"
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin
export BASE_DIR=`pwd`
export LOGFILE="$BASE_DIR/OS_init.log"

DATE=`date +%Y%m%d%H%M`

echo "-----------------------OS init @ $DATE log---------------------" | tee -a $LOGFILE

####---- Clean up the environment ----begin####
echo "FreeBSD initial env will be installed, wait ..."
sh $BASE_DIR/uninstall_init_env.sh 2> /dev/null

if [ -f "$LOGFILE" ]; then
	rm -fv $LOGFILE
fi

####---- Clean up the environment ----end####


######	service tuning begin	#####
disable_sendmail()
{
echo "Disabling Sendmail..." | tee -a $LOGFILE
cd $ETC_PATH/mail && make stop | tee -a $LOGFILE
echo "Disable Sendmail done!!" | tee -a $LOGFILE

\cp -av $ETC_PATH/rc.conf $ETC_PATH/rc.conf.orig | tee -a $LOGFILE
cat >> $ETC_PATH/rc.conf << EOF
inetd_enable="NO"

# Disable Sendmail
sendmail_enable="NONE"
sendmail_submit_enable="NO"
sendmail_outbound_enable="NO"
sendmail_msp_queue_enable="NO"
EOF
echo "Disable Sendmail done!!" | tee -a $LOGFILE
}

read -p "Press y or Y to disable sendmail:" isY
if [ "$isY" == "y" ] || [ "$isY" == "Y" ]; then
	echo "Remain to disable it..."
	isStopMail="true"
else
	echo "Okay, i will leave sendmail.."
	isStopMail="false"
fi
############	service tuning end	###########

echo $BASE_DIR | tee -a $LOGFILE
cd $BASE_DIR

# sysctl tuning
sh $BASE_DIR/env/set_sysctl.sh | tee -a $LOGFILE
echo "---------- set_sysctl ok ----------" | tee -a $LOGFILE

# rc.conf & sshd
sh $BASE_DIR/env/set_secure.sh | tee -a $LOGFILE
echo "---------- set_secure ok ----------" | tee -a $LOGFILE

# make tuning
sh $BASE_DIR/env/set_make.sh | tee -a $LOGFILE
echo "---------- set_make ok ----------" | tee -a $LOGFILE

# hosts tuning [Add hostname]
sh $BASE_DIR/env/set_hosts.sh | tee -a $LOGFILE
echo "---------- set_hosts ok ----------" | tee -a $LOGFILE

# DNS tuning
sh $BASE_DIR/env/set_dns.sh | tee -a $LOGFILE
echo "---------- set_dns ok ----------" | tee -a $LOGFILE

# .cshrc
sh $BASE_DIR/env/set_cshrc.sh | tee -a $LOGFILE
echo "---------- set_cshrc ok ----------" | tee -a $LOGFILE

# kernel & disk tuning
sh $BASE_DIR/env/set_bootloader.sh | tee -a $LOGFILE
echo "---------- set_bootloader ok ----------" | tee -a $LOGFILE

# portsnap
sh $BASE_DIR/env/set_portsnap.sh
echo "---------- set_portsnap ok ----------" | tee -a $LOGFILE
if [ ! -f "/usr/ports/INDEX-9" ]; then
    echo "ok.ready to update ports tree.." | tee -a $LOGFILE
    portsnap fetch extract
    echo "fetch & extract ports done!!" | tee -a $LOGFILE
else
    echo "ok.ports tree base found,only update.." | tee -a $LOGFILE
    portsnap fetch update
    echo "update ports done!!" | tee -a $LOGFILE
fi

unset PACKAGESITE && export PACKAGESITE="http://mirrors.aliyun.com/freebsd/ports/${ARCH}/packages-stable/Latest/"
#unset PACKAGESITE && export PACKAGESITE="http://mirrors.aliyun.com/freebsd/ports/${ARCH}/packages-${RELEASE_VER}-release/Latest/"

echo "Now the PACKAGESITE is: $PACKAGESITE" | tee -a $LOGFILE

# add basic softwares
sh $BASE_DIR/env/install_basic_sw.sh | tee -a $LOGFILE
echo "---------- install_basic_sw ok ----------" | tee -a $LOGFILE

# Dump system file hash info
ls -la /usr/bin > $ROOT_PATH/usrbin.txt
ls -la $ETC_PATH > $ROOT_PATH/etc.txt
ls -la /bin > $ROOT_PATH/bin.txt

# 将停止sendmail服务放在靠后的位置
if [ $isStopMail = "true" ]; then
	echo "Stopping sendmail service..." | tee -a $LOGFILE
	disable_sendmail
	echo "Stop sendmail service done!!" | tee -a $LOGFILE
fi

############	make system update only start	###########
freebsd-update fetch install
echo 'Update the base system done!!!' | tee -a $LOGFILE
############	make system update only end	###########

read -p "About to restart the server.Enter the y or Y to continue:" isY 
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
echo "You press the key:$isY,but not y or Y.About to restart your box manually!!" | tee -a $LOGFILE
echo "-----------------------OS init @ $DATE log done!!---------------------" | tee -a $LOGFILE && exit 1
else
echo "$isY is pressed!! About to restart..." | tee -a $LOGFILE
echo "-----------------------OS init @ $DATE log done!!---------------------" | tee -a $LOGFILE && reboot
fi
