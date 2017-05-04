#!/bin/bash
BASEDIR=$(dirname "$0")
domain_name="$1"
folder="/opt/public_html/flashee/current/"
ipserver="103.23.21.224"
store_id="$2"
condition="$3"
sslstatus="$4"

if [ "$3" = "PUT" ]
then
    #echo "Delete Store ID '$2'"
    unlink /etc/nginx/sites-enabled/${store_id}.conf
    rm -rfv /etc/nginx/sites-available/${store_id}.conf
    #sh /home/martonowibowo/Documents/shellscript/flashee/delete_zone.sh ${domain_name}

elif [ "$3" = "POST" ]
  then
    echo "
         server {
                     listen 80;

                 server_name ${domain_name};
                 root ${folder};

                access_log /var/log/nginx/${domain_name}_access.log;
              	error_log	/var/log/nginx/${domain_name}_error.log;

         	location / {
                 index index.html index.php; ## Allow a static html file to be shown first
                 try_files \$uri \$uri/ @handler; ## If missing pass the URI to Magento's front handler
                 expires 30d; ## Assume all files are cachable
             }

             location  /. { ## Disable .htaccess and otheric hidden files
                 return 404;
             }

             location @handler { ## Magento uses a common front handler
                 rewrite / /index.php;
             }

             location ~ .php/ { ## Forward paths like /js/index.php/x.js to relevant handler
                 rewrite ^(.*.php)/ \$1 last;
             }

             set \$ssl 'off';
             if (\$http_x_forwarded_proto = 'https') {
               set \$ssl 'on';
                }

             location ~ .php\$ { ## Execute PHP scripts
                 if (!-e \$request_filename) { rewrite / /index.php last; } ## Catch 404s that try_files miss

                 expires        off; ## Do not cache dynamic content
                 fastcgi_pass   127.0.0.1:9000;
                 fastcgi_param HTTPS $ssl;
                 fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
             	   include        fastcgi_params; ## See /etc/nginx/fastcgi_params
                 fastcgi_send_timeout 300s;
         	       fastcgi_read_timeout 300s;
                 fastcgi_param  STORE_ID  '${store_id}';
                 fastcgi_param  STORE_DOMAIN  '${domain_name}';
                 fastcgi_param  BASE_URL 'https://${domain_name}/';
         	}
         }
         " > /etc/nginx/sites-available/$2.conf

    if symlink=$(ln -svf /etc/nginx/sites-available/$2.conf /etc/nginx/sites-enabled/ 2>&1 );then
        echo $symlink
                #restart_nginx=$(/etc/init.d/nginx reload)
                echo $restart_nginx
                #sh $BASEDIR/add_zone.sh ${domain_name}
                $BASEDIR/loadbalancer.sh ${domain_name} POST ${sslstatus}
      else
        echo '{"error":true,"message":"'$symlink'-FAILED"}'
      fi
  else
echo '{"error":true,"message":"Check Your Input - FAILED"}'
  fi
