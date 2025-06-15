## Manual Provisioning of a Multi-tier stacked webapplication written in Java

- This projected was deployed manually using 5 VMs provisioned via Vagrant with help of Virtual Box

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
