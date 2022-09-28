#/bin/bash

#Docker install

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl enable docker

#Kubernetes install

sudo wget https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo cp ./apt-key.gpg /etc/apt/trusted.gpg.d/

sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

#Kubernetes Cluster Initial setup
sudo cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
sudo swapoff -a

#Ubuntu bug fix
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

echo "CIDR: (Pl. 10.244.0.0/16)"
ip=$(hostname -I |cut -f1 -d " ")
read cidr
kubeadm init --apiserver-advertise-address=$ip --pod-network-cidr=$cidr

export KUBECONFIG=/etc/kubernetes/admin.conf

#Config
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Test pods running state
#kubectl get pod -A -o wide
