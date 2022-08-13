# This file describes an Acquia environment for which we want to set
# up LetsEncrypt https via the acquia/letsencrypt.sh
# script.
#
# Project description
NAME="NAME OF MY SITE"
# The main project dashboard
DASHBOARD=https://cloud.acquia.com/a/environments/abcxyz
# normally "test", can also be "dev". Prod works differently because we
# cannot put the target environment into live mode
ENVTYPE=test
# SSH access to the server
SSH=MY_ACQUIA_DRUPAL_ID.test@MY_ACQUIA_DRUPAL_IDstg.ssh.prod.acquia-sites.com
# Domain for which we want to set up HTTPS, without the protocol.
URL=one.of.the.urls.in.get-cert.source.sh
# The project namespace on Acquia. This should be the string just
# before "test" in the ssh connection string.
NAMESPACE=MY_ACQUIA_DRUPAL_ID
# URL to the dashboard where you can insert an SSL certificate
SSLINSTALL=https://cloud.acquia.com/a/environments/abcxyz/domain-management/ssl/install
