#!/bin/sh

domain_name=$1
if result=$(curl -X POST "https://api.cloudflare.com/client/v4/zones/59d02e76694ffce8068b0164bc3caca1/dns_records" \
-H "X-Auth-Email: ferdian.robianto@acommerce.asia" \
-H "X-Auth-Key: 5c70a8bb0973f324559716718edd7c4984c85" \
-H "Content-Type: application/json" \
--data '{"type":"A","name":"'$domain_name'","content":"103.23.21.224","ttl":600}');then
  echo Succeed for add domain
else
  echo Failed for add domain
fi
