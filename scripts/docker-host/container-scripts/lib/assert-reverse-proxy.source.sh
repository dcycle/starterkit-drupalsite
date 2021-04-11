#
# Make sure the reverse proxy is running.
# See https://blog.dcycle.com/blog/170a6078/letsencrypt-drupal-docker/.
#

echo " ====> Checking for the reverse proxy"

CREATREREVERSE=0
docker ps | grep nginx-proxy || CREATREREVERSE=1

if [ "$CREATREREVERSE" == 1 ]; then
  echo " Reverse proxy does not exist. Creating it."
  mkdir -p "$HOME"/certs
  docker run -d -p 80:80 -p 443:443 \
    --name nginx-proxy \
    -v "$HOME"/certs:/etc/nginx/certs:ro \
    -v /etc/nginx/vhost.d \
    -v /usr/share/nginx/html \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy \
    --restart=always \
    jwilder/nginx-proxy
  docker run -d \
    --name nginx-letsencrypt \
    -v "$HOME"/certs:/etc/nginx/certs:rw \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --volumes-from nginx-proxy \
    --restart=always \
    jrcs/letsencrypt-nginx-proxy-companion
else
  echo " Reverse proxy already exists; moving on."
fi
