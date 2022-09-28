#!/bin/bash

sudo wget https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo cp ./apt-key.gpg /etc/apt/trusted.gpg.d/

sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl