#!/bin/bash
set -e

ERROR=false
if [ -z "$TOKEN" ]; then
  echo "Please set up the TOKEN variable, see https://blog.dcycle.com/kubernetes/15.5-multi-arch-custom-docker-images/"
  ERROR=true
fi
if [ -z "$SSHKEYFINGERPRINT" ]; then
  echo "Please set up the SSHKEYFINGERPRINT variable, see https://blog.dcycle.com/kubernetes/15.5-multi-arch-custom-docker-images/"
  ERROR=true
fi
if [ -z "$NAMESPACE" ]; then
  echo "Please set up the NAMESPACE variable, see https://blog.dcycle.com/kubernetes/15.5-multi-arch-custom-docker-images/"
  ERROR=true
fi
if [ -z "$SSHKEYFILE" ]; then
  echo "Please set up the SSHKEYFILE variable, see https://blog.dcycle.com/kubernetes/15.5-multi-arch-custom-docker-images/"
  ERROR=true
fi
if [ -z "$SSHKEYUSER" ]; then
  echo "Please set up the SSHKEYUSER variable, see https://blog.dcycle.com/kubernetes/15.5-multi-arch-custom-docker-images/"
  ERROR=true
fi

if [ "$ERROR" == true ]; then
  exit 1
fi
