#!/bin/bash

python3 get-releases.py

sleep 1

docker compose up -d

echo "LXMFy Running Sleeping for 5 seconds"

sleep 5

sudo sed -i 's/enable_node = no/enable_node = yes/' ./nomadnetwork/config
sudo sed -i 's/node_name = None/node_name = LXMFy/' ./nomadnetwork/config

if ! grep -q "quad4net tcp" ./reticulum/config; then
    echo "Updating Reticulum Configuration..."

    sudo sed -i 's/enabled = Yes/enabled = No/' ./reticulum/config

    echo "Adding TCP Interface"
    sudo bash -c 'cat >> ./reticulum/config << EOF

  [[quad4net tcp]]
    type = TCPClientInterface
    enabled = yes
    target_host = rns.quad4.io
    target_port = 4242
EOF'
    
    echo "Configuration updated"
    docker restart lxmfy-pages
    echo "LXMFy Restarted"
fi

sleep 1

sudo cp -r ./pages/* ./nomadnetwork/storage/pages
sudo cp -r ./files/ ./nomadnetwork/storage/files/releases

sudo chown -R 65532:65532 ./nomadnetwork/ ./reticulum/