#!/bin/bash

domain_name="$1"

echo $domain_name

domain_id=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/59d02e76694ffce8068b0164bc3caca1/dns_records?type=A&name="${domain_name}"&page=1&per_page=20&order=type&direction=desc&match=all" \
-H "X-Auth-Email: " \
-H "X-Auth-Key: " \
-H "Content-Type: application/json" | tr -s ':'  ' ' | tr -s ','  ' ' | tr -s '"'  ' '|awk 'NR==1 {print $5}')
echo $domain_id
  if result=$(curl -X DELETE "https://api.cloudflare.com/client/v4/zones/59d02e76694ffce8068b0164bc3caca1/dns_records/$domain_id" \
  -H "X-Auth-Email: ferdian.robianto@acommerce.asia" \
  -H "X-Auth-Key: 5c70a8bb0973f324559716718edd7c4984c85" \
  -H "Content-Type: application/json" | grep -q "true"); then
    echo '{"error":failed,"message":"SUCCESS"}'
else
    echo  echo '{"error":true,"message":"DOMAIN NOT FOUND - FAILED"}'
fi
