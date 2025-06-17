hostnamectl set-hostname ISP; exec bash
mkdir /etc/net/ifaces/ens18
mkdir /etc/net/ifaces/ens19
mkdir /etc/net/ifaces/ens20
echo -e 'TYPE=eth\nBOOTPROTO=dhcp' | tee /etc/net/ifaces/ens18/options
echo 'TYPE=eth\nBOOTPROTO=static' | tee /etc/net/ifaces/ens19/options
echo 'TYPE=eth\nBOOTPROTO=static' | tee /etc/net/ifaces/ens20/options
echo 172.16.4.1/28 > /etc/net/ifaces/ens20/ipv4address
echo 172.16.5.1/28 > /etc/net/ifaces/ens21/ipv4address
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf
systemctl restart network
apt-get update && apt-get install iptables
echo 1 | tee /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o ens19 -j MASQUERADE
iptables -A FORWARD -i ens20 -o ens19 -j ACCEPT
iptables -A FORWARD -i ens21 -o ens19 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens19 -j MASQUERADE
echo 1 | tee /proc/sys/net/ipv4/ip_forward
timedatectl set-timezone Europe/Moscow