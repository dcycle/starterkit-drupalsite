#!/bin/bash
set -e

./scripts/jenkins/preflight.sh

echo "Building a droplet as per https://blog.dcycle.com/kubernetes/15.5-multi-arch-custom-docker-images/"
doctl -t "$TOKEN" compute droplet create --ssh-keys "$SSHKEYFINGERPRINT" --image ubuntu-22-10-x64 --size s-4vcpu-8gb-intel --region nyc1 "$NAMESPACE"

echo "Wait for the IP address to be available."
sleep 90
VM_PUBLIC_IP=$(doctl -t "$TOKEN" compute droplet get "$NAMESPACE" --format PublicIPv4 --no-header)
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
    -i "$SSHKEYFILE" \
    "$SSHKEYUSER@$VM_PUBLIC_IP" "echo 'Yay, this works!'"

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -i "$SSHKEYFILE" \
  root@"$VM_PUBLIC_IP" "mkdir -p $NAMESPACE"
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -i "$SSHKEYFILE" \
  ~/.dcycle-docker-credentials.sh \
  root@$VM_PUBLIC_IP:~/.dcycle-docker-credentials.sh
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -i "$SSHKEYFILE" \
  -r * root@"$VM_PUBLIC_IP:$NAMESPACE"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -i "$SSHKEYFILE" \
  root@"$VM_PUBLIC_IP" "cd $NAMESPACE && ls -lah && ./scripts/jenkins/install-docker-and-build-on-vm.sh"
