#!/bin/bash
# author wangyingbo
# date:2023-03-07 pm 16:30

port='' # 端口号
startProxy='' # 开启代理的快捷命令
endProxy='' # 结束代理的快捷命令
pathzsh=~/.zshrc
pathbash=~/.bashrc
_DIR_=`pwd`
pathzsh=$_DIR_/zshrc.txt
pathbash=$_DIR_/bashrc.txt

green(){
	echo -e "\033[32;40m $1 \033[0m"
}
red(){
	echo -e "\033[31;40m $1 \033[0m"
}
yellow(){
	echo -e "\033[33;40m $1 \033[0m"
}

read -p "please input shortcut command of start proxy:" startProxy
if [[ -z $startProxy ]]; then
	yellow "default start proxy command is 'startproxy'"
	startProxy='startproxy'
fi

read -p "please input shortcut command of end proxy:" endProxy
if [[ -z $endProxy ]]; then
	yellow "default end proxy command is 'endproxy'"
	endProxy='endproxy'
fi

read -p "please input proxy port:" port
if [[ -z $port ]]; then
	yellow "default proxy port is 7890"
	port='7890'
fi


genproxy(){
	cat >> $1 <<PROXYEOF
PROXYURL=http://127.0.0.1
PROXYPORT=$port
# 设置代理
alias $startProxy="export http_proxy=$PROXYURL:$PROXYPORT https_proxy=$PROXYURL:$PROXYPORT;curl cip.cc"
# 取消代理
alias $endProxy="unset http_proxy https_proxy;curl cip.cc"
PROXYEOF
}

bashExist=$(grep 'PROXYURL' $pathbash)
zshExist=$(grep 'PROXYURL' $pathzsh)
if [[ -z $zshExist ]]; then
	echo ""
else
	green "\n"
	green "zsh alias proxy command has existed!"
	exit 0
fi
if [[ -z $bashExist ]]; then
	echo ""
else
	green "\n"
	green "bash alias proxy command has existed!"
	exit 0
fi

if [[ -e $pathzsh ]]; then
	genproxy $pathbash
	source $pathbash
fi

if [[ -e $pathbash ]]; then
	genproxy $pathzsh
	source $pathzsh
fi

# shell excute time
echo ""
green "($0) ${TIME}: this shell script execution duration: ${SECONDS}s"
echo ""



