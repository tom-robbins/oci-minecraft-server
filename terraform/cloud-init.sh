#!/bin/bash

# create a user to run the server
groupadd minecraft
useradd --system --shell /usr/sbin/nologin --home /opt/minecraft -g minecraft minecraft
cd /opt
mkdir -p minecraft/survival
cd /opt/minecraft/survival

# install the latest version the JDK
yum update -y
yum install -y screen firewalld jdk-17.aarch64

# download the latest version of minecraft server https://www.minecraft.net/en-us/download/server
wget -O server.jar https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar

# sign the EULA ;)
echo "eula=true" > eula.txt

# hand over files to the minecraft user
sudo chown -R minecraft /opt/minecraft

# create a systemd service
cat <<EOF > /lib/systemd/system/minecraft@.service
[Unit]
Description=Minecraft Server %i
After=network.target

[Service]
WorkingDirectory=/opt/minecraft/%i
Type=simple
PrivateUsers=true
User=minecraft
Group=minecraft
ProtectSystem=full
ProtectHome=true
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
Environment="MCMINMEM=6G" "MCMAXMEM=6G" "SHUTDOWN_DELAY=5" "POST_SHUTDOWN_DELAY=10"
EnvironmentFile=-/opt/minecraft/%i/server.conf

ExecStartPre=/bin/bash -c '/usr/bin/screen -dmS mc-%i'
ExecStart=/bin/bash -c '/usr/bin/java -server -Xmx6G -Xms6G -jar server.jar --nogui'

ExecReload=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "reload"\\015'

ExecStop=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "say SERVER SHUTTING DOWN. Saving map..."\\015'
ExecStop=/bin/bash -c '/bin/sleep ${SHUTDOWN_DELAY}'
ExecStop=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "save-all"\\015'
ExecStop=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "stop"\\015'
ExecStop=/bin/bash -c '/bin/sleep ${POST_SHUTDOWN_DELAY}'

Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

systemctl start minecraft@survival
systemctl enable minecraft@survival

# Open up ports for minecraft
systemctl unmask firewalld
firewall-offline-cmd --zone=public --add-port=25565/tcp --add-port=25565/udp
firewall-cmd --reload
systemctl enable firewalld
systemctl start firewalld
