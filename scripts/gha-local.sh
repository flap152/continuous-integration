#! /usr/bin/env bash

cd $(dirname -- "$0")/.. || exit 1

export ACT_CACHE_AUTH_KEY=foo
export CHROME_DRIVER_LOG=storage/logs/chromedriver.log

#ensure docker desktop/backend is started
open -g -a docker && while ! docker info > /dev/null 2>&1; do sleep 1 ; done

#act -W ./.github/workflows/laravel.yml  -j laravel-tests --env-file=.env.bak -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 --privileged -P'
#./vendor/laravel/dusk/bin/chromedriver-mac-arm --port=9517 --whitelisted-ips= --allowed-origins=* --verbose

# Conditionnally launch chromedribver for dockerized tests
php artisan dusk:chrome-driver
curl localhost:9517/status || ./vendor/laravel/dusk/bin/chromedriver-mac-arm --port=9517 --whitelisted-ips= --allowed-origins=*  > ${CHROME_DRIVER_LOG} 2>&1  &
#./vendor/laravel/dusk/bin/chromedriver-mac-arm --port=9517 --whitelisted-ips= --allowed-origins='*'  > storage/logs/chromedriver.log 2>&1  &
sleep 2; curl localhost:9517/status || exit 23
#act -W ./.github/workflows/laravel.yml  -j laravel-tests --env-file=.env.bak -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 --privileged -P'
#act -W ./.github/backup/laravelWithLocal.yml  -j laravel-tests --env-file=.env.localci -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 -p 3606:3606 --privileged -P'
act -W ./.github/backup/laravelWithLocal.yml  -j laravel-tests --env-file=.env.localci -s GITHUB_TOKEN="$(gh auth token)" --container-options='-p 8000:8000 -p 3606:3606 --privileged -P'
