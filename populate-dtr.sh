#!/bin/sh

# Usage/help text
usage_text () {
    echo -e "Usage: docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -H <hostname>:<port> -u <username> -p <password>"
    exit 1
}

while getopts "hu:p:H:" opt; do
  case $opt in
    h)
      usage_text
      ;;
    u)
      DTR_USER="$OPTARG"
      ;;
    p)
      DTR_PASSWORD="$OPTARG"
      ;;
    H)
      DTR_URL="$OPTARG"
      ;;
    \?)
      usage_text
      exit 1
      ;;
    :)
      echo -e "Option -$OPTARG requires an argument." >&2
      exit 1;
      ;;
    esac
done

# Check for docker socket
if [ ! -e "/var/run/docker.sock" ]; then
    echo -e "Docker not detected, did you forget to mount docker.sock?"
    exit 1
fi

# Check for DTR_URL
if [ -z "$DTR_URL" ]; then
    echo -e "Option -H requires an argument: a DTR URL is required"
    exit 1
fi

# Populate commonly used defaults if they aren't already set
if [ -z "DTR_USER" ]; then
    DTR_USER="admin"
    echo -e "Using default username: $DTR_USER"
fi

if [ -z "DTR_PASSWORD" ]; then
    DTR_PASSWORD="foobarfun"
    echo -e "Using default password: $DTR_PASSWORD"
fi

# Login
echo -e "Logging into $DTR_URL as $DTR_USER"
if ! docker login $DTR_URL -u $DTR_USER -p $DTR_PASSWORD >/dev/null; then
    echo -e "Unable to login to $DTR_URL"
    exit 1
fi

# Pull several different images and some tags from hub
echo -e 'Pulling several different images and tags...'
docker pull nginx
docker pull alpine
docker pull ubuntu
docker pull fedora:26
docker pull fedora:27
docker pull fedora
docker pull redis

# Tag and push the pulled images with the defined user
echo -e "Pushing the pulled images as $DTR_USER..."
IMAGES=$(docker images -a | egrep -vi 'docker|repository' | awk '{print $1":"$2}')
for image in $IMAGES
do
    docker tag $image $DTR_URL/$DTR_USER/$image
done

IMAGES_NEW=$(docker images -a | grep $DTR_URL | awk '{print $1}')
for image in $IMAGES_NEW
do
    docker push $image
done
