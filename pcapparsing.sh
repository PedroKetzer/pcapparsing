#!/bin/bash

if [ "$1" = "" ]
then
        echo "Wrong use"
        echo "How to use: "Command + .pcap file" "
        echo "Example: ./pcapparsing.sh archive.pcap"
        exit
else 
#filter ip
for ip in $1;

        do tcpdump -vnar $1 | cut -d ":" -f 1 | cut -d ">" -f 2 | grep -v "20" | grep -v "192" | cut -d "." --complement -f 5 | head -n 1 > ip.txt
        done
        
#filter ports
for ip in $1;

        do tcpdump -vnar $1 | cut -d ":" -f 1 | cut -d ">" -f 2 | grep -v "20" | grep -v "192" | cut -d "." -f 5 | uniq | paste -sd ' ' > ports.txt
        done

#not ideal, but creates a single file with each port for hping.
#port1
for ip in $1;
        do tcpdump -vnar $1 | cut -d ":" -f 1 | cut -d ":" -f 1 | cut -d ">" -f 2 | grep -v "20" | grep -v "192" | cut -d "." -f 5 | uniq | sed -n '1p'> port1.txt
        done

#port2
for ip in $1;
        do tcpdump -vnar $1 | cut -d ":" -f 1 | cut -d ":" -f 1 | cut -d ">" -f 2 | grep -v "20" | grep -v "192" | cut -d "." -f 5 | uniq | sed -n '2p'> port2.txt
        done

#port3
for ip in $1;
        do tcpdump -vnar $1 | cut -d ":" -f 1 | cut -d ":" -f 1 | cut -d ">" -f 2 | grep -v "20" | grep -v "192" | cut -d "." -f 5 | uniq | sed -n '3p'> port3.txt
        done

#port4
for ip in $1;
        do tcpdump -vnar $1 | cut -d ":" -f 1 | cut -d ":" -f 1 | cut -d ">" -f 2 | grep -v "20" | grep -v "192" | cut -d "." -f 5 | uniq | sed -n '4p'> port4.txt
        done

#port5
for ip in $1;
        do tcpdump -vnar $1 | cut -d ":" -f 1 | cut -d ":" -f 1 | cut -d ">" -f 2 | grep -v "20" | grep -v "192" | cut -d "." -f 5 | uniq | sed -n '5p'> port5.txt(d)
        done
        

#remove space from ip.txt
tr -d ' ' < ip.txt > ipwithoutspaces.txt 
#merge ip with ports
paste -d' ' ipwithoutspaces.txt porta5.txt > fullip.txt

#variables
ipfull=$(< fullip.txt)
ipwithoutspaces=$(< ipwithoutspaces.txt)
port1=$(< porta1.txt)
port2=$(< porta2.txt)
port3=$(< porta3.txt)
port4=$(< porta4.txt)
port5=$(< porta5.txt)

#opening last door by sending a SYN to each port
hping3 -c 1 -V -S $ipwithoutspaces -p $port1
hping3 -c 1 -V -S $ipwithoutspaces -p $port2
hping3 -c 1 -V -S $ipwithoutspaces -p $port3
hping3 -c 1 -V -S $ipwithoutspaces -p $port4
hping3 -c 1 -V -S $ipwithoutspaces -p $port5


#get keys and info on how to disable the malware in the open door
printf 'GET / HTTP/1.1\r\nHost: localhost\r\n\r\n' | nc $ipwithoutspaces $port5

fi