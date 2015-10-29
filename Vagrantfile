# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Required for md5sum 
require 'digest'

# Variables for file exists and md5sum checks
SETUPDIR = 'setup/'
# filename => [md5sum]/''
files = {
	'db.rsp' => '', 
	'linux.x64_11gR2_database_1of2.zip' => 'b86b3f97a55745302036ff2c8bb4df9d', 
	'linux.x64_11gR2_database_2of2.zip' => 'f070b470de2dbdf44d4e7f28a2d67e93', 
	'preconfig.sh' => '', 
	'setup.sh' => '',
	'sysctl.conf' => ''
}

ARGV.each { |arg| 
	if arg == 'up'
		# File exists check
		puts 'Checking files and md5sum'
		files.each { |file_name , file_md5|
			f = SETUPDIR + file_name
			print "\t" + f
			if !File.exists?(f)
				print "\t" + 'Missing'
				abort('aborted due to a missing file:' + f)
			end
			print "\t" + 'found'
			if (file_md5 != '')
				# md5 check
				f_md5 = Digest::MD5.file f
				if (f_md5 != file_md5)
					abort('MD5 sum for "' + f + '" doesnt match "' + file_md5 + '"')
				end
				print "\t" + 'matched "' + file_md5 + '"'
			end
			print "\n"
		}
	end
}

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.
	
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    config.vm.box = "boxcutter/centos511"
    
    # Setting up portforward for netListener.
    config.vm.network "forwarded_port", guest: 1521, host: 11521, host_ip: '127.0.0.1', protocol: 'tcp'
    
    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:   
    config.vm.provider "virtualbox" do |vb|
        # Name for VirtualBox
        vb.name = "Oracle_database_11g"
        
        # Display the VirtualBox GUI when booting the machine
        vb.gui = false
    
        # Customize the amount of memory on the VM:
        vb.memory = "2048"
    end
    
   # Enable provisioning with a shell script. Additional provisioners such as
   # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
   # documentation for more information about their specific syntax and use.
   
   # Adjusting kernel parameters
   config.vm.provision "shell", privileged: true, inline: "cat /vagrant/setup/sysctl.conf >> /etc/sysctl.conf"
   config.vm.provision "shell", privileged: true, inline: 'sysctl -p'
   
   # Pre-configuration for Oracle EE DB 11gR2
   config.vm.provision "shell", privileged: true, inline: 'bash /vagrant/setup/preconfig.sh'
   
   # Installing Oracle EE DB 11gR2
   config.vm.provision "shell", privileged: true, inline: 'bash /vagrant/setup/setup.sh'
end