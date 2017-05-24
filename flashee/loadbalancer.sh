#!/bin/bash
BASEDIR=$(dirname "$0")
domain_name="$1"
store_id="$2"
condition="$3"
sslstatus="$4"

if [ "$3" = "PUT" ]
then
    echo "Delete Store ID '$2'"
    #unlink /etc/nginx/sites-enabled/${store_id}.conf
    #rm -rfv /etc/nginx/sites-available/${store_id}.conf
    #sh /home/martonowibowo/Documents/shellscript/flashee/delete_zone.sh ${domain_name}

elif [ "$3" = "POST" ]
  then
      #echo "Insert"
      a+="\tupstream frontend {\n
   \tserver 172.31.31.59;\n
\t}\n"
if [ "$4" = YES ]
then
    a+="server {\n
	\tlisten 80;\n
	\tserver_name ${domain_name};\n
	\treturn 301 https://\$host\$request_uri;\n
        }\n\n"
else
a+="server {"
fi

if [ "$4" = "YES" ]
 then
   a+="
   \n\tserver {
   \n\t\tlisten 443 ssl;\n

\n\t\tssl on;\n
    \t\tssl_certificate      /etc/nginx/ssl/${domain_name}.crt; \n
    \t\tssl_certificate_key  /etc/nginx/ssl/${domain_name}.key; \n

\t\tssl_protocols TLSv1.2 TLSv1.1 TLSv1 SSLv2; \n
\t\tssl_prefer_server_ciphers on; \n
\t\tssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS; \n

    \t\tssl_session_cache shared:SSL:1m; \n
    \t\tssl_session_timeout  5m; \n\n\n
"
else
 a+="\n\t\tlisten 80;\n"
fi


    a+="
    \t\tlocation / {\n

 \n\tproxy_read_timeout 300;
 \n\tproxy_connect_timeout 300;
 \n\tproxy_redirect off;

 \n\n\tproxy_set_header Host \$host;
 \n\tproxy_set_header X-Real-IP \$remote_addr;
 \n\tproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; "

if [ "$4" = "YES" ]
  then
    a+="\n\tproxy_set_header X-Forwarded-Proto https;"
else
a+=""
fi

 a+="\n\tproxy_set_header X-Frame-Options SAMEORIGIN;

\n\tproxy_pass http://frontend/;

 \n\texpires max;
 \n\tadd_header Pragma public;
 \n\tadd_header Cache-Control 'public, must-revalidate, proxy-revalidate';

\n\n\t}

\n\t}
"
echo -e $a > $BASEDIR/tmp/$2.conf
              scp $BASEDIR/tmp/$2.conf root@172.17.0.2:/etc/nginx/sites-enabled/ #sh /home/martonowibowo/Documents/shellscript/flashee/add_zone.sh ${domain_name}
              ssh -t root@172.17.0.2 /etc/init.d/nginx reload
  else
echo '{"error":true,"message":"Check Your Input - FAILED"}'
  fi
