#!/bin/bash

host_name=$1
echo "Host:$1"
setenforce 0
sed -i 's/enforcing/disabled/g;' /etc/sysconfig/selinux 
sed -i 's/enforcing/disabled/g;' /etc/selinux/config
yum install -y firewalld
sed -i 's/#Port 22/Port 22/g;' /etc/ssh/sshd_config 
systemctl restart sshd
echo $host_name >/etc/hostname 
hostname $host_name
systemctl enable firewalld && systemctl restart firewalld


