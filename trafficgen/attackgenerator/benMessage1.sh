#!/bin/bash


for i in {0..250}
do
ssh -i ./server.pem softseclab@10.176.147.83 sudo sysdig_cap -w stream-$i.scap -z -s 4096 container.name=target  &

ssh -i ./server.pem softseclab@10.176.147.83 sudo nohup tcpdump_cap -i eth0 -s0 -w stream-$i.cap port not 22 and port not 3490 and port not 3492 and port not 3790 and port not 80 >pdump.out &
sleep 5
curl -k https://10.176.147.83/cgi-bin/ss

sleep 4
curl -k https://10.176.147.83/guestbook.html
sleep 6 
ssh -i ./server.pem softseclab@10.176.147.83 sudo killall -s SIGINT sysdig_cap
ssh -i ./server.pem softseclab@10.176.147.83 sudo killall -s SIGINT tcpdump_cap



sleep 4
done


