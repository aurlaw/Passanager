VAGRANTFILE_API_VERSION = "2"
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.20.100"
  config.vm.hostname = "passanager"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
#  config.vm.synced_folder "provisioning", "/vprovisioning"
  config.vm.synced_folder ".", "/vapp/src/github.com/aurlaw/passanager"
  config.vm.synced_folder "provisioning", "/vprovisioning"
  config.vm.synced_folder "backup", "/vbackup"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |v|
    v.memory = 3072
    v.cpus = 2
  end 
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  # configure Vagrant's ssh shell to be a non-login one
 config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"  
  # shell provisioner for Ansbile. allows for running on windows hosts
  config.vm.provision "ansible", type: "shell" do |s|
    s.keep_color = true,
    s.inline = "export PYTHONUNBUFFERED=1 && export ANSIBLE_FORCE_COLOR=1 && cd /vprovisioning && chmod +x init.sh && ./init.sh" 
  end

  # config.vm.provision "docker", type: "docker"

  # config.vm.provision "compose", type: "docker_compose" do |d|
  #   d.yml = "/vagrant/provisioning/docker-compose.yml", 
  #   d.rebuild = false, 
  #   d.run =  "always"
  # end  
  # config.vm.provision "ansible", :shell,
  #   :keep_color => true,
  #   :inline => "export PYTHONUNBUFFERED=1 && export ANSIBLE_FORCE_COLOR=1 && cd /vagrant/provisioning && chmod +x init.sh && ./init.sh"  


  config.vm.provision :docker
  config.vm.provision :docker_compose, yml: "/vprovisioning/docker-compose.yml", rebuild: false, run: "always"

end
