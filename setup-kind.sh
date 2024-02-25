# kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -LS https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# helm3
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ホストのIPアドレスを変数に格納
export HOST_IP=$(hostname -I | awk '{print $1}')

# teeコマンドでkind/clust.yamlを作成
mkdir -p kind
cat <<EOF | tee kind/cluster.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: $HOST_IP
  apiServerPort: 6443
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
  - containerPort: 8080
    hostPort: 8080
    protocol: TCP
  - containerPort: 30080
    hostPort: 30080
  - containerPort: 30090
    hostPort: 30090
  - containerPort: 30100
    hostPort: 30100
    protocol: TCP
  extraMounts:
    - hostPath: ./data
      containerPath: /var/local-path-provisioner
- role: worker
- role: worker
kubeadmConfigPatches:
- |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        authorization-mode: "AlwaysAllow"
EOF

# kindクラスタの作成
kind create cluster --config kind/cluster.yaml --name kind

# KubernetesノードがREADYになるまで待機
kubectl wait --for=condition=Ready node --all --timeout=300s

# ノード一覧の表示
kubectl get nodes
