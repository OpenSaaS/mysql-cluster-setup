# -*- mode: ruby -*-
# vi: set ft=ruby :

my_cluster = {
	:node1 		=> { :ip => "10.0.3.10"},
	:node2 		=> { :ip => "10.0.3.20"},
	:node3 		=> { :ip => "10.0.3.30"},
	:proxy 		=> { :ip => "10.0.3.100"},
	:monitoring => { :ip => "10.0.3.200"}
}


Vagrant::Config.run do |config|

  config.vm.define :node1 do |config|
    config.vm.box = "myubuntu.12.04"
   	config.vm.host_name = "db1"

    config.vm.forward_port 3306, 3306
    #sst rsync port forwarding
    config.vm.forward_port 4444, 4444
	config.vm.forward_port 4568, 4568
  	config.vm.provision :shell, :inline => "gem install chef -v 10.12.0 --no-rdoc --no-ri"

    config.vm.network :hostonly, my_cluster[:node1][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks-src"] 
	  chef.add_recipe('apt')
	  chef.add_recipe('ntp')
	  chef.add_recipe('rsync')                                                                                                                  
	  chef.add_recipe("percona::cluster")
	  chef.add_recipe("collectd::attribute_driven")	
    
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
								  :wsrep_node_name => 'node1'}},
					:collectd => {:name => 'node1',
					              :plugins => {
					 				'syslog' => {'config' => {"LogLevel" => "Info"}},
								    'swap' => {},
									'mysql' => {'template' => 'mysql.conf.erb', 'config' => {'Host' => 'localhost', 'User' => 'root', 'Password' => '123-changeme'}},
									'memory' => {},
									'network'=> {'config' => {'Server' => my_cluster[:monitoring][:ip]}}
									}
								})	
	end
  end

  config.vm.define :node2 do |config|
    config.vm.box = "myubuntu.12.04"
   	config.vm.host_name = "db2"

    config.vm.forward_port 3306, 3307
    #sst rsync port forwarding
    config.vm.forward_port 4444, 4445
	config.vm.forward_port 4568, 4569
  	config.vm.provision :shell, :inline => "gem install chef -v 10.12.0 --no-rdoc --no-ri"


    config.vm.network :hostonly, my_cluster[:node2][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks-src"] 
	  chef.add_recipe('apt')
	  chef.add_recipe('ntp')
	  chef.add_recipe('rsync')                                                                                                                  
	  chef.add_recipe("percona::cluster")
	  chef.add_recipe("collectd::attribute_driven")	
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
								  :wsrep_node_name => 'node2'}},
					:collectd => {:name => 'node2',
								  :plugins => {
								 	'syslog' => {'config' => {"LogLevel" => "Info"}},
									'swap' => {},
									'mysql' => {'template' => 'mysql.conf.erb', 'config' => {'Host' => 'localhost', 'User' => 'root', 'Password' => '123-changeme'}},												'memory' => {},
									'memory' => {},
									'network'=> {'config' => {'Server' => my_cluster[:monitoring][:ip]}}
								}
					})
	end
  end

  config.vm.define :node3 do |config|
    config.vm.box = "myubuntu.12.04"
   	config.vm.host_name = "db3"

    config.vm.forward_port 3306, 3308
    #sst rsync port forwarding
    config.vm.forward_port 4444, 4446
	config.vm.forward_port 4568, 4570

  	config.vm.provision :shell, :inline => "gem install chef -v 10.12.0 --no-rdoc --no-ri"

    config.vm.network :hostonly, my_cluster[:node3][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks-src"]
	  chef.add_recipe('apt')
	  chef.add_recipe('ntp')
	  chef.add_recipe('rsync')                                                                                                                  
	  chef.add_recipe("percona::cluster")
	  chef.add_recipe("collectd::attribute_driven")	
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
								  :wsrep_node_name => 'node3'}},
								:collectd => {:name => 'node3',
											  :plugins => {
											 	'syslog' => {'config' => {"LogLevel" => "Info"}},
											    'swap' => {},
												'mysql' => {'template' => 'mysql.conf.erb', 'config' => {'Host' => 'localhost', 'User' => 'root', 'Password' => '123-changeme'}},												'memory' => {},
												'network'=> {'config' => {'Server' => my_cluster[:monitoring][:ip]}}
												}
									})
	end
  end

  config.vm.define :proxy do |config|
    config.vm.box = "myubuntu.12.04"
   	config.vm.host_name = "proxy"

    config.vm.forward_port 3306, 3309 #haproxy will listen to this port
	config.vm.forward_port 80, 8888 #web interface haproxy

    config.vm.network :hostonly, my_cluster[:proxy][:ip]
	config.vm.provision :chef_solo do |chef|     
	  chef.cookbooks_path = ["cookbooks-src"] 
	  chef.add_recipe('apt')
	  chef.add_recipe('ntp')
	  chef.add_recipe("haproxy")	
	end
  end
 
  config.vm.define :monitoring do |config|
    config.vm.box = "myubuntu.12.04"
   	config.vm.host_name = "monitoring"


  config.vm.network :hostonly, my_cluster[:monitoring][:ip]
  config.vm.provision :shell, :inline => "gem install chef -v 10.12.0 --no-rdoc --no-ri"

  config.vm.forward_port 8080, 8088
  config.vm.forward_port 9000, 9000
  config.vm.forward_port 2003, 2003 #port for graphite
  config.vm.forward_port 25827, 25827  #collectd server uses this port
 
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks-src"]
	chef.add_recipe('apt')
	chef.add_recipe('ntp')
	chef.add_recipe("graphite")
    chef.add_recipe("collectd::attribute_driven")	
	chef.json.merge!( 
			:python => {:install_method => 'source'},
			:graphite => {:url => my_cluster[:monitoring][:ip], 
			              :carbon => {
			                 :line_receiver_interface => my_cluster[:monitoring][:ip] }},
			:collectd => {:name => 'monitoring',
			              :plugins => {
			 				'syslog' => {'config' => {"LogLevel" => "Info"}},
						    'swap' => {},
						    'memory' => {},
							'network'=> {'config' => {'Listen' => my_cluster[:monitoring][:ip]}},
						    'write_graphite' => {'config' => {'Host' => my_cluster[:monitoring][:ip], 'Port' => '2003', 'Prefix' => 'collectd.'}}
							}
						}
			)
    end
  end
end
