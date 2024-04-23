#!/bin/sh
# v1.0

COMMAND="build"
DIR=`pwd`
VERSION=`basename "$DIR"`
DIR=`dirname "$DIR"`
IMAGE=`basename "$DIR"`
TAG="${IMAGE}:${VERSION}"
DETACH="-it --rm"
NAME="-temp"

while [ $# -gt 0 ]; do
  case "$1" in
    --help|-h)
      echo "usage: $0"
      echo "	--command|-c  COMMAND [${COMMAND}]"
      echo "	--run|-r      COMMAND=run"
      echo "	--version     VERSION [${VERSION}]"
      echo "	--image|-i    IMAGE [${IMAGE}]"
      echo "	--tag|-t      TAG [${TAG}]"
      echo "	--volume|-v   VOLUME [${VOLUME}]"
      echo "	--port|-p     PORT [${PORT}]"
      echo "	-d            DETACH [${DETACH}]"
      echo "	extra         TAG-EXTRA"
      exit
      ;;
    --run|-r)
      COMMAND="run"
      ;;
    --command|-c)
      shift
      COMMAND=$1
      ;;
    --version)
      shift
      VERSION=$1
      TAG="${IMAGE}:${VERSION}"
      ;;
    --image|-i)
      shift
      IMAGE=$1
      TAG="${IMAGE}:${VERSION}"
      ;;
    --tag|-t)
      shift
      TAG=$1
      ;;
    --volume|-v)
      shift
      VOLUME="$VOLUME -v $1"
      ;;
    --port|-p)
      shift
      PORT="$PORT -p $1"
      ;;
    -d)
      DETACH="-d"
      NAME=""
      ;;
    *)
      TAG=${TAG}-$1
      ;;
  esac
  shift
done

if [ "${COMMAND}" = "build" ]; then
	echo docker build -t ${TAG} .
	docker build -t ${TAG} .
elif [ "${COMMAND}" = "run" ]; then
	echo docker run ${DETACH} --name ${IMAGE}${NAME} ${PORT} ${VOLUME} ${TAG}
	docker run ${DETACH} --name ${IMAGE}${NAME} ${PORT} ${VOLUME} ${TAG}
fi
