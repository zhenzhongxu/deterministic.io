# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
  Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.provision "shell", path: "./vagrant/bin/vagrant-bootstrap.sh", privileged: false

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider :virtualbox do |v|
  v.memory = 4096
  v.cpus = 2
  end

  config.vm.provider :aws do |aws, override|
     aws.access_key_id = ENV['AWS_KEY']
     aws.secret_access_key = ENV['AWS_SECRET']
     aws.keypair_name = ENV['AWS_KEYNAME']
     aws.ami = "ami-5189a661"
     aws.region = "us-west-2"
     aws.instance_type = "t2.micro"
     aws.elastic_ip = ENV['AWS_ELASTICIP']
     aws.security_groups = ENV['AWS_SECURITYGROUP']
     aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 8 }]
     aws.tags = {
           'stack' => 'deterministic.io'
          }

     override.vm.box = "dummy"
     override.ssh.username = "ubuntu"
     override.ssh.private_key_path = ENV['AWS_KEYPATH']
   end
end
