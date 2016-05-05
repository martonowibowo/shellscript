#!/bin/bash

domain_name="$1"
folder="/opt/public_html/flashe"
ipserver="103.23.21.224"
store_id="$2"
condition="$3"

if [ "$3" = "PUT" ]
then
    echo "Delete Store ID '$2'"
    rm -rf /etc/nginx/sites-available/$3.conf
    sh delete_zone.sh ${domain_name}

elif [ "$3" = "POST" ]
  then
      echo "Insert"
      echo "
      server {
                  listen 80;

              domain_name ${domain_name};
              root ${folder};

      	location / {
              index index.html index.php; ## Allow a static html file to be shown first
              try_files \$uri \$uri/ @handler; ## If missing pass the URI to Magento's front handler
              expires 30d; ## Assume all files are cachable
          }

          }

          location  /. { ## Disable .htaccess and other hidden files
              return 404;
          }

          location @handler { ## Magento uses a common front handler
              rewrite / /index.php;
          }

          location ~ .php/ { ## Forward paths like /js/index.php/x.js to relevant handler
              rewrite ^(.*.php)/ \$1 last;
          }

          location ~ .php\$ { ## Execute PHP scripts
              if (!-e \$request_filename) { rewrite / /index.php last; } ## Catch 404s that try_files miss

              expires        off; ## Do not cache dynamic content
              fastcgi_pass   127.0.0.1:9000;
              fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
              fastcgi_param  MAGE_RUN_TYPE store;
          	  include        fastcgi_params; ## See /etc/nginx/fastcgi_params
              fastcgi_send_timeout 300s;
      	      fastcgi_read_timeout 300s;
      	      fastcgi_param PHP_VALUE 'realpath_cache_size = 100K \n realpath_cache_ttl = 7200';
              fastcgi_param  STORE_ID  '${store_id}';
              fastcgi_param  STORE_DOMAIN  '${domain_name}';
      	}
      }
      " > /etc/nginx/sites-available/$2.conf
      sleep 1
      ln -svf /etc/nginx/sites-available/$2.conf /etc/nginx/sites-enabled/
      sleep 1
      /etc/init.d/nginx reload
      sleep 1
      sh add_zone.sh ${domain_name}
  else
      echo "Wrong Condition"
  fi
