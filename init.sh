#!/usr/bin/env bash

VAGRANTX_ROOT=~/.vagrantX

mkdir -p "$VAGRANTX_ROOT"

awk 'BEGIN { cmd="cp -ri vagrant.d/Vagrant.yaml ~/.vagrantX/Vagrant.yaml"; print "n" |cmd; }'
awk 'BEGIN { cmd="cp -ri vagrant.d/after.sh ~/.vagrantX/after.sh"; print "n" |cmd; }'
awk 'BEGIN { cmd="cp -ri vagrant.d/aliases ~/.vagrantX/aliases"; print "n" |cmd; }'

rm -r "$VAGRANTX_ROOT/scripts"
cp -r scripts $VAGRANTX_ROOT

echo "VagrantX initialized!"