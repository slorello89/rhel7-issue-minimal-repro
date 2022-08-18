#Launch the container
echo starting container
docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 9443:9443 -p 12000:12000 redislabs/redis
sleep 20
echo create cluster
# Create cluster
docker exec -ti rp rladmin cluster create name rlec.local username admin@redis.com password 123
sleep 20
echo create database
# Create database on port 12000
curl -k  -X POST -H "Content-type:application/json" -u admin@redis.com:123  'https://localhost:9443/v1/bdbs' -d '{"name": "test-database", "type": "redis", "memory_size": 104857600, "port": 12000, "enforce_client_authentication": "disabled", "tls_mode": "enabled"}'

echo test ECDHE
#TEST SSL (ECDHE should work as it's running on Ubuntu 18.04):
echo -e "PING\r\n" | openssl s_client -connect localhost:12000 -ign_eof -cipher ECDHE-RSA-AES256-GCM-SHA384 -tls1_2

echo Restrict
#Restrict SSL to AES128-SHA:AES256-SHA ciphers 
docker exec -ti rp rladmin cluster config data_cipher_list AES128-SHA256:AES256-SHA256

echo test ECDHE again
#ECDHE should fail now
echo -e "PING\r\n" | openssl s_client -connect localhost:12000 -ign_eof -cipher ECDHE-RSA-AES256-GCM-SHA384 -tls1_2

echo try AES256-SHA
# AES256-SHA should be fine
echo -e "PING\r\n" | openssl s_client -connect localhost:12000 -ign_eof -cipher AES256-SHA256 -tls1_2