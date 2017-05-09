#!/bin/bash
email="$1"

#passwordgenerator
password=$(pwgen -1)

#createusername/password
username=$(echo $email | cut -d'@' -f1)
sudo useradd $username -p $password

bodymail="

Please find Your detail below : \n

\nusername : $username
\npassword : $password

\n\nPlease use the certificate on the attachment.
\nnote : linux (.conf), windows (.ovpn), you can import those certificate to openvpn client"

echo  -e $bodymail | mutt -a "/home/ec2-user/acom-aws-vpn.conf" -a "/home/ec2-user/acom-aws-vpn.ovpn" -s "Acom ID VPN" -- $email
