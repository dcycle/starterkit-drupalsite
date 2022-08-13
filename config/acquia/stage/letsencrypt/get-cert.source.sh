docker run --rm -it -v "$BASE/do-not-commit/certs/$ACQUIAENV":/etc/letsencrypt -p 443:443 certbot/certbot certonly \
  -d example.com \
  -d www.example.com \
  -d put.any.number.of.urls.here \
  -d one.of.the.urls.in.get-cert.source.sh \
  --manual
