#! /usr/bin/env bash

cd $(dirname -- "$0")/.. || exit 1

export ACT_CACHE_AUTH_KEY=foo
export CHROME_DRIVER_LOG=storage/logs/chromedriver.log

#start local cache server, as per https://github.com/NoahHsu/github-act-cache-server
# build image and start a container(listen 8080 port) - changed to 8101 bc conflits
CACHE_SERVER_PATH=/Users/frank/dev/Gits/tests/github-act-cache-server sh -x ./scripts/cache-server.sh &
sleep 3
# Confirm cache server is up or exit
curl http://localhost:8101/ || exit 21


#ensure docker desktop/backend is started
open -g -a docker && while ! docker info > /dev/null 2>&1; do sleep 1 ; done

#act -W ./.github/workflows/laravel.yml  -j laravel-tests --env-file=.env.bak -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 --privileged -P'
#./vendor/laravel/dusk/bin/chromedriver-mac-arm --port=9517 --whitelisted-ips= --allowed-origins=* --verbose

# Conditionnally launch chromedribver for dockerized tests
#php artisan dusk:chrome-driver
#curl localhost:9517/status || ./vendor/laravel/dusk/bin/chromedriver-mac-arm --port=9517 --whitelisted-ips= --allowed-origins=*  > ${CHROME_DRIVER_LOG} 2>&1  &
#./vendor/laravel/dusk/bin/chromedriver-mac-arm --port=9517 --whitelisted-ips= --allowed-origins='*'  > storage/logs/chromedriver.log 2>&1  &
#sleep 2; curl localhost:9517/status || exit 23

#cp .env .env.bak
#act -W ./.github/workflows/laravel.yml  -j laravel-tests --env-file=.env.bak -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 --privileged -P'
#act -W ./.github/backup/laravelWithLocal.yml  -j laravel-tests --env-file=.env.localci -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 -p 3606:3606 --privileged -P'
act -W ./.github/workflows/tests.yml  --env-file=.env.bak -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 -p 3606:3606 --privileged -P'
