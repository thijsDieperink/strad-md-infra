#!/bin/bash

# Add rules for iptables
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s 172.18.0.0/16 ! -o docker0 -j MASQUERADE
sudo iptables -A FORWARD -i docker0 -o enp0s3 -j ACCEPT
sudo iptables -A FORWARD -i enp0s3 -o docker0 -m state --state RELATED,ESTABLISHED -j ACCEPT
