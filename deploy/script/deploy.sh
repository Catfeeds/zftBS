#! /bin/bash

IMAGE_VERSION=${1:-latest}
REPO=registry.docker-cn.com/kpse/zftBS
docker pull $REPO:$IMAGE_VERSION

function start () {
  docker rm -f api
  docker rmi $(docker images -qf "before=$REPO:$IMAGE_VERSION" -f=reference="$REPO:v*")
  docker run -v /etc/localtime:/etc/locatime -e ALI_KEY -e ALI_SECRET -e ENV -e REDIS_HOST -e REDIS_PORT -e REDIS_PASSWD -e ZFT_AMAP_KEY -e ZFT_EM_READ -e ZFT_EM_WRITE -d -p 8000:8000 \
  	--name=api --net=zft  $REPO:$IMAGE_VERSION

}
function test_deploy() {
  docker rm -f test_api_deploy
  docker run -v /etc/localtime:/etc/locatime -e ALI_KEY -e ALI_SECRET -e ENV -e REDIS_HOST -e REDIS_PORT -e REDIS_PASSWD -e AMAPKEY -e ZFT_AMAP_KEY -e ZFT_EM_READ -e ZFT_EM_WRITE -d \
  	--name=test_api_deploy -p 8090:8000 $REPO:$IMAGE_VERSION
}

function test_curl() {
  response=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost:8090/v1.0/healthCheck)
  if [[ $response == "200" ]]; then
    echo successful test curl && docker rm -f test_api_deploy;
  else
    echo failed test curl && exit 1;
  fi
}

test_deploy

sleep 5 

test_curl && start