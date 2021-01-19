# GRE tunnel stuff
# 142.4.202.40 is remote server
# 192.198.115.18 is this server
echo 1 > /proc/sys/net/ipv4/ip_forward

# ovh
iptunnel add gre1 mode gre local 192.198.115.18 remote 142.4.202.40 ttl 255
ip addr add 10.10.10.1/24 dev gre1
ip link set gre1 up
ip rule add from 10.10.10.0/24 table CA
ip route add default via 10.10.10.2 table CA

# x4b.net 10.17.13.40
# 64.32.6.180 remote ip
iptunnel add gre2 mode gre local 192.198.115.18 remote 64.32.6.180 ttl 255
ip addr add 10.17.13.42/30 dev gre2
ip link set gre2 up
ip rule add from 10.17.13.40/30 table x4b
ip route add default via 10.17.13.41 table x4b

#iptunnel add gre2 mode gre local 192.198.115.18 remote 198.251.81.234 ttl 255
#ip addr add 10.17.19.2/30 dev gre2
#ip link set gre2 up
#ip rule add from 10.17.19.0/24 table x4b
#ip route add default via 10.17.19.1 table x4b

# note there is stuff in /etc/iproute2/rt_tables