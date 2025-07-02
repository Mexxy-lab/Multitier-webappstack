#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install Java 11
apt update -y
apt install -y openjdk-11-jdk curl wget

# Create tomcat user if it doesn't exist
id -u tomcat &>/dev/null || useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# Download Tomcat 9.0.83
cd /tmp
TOMCAT_VERSION=9.0.83
wget https://archive.apache.org/dist/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

# Install Tomcat
mkdir -p /opt/tomcat
tar -xzvf apache-tomcat-$TOMCAT_VERSION.tar.gz -C /opt/tomcat --strip-components=1
chown -R tomcat: /opt/tomcat
chmod +x /opt/tomcat/bin/*.sh

# Create systemd service
cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload and start
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now tomcat
systemctl restart tomcat
