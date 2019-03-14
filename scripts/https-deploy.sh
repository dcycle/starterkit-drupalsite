#!/bin/bash
#
# Set everything up for local https development.
# See https://blog.dcycle.com/blog/2018-10-27
# See https://github.com/dcycle/starterkit-drupal8site/blob/master/scripts/https-deploy.sh
#
# This file originally lives on https://github.com/dcycle/starterkit-drupal8site/blob/master/scripts/https-deploy.sh.
#
set -e

export BASE="$(pwd)"

echo ''
echo '===SETTING UP LOCAL HTTPS DEVELOPMENT==='
echo 'See https://blog.dcycle.com/blog/2018-10-27 for details.'
echo ''
echo '---PREFLIGHT: ./docker-compose.yml---'
echo 'Making sure our ./docker-compose.yml file contains VIRTUAL_HOST; if'
echo 'it does not, that might mean you copied this script fom'
echo 'https://github.com/dcycle/starterkit-drupal8site/blob/master/scripts/https-deploy.sh'
echo 'without adding these lines to your docker-compose file:'
echo '    environment:'
echo '      # The virtual host is used when we want to access our site via an'
echo '      # Nginx Proxy locally; and is required by the script'
echo '      # ./scripts/https-deploy.sh.'
echo '      # See https://blog.dcycle.com/blog/2018-10-27 for details.'
echo '      - VIRTUAL_HOST=''$''{VIRTUAL_HOST}'
if [ -f ./docker-compose.yml ]; then
  echo 'Compose file exists, moving on.'
else
  >&2 echo './docker-compose.yml file does not exist.'
  >&2 echo 'Please make sure it looks like'
  >&2 echo  'https://github.com/dcycle/starterkit-drupal8site/blob/master/docker-compose.yml'
  exit 1
fi
grep 'VIRTUAL_HOST' docker-compose.yml && VHEXISTS=1 || VHEXISTS=0
if [ "$VHEXISTS" == 1 ]; then
  echo 'Compose file contains VIRTUAL_HOST, moving on.'
else
  >&2 echo './docker-compose.yml file does not contain VIRTUAL_HOST.'
  >&2 echo 'Please make sure it looks like'
  >&2 echo  'https://github.com/dcycle/starterkit-drupal8site/blob/master/docker-compose.yml'
  exit 1
fi
echo ''
echo '---PREFLIGHT: ./scripts/deploy.sh---'
echo 'Making sure our ./scripts/deploy.sh file exists; if'
echo 'it does not, that might mean you copied this script fom'
echo 'https://github.com/dcycle/starterkit-drupal8site/blob/master/scripts/https-deploy.sh'
echo 'but you do not have ./scripts/deploy.sh in your project.'
if [ -f ./scripts/deploy.sh ]; then
  echo './scripts/deploy.sh exists, moving on.'
else
  >&2 echo './scripts/deploy.sh file does not exist.'
  >&2 echo 'Please make sure it lauches your project on a random port.'
  >&2 echo 'It can look like'
  >&2 echo  'https://github.com/dcycle/starterkit-drupal8site/blob/master/scripts/deploy.sh'
  exit 1
fi
echo ''
echo '---DETERMINE LOCAL DOMAIN---'
source ./scripts/lib/set-local-domain.sh
if [ "$VIRTUAL_HOST" == localhost ]; then
  while [ -z "$DOMAIN" ]; do
    echo "Enter a domain and we'll add it to $ENVFILELOCATION"
    echo "We need a domain to access your local development environment. This"
    echo "is because there is only one secure (443) port on your computer, and"
    echo "you might have several applications running. They are distinguished"
    echo "by domain name."
    echo ''
    echo "For example, type 'my-website.local':"
    echo ''
    echo "**YOU NEED TO USE THE FORMAT my-website.local, WITH A DOT!**"
    echo ''
    read DOMAIN
  done
  echo "You entered $DOMAIN"
  LINE="VIRTUAL_HOST=$DOMAIN"
  echo "$LINE" >> "$ENVFILELOCATION"
  echo "We entered $LINE in $ENVFILELOCATION"
  source "$ENVFILELOCATION"
fi
if [ -z "$VIRTUAL_HOST" ]; then
  >&2 echo "Unexpected error: VIRTUAL_HOST does not exist"
  exit 1
fi
ETCHOSTSLINE="127.0.0.1 $VIRTUAL_HOST"
ETCHOSTSGREP="127.0.0.1 *$VIRTUAL_HOST"
grep "$ETCHOSTSGREP" /etc/hosts && ETCHOSTSEXISTS=1 || ETCHOSTSEXISTS=0
if [ "$ETCHOSTSEXISTS" == 0 ]; then
  echo "$ETCHOSTSLINE does not exist in /etc/hosts"
  echo "We will attempt to add it; you might be prompted for your password."
  sudo bash -c "echo $ETCHOSTSLINE >> /etc/hosts"
else
  echo "$ETCHOSTSLINE exists in /etc/hosts"
fi
echo "Local domain is $VIRTUAL_HOST"
echo ''
echo '---(RE-)STARTING OUR PROJECT---'
./scripts/deploy.sh
echo ''
echo '---FINDING THE NETWORK NAME---'
# Linter says "^-- SC2046: Quote this to prevent word splitting". on the
# following line; not sure why...
# shellcheck disable=SC2046
NETWORK=$(docker container inspect $(docker-compose ps -q drupal) -f "{{json .NetworkSettings.Networks }}" | sed 's/^{"//g' | sed 's/".*$//g')
if [ -z "$NETWORK" ]; then
  >&2 echo "Unexpected error: NETWORK cannot be found"
  exit 1
fi
echo "Network is $NETWORK"
echo ''
echo '---STARTING NGINX REVERSE PROXY---'
echo 'First check if the reverse proxy is running'
docker container ls -f 'name=/nginx-proxy' | grep nginx-proxy && RUNNING=1 || RUNNING=0
if [ "$RUNNING" == 0 ]; then
  echo 'nginx-proxy is not running'
  echo 'checking if nginx-proxy exists'
  docker container ls -a -f 'name=/nginx-proxy' | grep nginx-proxy && EXISTS=1 || EXISTS=0
  if [ "$EXISTS" == 0 ]; then
    docker run -d -p 80:80 -p 443:443 \
      --name nginx-proxy \
      -v "$HOME"/.docker-compose-certs:/etc/nginx/certs:ro \
      -v /etc/nginx/vhost.d \
      -v /usr/share/nginx/html \
      -v /var/run/docker.sock:/tmp/docker.sock:ro \
      jwilder/nginx-proxy
  else
    echo 'nginx-proxy exists but is not running; start it'
    docker start nginx-proxy
  fi
else
  echo 'nginx-proxy is running'
fi
echo ''
echo '---ATTACHING THE PROXY TO THE DOCKER NETWORK---'
docker network connect "$NETWORK" nginx-proxy 2>/dev/null && echo "Successfully connected $NETWORK to nginx-proxy" || echo "$NETWORK seems to already be attached to nginx-proxy; moving on."
echo ''
echo '---ACCESSING YOUR APPLICATION ON PORT 80---'
echo "Your application should be accessible on http://$VIRTUAL_HOST"
curl -I "http://$VIRTUAL_HOST"
echo ''
echo '---MAKING SURE A CERT EXISTS TO ACCESS YOUR APP ON PORT 443---'
CERTSDIR="$HOME/.docker-compose-certs"
echo "Certs directory is $CERTSDIR"
ls "$CERTSDIR/$VIRTUAL_HOST.crt" 2>/dev/null && CERTEXISTS=1 || CERTEXISTS=0
if [ "$CERTEXISTS" == 0 ]; then
  echo "$CERTSDIR/$VIRTUAL_HOST.crt does not exist, will attempt to create it"
  docker run -v "$CERTSDIR:/certs"  jwilder/nginx-proxy /bin/bash -c "cd /certs && openssl req -x509 -out $VIRTUAL_HOST.crt -keyout $VIRTUAL_HOST.key -newkey rsa:2048 -nodes -sha256 -subj '/CN=localhost' -extensions EXT -config <(printf "'"'"[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:$VIRTUAL_HOST\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth"'"'")"
else
  echo "$CERTSDIR/$VIRTUAL_HOST.crt exists"
fi
echo "Restarting nginx-proxy"
docker restart nginx-proxy
echo ''
echo '---ACCESSING YOUR APPLICATION ON PORT 443---'
echo "Your application should be accessible on https://$VIRTUAL_HOST"
curl -I --insecure "https://$VIRTUAL_HOST"
echo ''
echo '---NEXT STEPS---'
echo "Your application should now be available at:"
echo ''
echo " ==> (secure) https://$VIRTUAL_HOST (*)"
echo " ==> (insecure) http://$VIRTUAL_HOST"
echo ''
echo '(*) The key is self-signed so your browser will say it is not'
echo '    recognized; you will need to manually accept it.'
echo ''
echo 'You can run ./scripts/uli.sh to get a one-time login link.'
echo ''
echo 'HAPPY CODING!'
echo ''
