#!/usr/bin/expect -f

set timeout 30

#获取第一个参数，作为用户名
#set username [lindex $argv 0]
#set passwd [lindex $argv 1]
set get_username "cat ~/.ssh/username"
set get_passwd "cat ~/.ssh/passwd"
set username [exec sh -c "$get_username"]
set passwd [exec sh -c "$get_passwd"]
set server [lindex $argv 0]

#启动新的进程，实现ssh操作
spawn ssh -o ServerAliveInterval=60 -p 60022 $username@39.104.78.125

#for循环操作
expect {
        "*ermission*" {
            set PASSWD [gets stdin]
            send "$PASSWD\r"
            exp_continue
        }
		"*assw*" {
			send "$passwd\r"
			exp_continue
		}
        "*MFA*" {
            # send_user "输入MFA\n"
            # set AUTH [gets stdin]
            set command "oathtool -b --totp 'IVNRXL2VGDX2DLAUC75PYL5W26DLZAVEFAO7P3BSOHELPGGXIJPKCYWYL2S27JOL'"
            set AUTH [exec sh -c "$command"]
            send "$AUTH\r"
        }
}

interact timeout 1 return
send "$server\r"
interact
