![Passanager](https://raw.githubusercontent.com/aurlaw/Passanager/master/temp/passanager_logo_v1.png)

Dockerized Password Manager written  in Go with Redis and PostgreSQL

[![Build Status](https://travis-ci.org/aurlaw/Passanager.svg?branch=master)](https://travis-ci.org/aurlaw/Passanager)


## Prerequisites ##

* Vagrant
* VirtualBox
* Docker Compose Vagrant provisioner
```
$vagrant plugin install vagrant-docker-compose
```

##Vagrant##
Contains 3 provisioners

* Shell. Configures development environment using Ansible. (Golang, Ruby/Compass, Nodejs)
* Docker
* Docker Compose. Configures containers for Redis and PostgreSQL. Configured to always run

To Start:

```
$vagrant up
```

To re-run all provisioners:

```
$vagrant reload --provision
```

Note: Docker Compose will always execute on `$vagrant up` or `$vagrant reload`

Note: For provisioning to work, dos2unix may need to be installed manually on the guest.

```
$vagrant ssh
$sudo apt-get install dos2unix
```

Then use
```
$vagrant reload --provision
```

##TODO##

Working Directory

```
$ vagrant ssh
$ cd /vapp/src/github.com/aurlaw/passanager
```

First Time set up

```
$ go get github.com/tools/godep
```

Working Directory

Go Application: port 9090


Ansible Docker containers
`http://docs.ansible.com/ansible/docker_module.html`

Container volume root on guest: /srv/docker

* Redis
* PostgreSQL


`https://github.com/nodesource/distributions#debinstall`

`https://github.com/nodesource/ansible-nodejs-role`


Notes:
Postgres Backup
within vagrant ssh
sudo /vbackup/postgres_db_backup.sh

Cron
*/5 * * * *  bash -x docker_db_backup.sh

 sudo tail /var/log/syslog