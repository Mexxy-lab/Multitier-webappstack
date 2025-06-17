## Manual Provisioning of a Multi-tier stacked web-application written in Java

- This projected was deployed manually using 5 VMs provisioned via Vagrant with help of Virtual Box

## Project Architecture 

![alt text](image.png)

# Prerequisites

- JDK 1.8 or later
- Maven 3 or later
- MySQL 5.6 or later
- Vagrant 2.3 or later
- Virtual Box

## Technologies

- Spring MVC
- Spring Security
- Spring Data JPA
- Maven
- JSP
- MySQL

## Database

Here,we used Mysql DB
MSQL DB Installation Steps for Linux ubuntu 14.04:

- $ sudo apt-get update
- $ sudo apt-get install mysql-server

Then look for the file :

- /src/main/resources/accountsdb
- accountsdb.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < accountsdb.sql

Replace your repo definitions with vault URLs on the VMs. CentOS 7 base repos have moved to the vault since CentOS 7 went EOL (End of Life on June 30, 2024).

```bash
sudo sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo
sudo sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo
```

```bash
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"                    | Used to make WSL work with vagrant and grant windows access to Virtual box.
```
# Prerequisite

1. Oracle VM Virtualbox
2. Vagrant
3. Vagrant plugins

# Execute below command in your computer to install hostmanager plugin

```bash
vagrant plugin install vagrant-hostmanager          | Used to install the plugin manager for host management 
vagrant.exe reload web01                               | Used to reload a VM after making changes to the                                                      Vagrantfile. 
```

# VM SETUP

1. Clone source code.
2. Cd into the repository.
3. Switch to the main branch.
4. cd into vagrant/Manual_provisioning

```bash
vagrant.exe up
vagrant.exe global-status                   | Used to show all previous vms 
vagrant.exe global-status --prune           } Used to prune all old vms, would clear all previous VMs
```

# 1. Allow remote access (modern config)
```bash
echo "loopback_users = none" | sudo tee /etc/rabbitmq/rabbitmq.conf
```
# 2. Restart RabbitMQ
```bash
sudo systemctl restart rabbitmq-server
```
# 3. Create the user and password for user
```bash
sudo rabbitmqctl add_user test test
sudo rabbitmqctl delete_user guest                  | Used to delete a user from the server 
```
# 4. Tag the user as admin (optional, not required for app access)
```bash
sudo rabbitmqctl set_user_tags test administrator
```

# 5. Set full permissions on the default virtual host
```bash
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
```
# 6. Used to list users currently on server 
```bash
sudo rabbitmqctl list_users
sudo rabbitmqctl list_permissions -p /                  | Used to list users permissions
```

```bash
sudo yum install java-1.8.0-openjdk -y                  | This java version was the one which worked correctly
sudo alternatives --config java                         | Used to config a different version if you have multiple versions installed
MAVEN_OPTS="-Xmx1024m" mvn clean install                | Used to install dependencies and build application aritfacts  
```

```bash
tail -n 100 /usr/local/tomcat/logs/localhost.2025-06-17.log                 | Used to inspect the tomcat service logs for errors and issues 
ls -l /usr/local/tomcat/logs/*                                              | Directory for tomcat logs 
cat /usr/local/tomcat/logs/
```

## Tomcat service config file 

```bash
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
```
## Nginx config file for website proxy set up 

```bash
dnf install -y nginx
sudo nano /etc/nginx/conf.d/vprofile.conf                   | Use this for Centos if you used CentOs to provision your nginx
vi /etc/nginx/sites-available/vproapp                       | Use this if you provisioned nginx using an Ubuntu VM. 
systemctl enable --now nginx
systemctl start nginx
```
```bash
upstream vproapp {
    server app01:8080;
}

server {
    listen 80;

    location / {
        proxy_pass http://vproapp;
    }
}
```

## PROVISIONING - Use the instructions in the pdf file attached to provision services.

Services
1. Nginx => Web Service
2. Tomcat => Application Server
3. RabbitMQ => Broker/Queuing Agent
4. Memcache => DB Caching
5. ElasticSearch => Indexing/Search service
6. MySQL => SQL Database

Setup should be done in below mentioned order

1. MySQL (Database SVC)
2. Memcache (DB Caching SVC)
3. RabbitMQ (Broker/Queue SVC)
4. Tomcat (Application SVC)
5. Nginx (Web SVC)
