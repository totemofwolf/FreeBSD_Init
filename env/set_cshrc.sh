#!/bin/sh
# filename:set_cshrc.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

# RELEASE_VER=`uname -r | awk -F '.' '{print $1}'` # 9
RELEASE_VER=`uname -r | awk -F '-' '{print $1}'` # 9.2
ARCH=`uname -m | awk -F '-' '{print $1}'`
ROOT_PATH="/root"
BASE_DIR=`pwd`
LOGFILE="$BASE_DIR/OS_init.log"

DATE=`date +%Y%m%d%H%M`

echo "====================================Ⅵ $ROOT_PATH/.cshrc===========================================" | tee -a $LOGFILE
echo "-----------------------add cshrc var proc log begin---------------------" | tee -a $LOGFILE

# .cshrc
if cat $ROOT_PATH/.cshrc | grep "PACKAGESITE"; then
	echo -e "\033[1;40;31mInfo:	@$ROOT_PATH/.cshrc PACKAGESITE var exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av $ROOT_PATH/.cshrc $ROOT_PATH/.cshrc.orig
sed -i '' '/path/'d .cshrc | tee -a $LOGFILE # delete default path line
echo "Add rc env..." | tee -a $LOGFILE
cat >> $ROOT_PATH/.cshrc << EOF

# hczdyw add
setenv PACKAGESITE http://mirrors.aliyun.com/freebsd/ports/${ARCH}/packages-stable/Latest/
# setenv PACKAGESITE http://mirrors.aliyun.com/freebsd/ports/${ARCH}/packages-${RELEASE_VER}-release/Latest/
# setenv PACKAGESITE ftp://ftp.cn.freebsd.org/pub/FreeBSD/ports/${ARCH}/packages-${RELEASE_VER}-release/Latest/
set autolist
alias ls 	ls -G # hightlight
alias vi	vim
#set prompt='%n@%m:%~#'
setenv LANG en_US.UTF-8
setenv LC_ALL en_US.UTF-8
set rmstar
set path = (/usr/local/bin /sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin '$HOME'/bin)
EOF
echo "Add rc env done!!" | tee -a $LOGFILE
echo -e "\033[1;40;31mInfo:	@$ROOT_PATH/.cshrc Add the following lines:\033[0m" | tee -a $LOGFILE
tail -n 11 $ROOT_PATH/.cshrc | tee -a $LOGFILE
fi

# Load .cshrc
echo "-----------------------add cshrc var proc log end-----------------------" | tee -a $LOGFILE
echo "====================================Ⅵ $ROOT_PATH/.cshrc===========================================" | tee -a $LOGFILE
