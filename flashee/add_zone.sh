#!/bin/sh
domain_name=$1
if echo "${domain_name}" | grep -q "acomindo"
  then
    if result=$(curl -X POST "https://api.cloudflare.com/client/v4/zones/59d02e76694ffce8068b0164bc3caca1/dns_records" \
    -H "X-Auth-Email: " \
    -H "X-Auth-Key: " \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'$domain_name'","content":"103.23.21.224","ttl":600}' | grep null);then
      echo '{"error":true,"message":"DOMAIN ADD FAILED"}'
    else
      echo '{"error":"false","message":"SUCCESS"}' >> /var/log/create_store.log
    fi
  else
    echo '{"error":false,"message":"SUCCESS"}' >> /var/log/create_store.log
fi
