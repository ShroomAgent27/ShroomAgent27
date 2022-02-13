# PROXY is the IP of the server we're on right now
       PROXY=
# REALSERVER is the IP of the other end, or the real server we're protecting
  REALSERVER=

OTHERSIDE=10.10.10.1
   MYSIDE=10.10.10.2
   GRENET=10.10.10.0
  GRECIDR=/30
    PORTS=(25565 25566 25567 25568)

echo 1 > /proc/sys/net/ipv4/ip_forward
iptunnel add gre1 mode gre local $PROXY remote $REALSERVER ttl 255
ip addr add $MYSIDE$GRECIDR dev gre1
ip link set gre1 up
iptables -t nat -A POSTROUTING -s $GRENET$GRECIDR -j SNAT --to-source $PROXY
for PORT in ${PORTS[*]}
do
    iptables -t nat -A PREROUTING -p tcp -d $PROXY --dport $PORT -j DNAT --to-destination $OTHERSIDE:$PORT
    iptables -A FORWARD -p tcp -d $OTHERSIDE --dport $PORT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
done
