#!/usr/bin/env bash
if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "Add APT repositories"
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -qq software-properties-common &> /dev/null || exit 1
    apt-add-repository ppa:ansible/ansible &> /dev/null || exit 1

    apt-get update -qq

    echo "Installing Ansible"
    apt-get install -qq ansible &> /dev/null || exit 1
    echo "Ansible installed"

fi

echo "Installing Ansible Docker Plugin"
ansible-galaxy install angstwad.docker_ubuntu
echo "Ansible Docker installed"

echo "Installing Ansible Nodesoure Plugin"
ansible-galaxy install nodesource.node
echo "Ansible Nodesoure installed"


cd /vagrant/provisioning
ansible-playbook -c local setup.yml
### Note there is a bug in ansible docker, switch to use docker compose instead
docker-compose up