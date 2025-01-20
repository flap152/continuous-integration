#! /usr/bin/env bash

#start local cache server, as per https://github.com/NoahHsu/github-act-cache-server
# build image and start a container(listen 8080 port) - changed to 8101 bc conflits
echo $CACHE_SERVER_PATH
cd $CACHE_SERVER_PATH
export PORT=8101

#curl -X POST http://localhost:8101/_apis/artifactcache/cache?keys=composer-cache-b89b32c36539ede72fa67d803f95aab95a27a0fcc5c78bcc944ab6ab172286c2%252Ccomposer-cache-&version=e26f2152f1a517079424d03ea43b19c95d245c2ff82b8adaa356e0146502f191
curl http://localhost:8101/ && echo Yes!
curl http://localhost:8101/ || docker compose up --build

sleep 5

curl http://localhost:8101/ && echo Yes! it is working!!!
curl -X POST  "http://localhost:8101/_apis/artifactcache/clean" && echo Cleared the cache

#curl -X POST http://localhost:8101/_apis/artifactcache/ping && echo Yes!


#docker compose up --build
