    LOCAL=
   REMOTE=
##Tunnel setup for the real server.

echo 1 > /proc/sys/net/ipv4/ip_forward

#PROXY 1
iptunnel add gre1 mode gre local $LOCAL remote $REMOTE ttl 255
ip addr add 10.10.10.1/24 dev gre1
ip link set gre1 up
ip rule add from 10.10.10.0/24 table proxy1
ip route add default via 10.10.10.2 table proxy1

# note there is stuff in /etc/iproute2/rt_tables