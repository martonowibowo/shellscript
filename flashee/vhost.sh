#!/bin/bash

domain_name="$1"
folder="/opt/public_html/flashee/current/"
ipserver="103.23.21.224"
store_id="$2"
condition="$3"
sslstatus="$4"

if [ "$3" = "PUT" ]
then
    #echo "Delete Store ID '$2'"
    rm -rfv /etc/nginx/sites-available/$3.conf
    #sh /home/martonowibowo/Documents/shellscript/flashee/delete_zone.sh ${domain_name}

elif [ "$3" = "POST" ] 
  then
      #echo "Insert"
      a=""
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
   a+="\n\t\tlisten 443 ssl;\n

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
	     \t\tserver_name ${domain_name};\n
              \t\troot ${folder};\n\n

	\t\t access_log /var/log/nginx/${domain_name}_access.log buffer=4k;\n
	\t\t error_log	/var/log/nginx/${domain_name}_error.log buffer=4k;\n\n

      	\tlocation / {\n
              \t\tindex index.html index.php; ## Allow a static html file to be shown first\n
              \t\ttry_files \$uri \$uri/ @handler; ## If missing pass the URI to Magento's front handler\n
              \t\texpires 30d; ## Assume all files are cachable\n
          \t}\n\n

          \tlocation  /. { ## Disable .htaccess and otheric hidden files\n
            \t\t  return 404;\n
          \t}\n\n

          \tlocation @handler { ## Magento uses a common front handler\n
              \t\trewrite / /index.php;\n
          \t}\n\n

          \tlocation ~ .php/ { ## Forward paths like /js/index.php/x.js to relevant handler\n
            \t\t  rewrite ^(.*.php)/ \$1 last;\n
          \t}\n\n

          \tlocation ~ .php\$ { ## Execute PHP scripts\n
              \t\tif (!-e \$request_filename) { rewrite / /index.php last; } ## Catch 404s that try_files miss\n

              \t\texpires        off; ## Do not cache dynamic content\n
              \t\tfastcgi_pass   127.0.0.1:9000;\n
              \t\tfastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;\n
              \t\tfastcgi_param  MAGE_RUN_TYPE store;\n
              \t\tinclude        fastcgi_params; ## See /etc/nginx/fastcgi_params\n
              \t\tfastcgi_send_timeout 300s;\n
      	      \t\tfastcgi_read_timeout 300s;\n
              \t\tfastcgi_param  STORE_ID  '${store_id}';\n
              \t\tfastcgi_param  STORE_DOMAIN  '${domain_name}';\n "

if [ "$4" = "YES" ]
 then
a+="	      \t\tfastcgi_param  BASE_URL 'https://${domain_name}/';\n
      	\t}\n
      }"
else
a+="         \t\tfastcgi_param  BASE_URL 'http://${domain_name}/';\n
        \t}\n
      }"
fi 

echo -e $a > /etc/nginx/sites-available/$2.conf
      sleep 1
    if symlink=$(ln -svf /etc/nginx/sites-available/$2.conf /etc/nginx/sites-enabled/ 2>&1 );then
        echo $symlink
        sleep 1
          restart_nginx=$(/etc/init.d/nginx reload)
                echo $restart_nginx
                #sh /home/martonowibowo/Documents/shellscript/flashee/add_zone.sh ${domain_name}
      else
        echo '{"error":true,"message":"'$symlink'-FAILED"}'
      fi
  else
echo '{"error":true,"message":"Check Your Input - FAILED"}'
  fi
