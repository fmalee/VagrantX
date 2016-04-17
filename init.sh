#!/usr/bin/env bash

vgrantXRoot=~/.vagrantX

mkdir -p "$vgrantXRoot"

cp -i src/Vagrant.yaml "$vgrantXRoot/Vagrant.yaml"
cp -i src/after.sh "$vgrantXRoot/after.sh"
cp -i src/aliases "$vgrantXRoot/aliases"

rm -r "$vgrantXRoot/scripts"
cp -r scripts $vgrantXRoot

echo "VagrantX initialized!"