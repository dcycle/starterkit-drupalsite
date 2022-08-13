#!/bin/bash
#
# Script semi-automating the process of adding LetsEncrypt certificates to
# serve Acquia staging sites in HTTPS.
# See http://blog.dcycle.com/blog/2018-10-05/https-acquia-stage/
#
# See ./config/acquia/stage/letsencrypt, for example.
#
set -e

BASE="$PWD"

echo ' **** '
echo " SET UP LET'S ENCRYPT ON MY ACQUIA $ACQUIAENV SITE"
echo " See http://blog.dcycle.com/blog/2018-10-05/https-acquia-stage/"
echo " See https://gist.github.com/alberto56/80c418c656bdf218cae663c3ba227e9a"
echo " (requires Docker)"
echo ' **** '

if [ -z "$ACQUIAENV" ]; then
  >&2 echo "To use this, please run 'export ACQUIAENV=...' first"
  >&2 echo "Instead of the ellipsis (...) use one of the environments, for"
  >&2 echo "example 'stage'."
  exit 1
else
  echo "The ACQUIAENV environment is set to $ACQUIAENV, so that is the"
  echo "environment we are targeting."
fi

echo 'See https://redfinsolutions.com/blog/installing-free-lets-encrypt-ssl-certificates-acquia'

LOCALCONFIG="$BASE/config/acquia/$ACQUIAENV/letsencrypt"

if ls "$LOCALCONFIG"/environment-information.source.sh 1> /dev/null 2>&1; then
  echo "$LOCALCONFIG/environment-information.source.sh exists. Moving on."
elif ls "$LOCALCONFIG"/get-cert.source.sh 1> /dev/null 2>&1; then
  echo "$LOCALCONFIG/get-cert.source.sh exists. Moving on."
else
  >&2 echo  "Please make sure the following files exist:"
  >&2 echo  ""
  >&2 echo  "$LOCALCONFIG/environment-information.source.sh"
  >&2 echo  "$LOCALCONFIG/get-cert.source.sh"
  >&2 echo  ""
  >&2 echo  "See example in https://github.com/dcycle/starterkit-drupalsite/tree/master/config/acquia/stage/letsencrypt"
  >&2 echo  ""
  exit 1
fi

source "$LOCALCONFIG"/environment-information.source.sh

if [ -z "$NAME" ]; then
  >&2 echo "Make sure $f has NAME=..."
  exit 1;
fi
if [ -z "$DASHBOARD" ]; then
  >&2 echo "Make sure $f has DASHBOARD=..."
  exit 1;
fi
if [ -z "$ENVTYPE" ]; then
  >&2 echo "Make sure $f has ENVTYPE=..."
  exit 1;
fi
if [ -z "$SSH" ]; then
  >&2 echo "Make sure $f has SSH=..."
  exit 1;
fi
if [ -z "$URL" ]; then
  >&2 echo "Make sure $f has URL=..."
  exit 1;
fi
if [ ! -f "$LOCALCONFIG"/environment-information.source.sh ]; then
  >&2 echo "Make sure file exists: $LOCALCONFIG/environment-information.source.sh"
  exit 1;
fi
if [ -z "$NAMESPACE" ]; then
  >&2 echo "Make sure $f has NAMESPACE=..."
  exit 1;
fi
if [ -z "$SSLINSTALL" ]; then
  >&2 echo "Make sure $f has SSLINSTALL=..."
  exit 1;
fi

source "$LOCALCONFIG"/get-cert.source.sh

echo -e "\n----\nNOW MANAGING $NAME\n--"

echo -e "\nPlease make sure your site is in LIVE DEV mode at $DASHBOARD and hit any key; in the case of production sites, you cannot do this, and you wil get instructions forthwith\n"
read -p "Press enter to continue"

echo ''
echo 'If you are not in live dev mode:'
echo ''
echo '* Find the Acquia git repo'
echo "* Add the acme-challenge to it and commit"
echo "* Commit and push"
echo "* Change the tag on Acquia"
echo ''
echo 'If you are in live dev mode:'
echo ''
echo 'You will be now be using the certbot to help you generate a cert.'
echo 'Enter Y, then when you prompted to create a file on the server'
echo 'run these commands in a separate terminal window before hitting enter'
echo ''
echo '    DATA=[enter data here]'
echo '    FILENAME=[file name here (everything after acme-challenge)]'
echo ''
echo '    (ssh '"$SSH"' "mkdir -p /mnt/gfs/home/'"$NAMESPACE"'/'"$ENVTYPE"'/livedev/docroot/.well-known/acme-challenge"; ssh '"$SSH"' "echo $''DATA > /mnt/gfs/home/'"$NAMESPACE"'/'"$ENVTYPE"'/livedev/docroot/.well-known/acme-challenge/$''FILENAME")'
echo ''

mkdir -p "$BASE/do-not-commit/certs/$ACQUIAENV"
source "$LOCALCONFIG"/environment-information.source.sh

echo -e "\nOpen $SSLINSTALL\n"
read -p "Press enter to continue"

DATE=$(date +%Y%m%d)
echo -e "\nType 'LE$DATE' in the LABEL field\n"
read -p "Press enter to continue"

echo ''
cat ./do-not-commit/certs/"$ACQUIAENV/live/$URL"/cert.pem
echo ''

echo -e "\nPLACE The above in the SSL certificate field\n"
read -p "Press enter to continue"

echo ''
cat ./do-not-commit/certs/"$ACQUIAENV/live/$URL"/privkey.pem
echo ''

echo -e "\nPLACE The above in the SSL private key field\n"
read -p "Press enter to continue"

echo ''
cat ./do-not-commit/certs/"$ACQUIAENV/live/$URL"/chain.pem
echo ''

echo -e "\nPLACE The above in the CA intermediate certificates field\n"
read -p "Press enter to continue"

echo -e "\nClick the INSTALL button\n"
read -p "Press enter to continue"

echo -e "\nPlease make sure your site is NOT in LIVE DEV mode at $DASHBOARD and hit any key\n"
read -p "Press enter to continue"

echo "Processing $f file..."
source "$f"

echo -e "\nOpen $DASHBOARD/ssl\n"
read -p "Press enter to continue"

echo -e "\nClick ACTIVATE next to the certificate you just created.\n"
read -p "Press enter to continue"

echo "Processing $f file..."
source "$f"

echo -e "\nTest https://$URL\n"
echo -e "\n(Note that this can take UP TO AN HOUR to work, leave a comment at https://gist.github.com/alberto56/80c418c656bdf218cae663c3ba227e9a with your findings.\n"
read -p "Press enter to continue"

echo "-----"
echo "All done!"
echo "'Till next time"
echo "-----"
