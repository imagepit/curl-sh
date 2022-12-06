# docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chown vagrant:vagrant /usr/local/bin/docker-compose
sudo chmod 775 /usr/local/bin/docker-compose

# kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# nfs-server
sudo apt install -y nfs-kernel-server
sudo mkdir -p /var/nfs/exports
sudo chown nobody.nogroup /var/nfs/exports
echo "/var/nfs/exports *(rw,sync,fsid=0,crossmnt,no_subtree_check,insecure,all_squash)" >> /etc/exports
sudo exportfs -ra
