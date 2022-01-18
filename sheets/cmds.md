ip addr

ip link set eth0 up
ifup eth0

ip addr add 192.168.1.2/24 dev eth0

route add default gw 192.168.0.1
traceroute 192.168.1.1

systemctl restart isc-dhcp-server
systemctl status isc-dhcp-server

***

/etc/hosts

/etc/network/interfaces
```
auto lo
iface lo inet loopback

auto eth0 
iface eth0 inet static
    address 192.168.0.1
    netmask 255.255.255.0
    echo > 1 /procs/sys/net/ipv4/ip_forward
```

/etc/dhcp/dhcpd.conf


***

choisir addresses :
dhcp1 : ip addr add 192.168.1.1/24 dev eth0
dhcp2 : ip addr add 192.168.2.1/24 dev eth0