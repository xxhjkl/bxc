#!/usr/bin/env bash 
checkenv(){
    if which apt >/dev/null ; then
        PG="apt"
    elif which yum >/dev/null ; then
        PG="yum"
    elif which pacman>/dev/null ; then
        PG="pacman"
    else
        exit 1
	fi
}

yuminstalljq(){
    # 安装EPEL仓库就为了装个jq,可恶
    wget -O $TMP/epel-release-latest-7.noarch.rpm http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    rpm -ivh $TMP/epel-release-latest-7.noarch.rpm
    yum install -y jq
}

installjq(){
    # 安装jq json文件分析工具
    if which jq>/dev/null; then
        return
    fi
    checkenv
    case $PG in
        apt     ) $PG install -y jq ;;
        yum     ) yuminstalljq ;;
        pacman  ) $PG -S jq ;;
    esac
}

installDocker(){
checkenv
if which docker >/dev/null
then
	echo 'Docker installed, skip'
else
    OS=$(cat /etc/issue |head -1 |awk -F " " '{print $1}' )
	case $OS in
	Ubuntu*) OS="ubuntu";;
	CentOS*) OS="centos";;
	Debian*) OS="debian";;
	*) echo -e "\033[31Run the script again after installing docker manually\033[0m"&&exit 1;;
esac
	if [[ "$PG" == "apt" ]]
	then
		apt install apt-transport-https ca-certificates curl gnupg2 sudo software-properties-common -y
		curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$OS $(lsb_release -cs) stable"
		apt update -y
		apt install docker-ce -y
	elif [[ "$PG" == "yum" ]]
	then
		yum install -y yum-utils
		yum-config-manager --add-repo http://mirrors.ustc.edu.cn/docker-ce/linux/$OS/docker-ce.repo
		yum makecache
		yum install -y docker-ce
	fi
	systemctl enable docker.service
	systemctl start docker.service
	if which docker >/dev/null
	then
	  echo 'Docker Successful Installation'
	else
	  echo -e "\033[31mDocker installation failed,Manual installation of docker and run the script again！（手动安装Docker，再次运行脚本）\033[0m"
	  exit 1
	fi
fi
}

inDocker(){
installDocker
installjq
docker pull qinghon/bxc-net:amd64
getBcode
MAC_ADDR=$(echo "08:06:C1:CB$(dd bs=1 count=2 if=/dev/random 2>/dev/null |hexdump -v -e '/1 ":%02X"')")
docker run -d --cap-add=NET_ADMIN --sysctl net.ipv6.conf.all.disable_ipv6=0 --device /dev/net/tun --restart=always --mac-address=$MAC_ADDR -e bcode=$bcode -e email=$email --name=bxc -v bxc_data:/opt/bcloud qinghon/bxc-net:amd64
sleep 3
# 检测绑定成功与否
con_id=$(docker ps -a --no-trunc | grep qinghon | awk '{print $1}')
fail_echo=$(docker echos "${con_id}" 2>&1 |grep 'bonud fail'|head -n 1)
if [[ -n "${fail_echo}" ]]; then
    echo "bound fail\n${fail_echo}\n"
    docker stop "${con_id}"
    docker rm "${con_id}"
    return 
fi
create_status=$(docker container inspect "${con_id}" --format "{{.State.Status}}")
if [[ "$create_status" == "created" ]]; then
    echo "Delete can not run container\n"
    docker container rm "${con_id}"
    return
fi
}

checkBcode(){
if [ $bcode ]
then
echo $bcode
else
sleep $(echo $RANDOM | cut -b 1-3)
getBcode
fi
}

getBcode(){
json=$(curl -fsSL "https://console.bonuscloud.io/api/bcode/getBcodeForOther/?email=${email}")
bcode_list=$(echo "${json}"|jq '.ret.non_mainland')
bcode=$(echo "${bcode_list}"|jq -r '.[]|.bcode'|head -1)
checkBcode
}

email=xxhjkl@foxmail.com
inDocker
sync
