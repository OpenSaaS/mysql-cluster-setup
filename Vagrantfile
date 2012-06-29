# -*- mode: ruby -*-
# vi: set ft=ruby :

my_cluster = {
	:node1 => { :ip => "10.0.3.10"},
	:node2 => { :ip => "10.0.3.20"},
	:node3 => { :ip => "10.0.3.30"},
	:proxy => { :ip => "10.0.3.100"	}
}


Vagrant::Config.run do |config|

  config.vm.define :node1 do |config|
    config.vm.box = "myubuntu.12.04"

    config.vm.forward_port 3306, 3306
    #sst rsync port forwarding
    config.vm.forward_port 4444, 4444
	config.vm.forward_port 4568, 4568

    config.vm.network :hostonly, my_cluster[:node1][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks"] 
	  chef.add_recipe('rsync')                                                                                                                  
	  chef.add_recipe("percona::cluster")
	  chef.json.merge!(
       :percona => { :encrypted_data_bag => nil,
                     :server => {
						:bind_address => my_cluster[:node1][:ip],
						:role => 'cluster'
						},
					 :cluster => {:wsrep_cluster_address => 'gcomm://',
					              :wsrep_sst_method => 'rsync',
								  :wsrep_cluster_name => 'mycoolcluster',
								  :wsrep_provider => "/usr/lib/libgalera_smm.so",
								  :wsrep_node_name => 'node1'}}
				)	
	end
  end

  config.vm.define :node2 do |config|
    config.vm.box = "myubuntu.12.04"

    config.vm.forward_port 3306, 3307
    #sst rsync port forwarding
    config.vm.forward_port 4444, 4445
	config.vm.forward_port 4568, 4569


    config.vm.network :hostonly, my_cluster[:node2][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks"] 
	  chef.add_recipe('rsync')                                                                                                                  
	  chef.add_recipe("percona::cluster")
	  chef.json.merge!(
       :percona => { :encrypted_data_bag => nil,
                     :server => {
						:bind_address => my_cluster[:node2][:ip],
						:role => 'cluster'
						},
					 :cluster => {:wsrep_cluster_address => "gcomm://#{my_cluster[:node1][:ip]}",
					              :wsrep_sst_method => 'rsync',
								  :wsrep_cluster_name => 'mycoolcluster',
								  :wsrep_provider => "/usr/lib/libgalera_smm.so",
								  :wsrep_node_name => 'node2'}}
				)	
	end
  end

  config.vm.define :node3 do |config|
    config.vm.box = "myubuntu.12.04"

    config.vm.forward_port 3306, 3308
    #sst rsync port forwarding
    config.vm.forward_port 4444, 4446
	config.vm.forward_port 4568, 4570


    config.vm.network :hostonly, my_cluster[:node3][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks"] 
	  chef.add_recipe('rsync')                                                                                                                  
	  chef.add_recipe("percona::cluster")
	  chef.json.merge!(
       :percona => { :encrypted_data_bag => nil,
                     :server => {
						:bind_address => my_cluster[:node3][:ip],
						:role => 'cluster'
						},
					 :cluster => {:wsrep_cluster_address => "gcomm://#{my_cluster[:node1][:ip]}",
					              :wsrep_sst_method => 'rsync',
								  :wsrep_cluster_name => 'mycoolcluster',
								  :wsrep_provider => "/usr/lib/libgalera_smm.so",
								  :wsrep_node_name => 'node3'}}
				)	
	end
  end

  config.vm.define :proxy do |config|
    config.vm.box = "myubuntu.12.04"

    config.vm.forward_port 3306, 3309 #haproxy will listen to this port
	config.vm.forward_port 80, 8888 #web interface haproxy

    config.vm.network :hostonly, my_cluster[:proxy][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks"] 
	  chef.add_recipe("apt")
	  chef.add_recipe("haproxy")	
	end
  end


end
