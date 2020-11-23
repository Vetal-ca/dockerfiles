#!/bin/sh
# Needed for openvpn
mkdir -p /run/openvpn
mkdir -p /dev/net
mknod /dev/net/tun c 10 200

# Firewall
# Allow traffic initiated from VPN to access "the world"
iptables -F
# Allow traffic initiated from VPN to access "the world"
iptables -I FORWARD -i tun0 -o eth0 -m conntrack --ctstate NEW -j ACCEPT
# Masquerade traffic from VPN to "the world" -- done in the nat table
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE


# Run actual OpenVPN
exec /usr/bin/openvpn --writepid /run/openvpn/server.pid --cd /etc/openvpn --config /etc/openvpn/server.conf --script-security 2