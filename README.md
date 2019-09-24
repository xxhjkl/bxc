# bxc nkn 挖矿相关部署与备份还原脚本
仅在debian9上测试通过

autobxcr.sh用法：
说明一下这个脚本适用于用我这个源里面的脚本部署bxc，且有用备份脚本备份的。准备工作，从bxc官网后台导出掉线的机器，记录下mac填到下面第一步的txt里。
1、先在目录下建立一个文件里面写上mac和ip。例如1111.txt内容类似下面的如下
AA:BB:CC:DD:EE:FF               1.2.1.2
AA:BB:CC:11:22:33               1.2.3.4

上面的txt里面的ip就是你要恢复bxc的新vps的ip。
2、找一台vps记作vpsA，用你的pc连接这个vpsA。
wget https://raw.githubusercontent.com/xxhjkl/bxc/master/autobxcr.sh
chmod +x autobxcr.sh
nohup ./autobxcr.sh 参数1 参数2 参数3 &
其中
参数1 是 1111.txt 就是你写好的mac和ip的列表
参数2 是 vps的密码
参数3 是 取回备份文件的ftp的密码
比如
nohup ./autobxcr.sh 1111.txt vpspass ftppass &

最后
你就看下脚本目录下的nohup.out。如果出现name=空的说明ftp上没有找到备份，自己手动重新安装一下。
