#!/bin/bash
apt install apache2 bind9 dnsutils ssh vsftpd -y

#VSFTPD
touch /etc/vsftpd.chroot_list
echo -n "root" > /etc/vsftpd.chroot_list
sed  -i 's/listen=NO/listen=YES/g' /etc/vsftpd.conf
sed  -i 's/listen_ipv6=YES/listen_ipv6=NO/g' /etc/vsftpd.conf
sed  -i 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf
sed  -i 's/#chroot_local_user=YES/chroot_local_user=YES/g' /etc/vsftpd.conf
sed  -i 's/#chroot_list_enable=YES/chroot_list_enable=YES/g' /etc/vsftpd.conf
#RESTART SERVICE
systemctl restart vsftpd.service
#SSH
sed  -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart ssh
#DNS
cp /etc/bind/db.127 /etc/bind/db.10
cp /etc/bind/db.local /etc/bind/db.risco
sed  -i 's/localhost/risco-28.sch.id/g' /etc/bind/db.10
sed  -i 's/localhost/risco-28.sch.id/g' /etc/bind/db.risco
sed  -i 's/1.0.0/6/g' /etc/bind/db.10
sed  -i 's/127.0.0.1/10.21.28.6/g' /etc/bind/db.risco
sed  -i 's/localhost/risco-28.sch.id/g' /etc/bind/named.conf.default-zones
sed  -i 's/zone "127.in-addr.arpa"/zone "28.21.10.in-addr.arpa"/g' /etc/bind/named.conf.default-zones
sed  -i 's/db.127/db.10/g' /etc/bind/named.conf.default-zones
sed  -i 's/db.local/db.risco/g' /etc/bind/named.conf.default-zones
echo -n "nameserver 10.21.28.6" > /etc/resolv.conf
sed  -i 's/nameserver 8.8.8.8//g' /etc/resolv.conf
systemctl restart named
#WEBSERVER
rm /var/www/html/index.html
touch /var/www/html/index.html 
cat <<EOF > /var/www/html/index.html
<h1>Selamat Datang</h1>
EOF
chmod 644 /var/www/html/index.html
systemctl restart apache2

