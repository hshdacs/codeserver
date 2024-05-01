#!/bin/sh
# v1.0

COMMAND="build"
VERSION="latest"
IMAGE=""
TAG=""
DETACH="-it --rm"
NAME="-temp"

while [ $# -gt 0 ]; do
  case "$1" in
    --help|-h)
      echo "usage: $0 [OPTIONS] DOCKERFILE_DIR"
      echo "  --command|-c  COMMAND [${COMMAND}]"
      echo "  --run|-r      COMMAND=run"
      echo "  --version     VERSION [${VERSION}]"
      echo "  --image|-i    IMAGE [${IMAGE}]"
      echo "  --tag|-t      TAG [${TAG}]"
      echo "  --volume|-v   VOLUME [${VOLUME}]"
      echo "  --port|-p     PORT [${PORT}]"
      echo "  -d            DETACH [${DETACH}]"
      echo "  extra         TAG-EXTRA"
      echo "DOCKERFILE_DIR: Path to the directory containing the Dockerfile"
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
      ;;
    --image|-i)
      shift
      IMAGE=$1
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
      DOCKERFILE_DIR=$1
      ;;
  esac
  shift
done

if [ -z "$DOCKERFILE_DIR" ]; then
  echo "Error: Dockerfile directory path is required!"
  exit 1
fi

# Extracting image name and version from the Dockerfile directory path
IMAGE=$(basename $(dirname "$DOCKERFILE_DIR"))
VERSION=$(basename "$DOCKERFILE_DIR")
TAG="${IMAGE}:${VERSION}"

if [ "${COMMAND}" = "build" ]; then
  echo "Building Docker image ${TAG} using Dockerfile in ${DOCKERFILE_DIR}"
  docker build -t ${TAG} ${DOCKERFILE_DIR}
elif [ "${COMMAND}" = "run" ]; then
  echo "Running Docker container from image ${TAG}"
  docker run ${DETACH} --name ${IMAGE}${NAME} ${PORT} ${VOLUME} ${TAG}
fi
