#!/bin/sh
# filename:install_basic_sw.sh
# author:wanglang@ihczd.com
# version:0.9.0
# date:2014-08-05

echo "-----------------------add basic softwares proc log begin---------------------" | tee -a $LOGFILE

# use `wget` as the default fetch tool
if pkg_info | grep "wget"; then
	echo 'wget pkg exists,Skip..' | tee -a $LOGFILE
else
	echo "Add wget.." | tee -a $LOGFILE
	pkg_add -rv wget
	echo "wget pkg add OK" | tee -a $LOGFILE
fi

# portaudit
if pkg_info | grep "portaudit"; then
	echo 'portaudit pkg exists,Skip..' | tee -a $LOGFILE
else
	echo "Add portaudit.." | tee -a $LOGFILE
	pkg_add -rv portaudit
	echo "portaudit pkg add OK" | tee -a $LOGFILE
fi

echo "Refreshing portaudit database..."
/usr/local/sbin/portaudit -Fda | tee -a $LOGFILE

# portmaster
if pkg_info | grep "portmaster"; then
	echo 'portmaster pkg exists,Skip..' | tee -a $LOGFILE
else
	echo "Add portmaster.." | tee -a $LOGFILE
	pkg_add -rv portmaster
	echo "portmaster pkg add OK" | tee -a $LOGFILE
fi

# dialog4ports
if pkg_info | grep "dialog4ports"; then
	echo 'dialog4ports pkg exists,Skip..' | tee -a $LOGFILE
else
	echo "Add dialog4ports.." | tee -a $LOGFILE
	pkg_add -rv dialog4ports
	echo "dialog4ports pkg add OK" | tee -a $LOGFILE
fi

# vim-lite
if pkg_info | grep "vim-lite"; then
	echo 'vim-lite pkg exists,Skip..' | tee -a $LOGFILE
else
	echo "Add vim-lite.." | tee -a $LOGFILE
	pkg_add -rv vim-lite
	echo "vim-lite pkg add OK" | tee -a $LOGFILE
fi

# sudo
if pkg_info | grep "sudo"; then
	echo 'sudo pkg exists,Skip..' | tee -a $LOGFILE
else
	echo "Add sudo.." | tee -a $LOGFILE
	pkg_add -rv sudo
	echo "sudo pkg add OK" | tee -a $LOGFILE
fi

# py-glances
#if pkg_info | grep "py-glances"; then
#	echo 'py-glances pkg exists,Skip..' | tee -a $LOGFILE
#else
#	echo "Add py-glances.."
#	make -C /usr/ports/sysutils/py-glances install clean
#	echo "py-glances pkg add OK" | tee -a $LOGFILE
#fi


if [ ! -f "~/.vimrc" ]; then
	\cat $BASE_DIR/env/vimrc4unix > ~/.vimrc
fi

echo "-----------------------add basic softwares proc log begin---------------------" | tee -a $LOGFILE
