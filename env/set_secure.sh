#!/bin/sh
# filename:BSD_set_secure.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

ETC_PATH="/etc"

echo "====================================Ⅱ $ETC_PATH/rc.conf ===========================================" | tee -a $LOGFILE
############	secure your box begin ############
echo "-----------------------add $ETC_PATH/ssh/sshd_config proc log begin---------------------" | tee -a $LOGFILE

if cat $ETC_PATH/ssh/sshd_config | grep "#hczdyw add"; then
echo -e "\033[1;40;31mInfo:	@$ETC_PATH/ssh/sshd_config hczdyw add exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av $ETC_PATH/ssh/sshd_config $ETC_PATH/ssh/sshd_config.orig | tee -a $LOGFILE
echo "replace sshd_config configure begin..." | tee -a $LOGFILE
echo "#hczdyw add" >> $ETC_PATH/ssh/sshd_config
sed -i '' -e 's|#Protocol 2|Protocol 2|' $ETC_PATH/ssh/sshd_config
# cat $ETC_PATH/ssh/sshd_config | grep "Protocol 2"
sed -i '' -e 's|#X11Forwarding yes|X11Forwarding no|' $ETC_PATH/ssh/sshd_config
# cat $ETC_PATH/ssh/sshd_config | grep "X11Forwarding no"
sed -i '' -e 's|#UseDNS yes|UseDNS no|' $ETC_PATH/ssh/sshd_config
# cat $ETC_PATH/ssh/sshd_config | grep "UseDNS no"
sed -i '' -e 's|#VersionAddendum|VersionAddendum|g' $ETC_PATH/ssh/sshd_config
#echo 'replace sshd_config configure end!!!' | tee -a $LOGFILE
fi
echo "-----------------------add $ETC_PATH/ssh/sshd_config proc log end---------------------" | tee -a $LOGFILE

echo "-----------------------add $ETC_PATH/rc.conf proc log begin---------------------" | tee -a $LOGFILE
if cat $ETC_PATH/rc.conf | grep "hczdyw add"; then
echo -e "\033[1;40;31mInfo:	@$ETC_PATH/rc.conf hczdyw add exists,Skip..\033[0m" | tee -a $LOGFILE
else
echo 'add rc.conf configure begin...' | tee -a $LOGFILE
\cp -av $ETC_PATH/rc.conf $ETC_PATH/rc.conf.orig | tee -a $LOGFILE
cat >> $ETC_PATH/rc.conf << EOF

# hczdyw add
portmap_enable="NO"
inetd_enable="NO"
clear_tmp_enable="YES"
moused_enable="NO"
EOF
echo 'add rc.conf configure begin...' | tee -a $LOGFILE
fi
############	secure your box end ############
echo "-----------------------add $ETC_PATH/rc.conf proc log end---------------------" | tee -a $LOGFILE

echo "====================================Ⅱ $ETC_PATH/rc.conf ===========================================" | tee -a $LOGFILE
