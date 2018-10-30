#!/bin/bash

username="aarba"
etcd_version="3.3.10"
internal_ip=$(ip addr show eth1 | grep -Po 'inet \K[\d.]+')
internal_hostname=$(hostname)

wget -q "https://github.com/coreos/etcd/releases/download/v$etcd_version/etcd-v$etcd_version-linux-amd64.tar.gz"
tar -xvf etcd-v$etcd_version-linux-amd64.tar.gz
sudo mv etcd-v$etcd_version-linux-amd64/etcd* /usr/local/bin/
sudo mkdir -p /etc/etcd /var/lib/etcd
sudo cp /home/$username/ca.pem /home/$username/kubernetes-key.pem /home/$username/kubernetes.pem /etc/etcd/

ETCD_NAME=$internal_hostname
INTERNAL_IP=$internal_ip
INITIAL_CLUSTER=kubernetes-controller-1=https://192.168.56.9:2380,kubernetes-controller-2=https://192.168.56.10:2380

cat << EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster ${INITIAL_CLUSTER} \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
sudo cp /usr/local/bin/* /usr/sbin

sudo ETCDCTL_API=3 /usr/local/bin/etcdctl member list --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/kubernetes.pem --key=/etc/etcd/kubernetes-key.pem