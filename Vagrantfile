Vagrant.configure(2) do |config|
		
	config.vm.box = "ubuntu/trusty64"  #Official Ubuntu Server 14.04 LTS (Trusty Tahr) builds
	 
	#config.vm.box = "ubuntu/bionic64"  #Official Ubuntu Server 18.04 LTS (Trusty Tahr) builds
	#config.vm.box = "ubuntu/xenial64"
	#config.vm.box_version = "20200320.0.0"
        
	config.ssh.insert_key = false
		 
	#config.vm.synced_folder "shared_folder/", "/home/vagrant/shared_folder"
  
  config.vm.provider "virtualbox" do |v|
		v.memory = 4500
		v.cpus = 2
  end	
		
	config.vm.define "HadoopMaster" do |hm| 
		hm.vm.hostname="master"
		hm.vm.provision :shell, path: "bootstrap-mn.sh", privileged: false,env: {"JAVA_HOME" => "/home/vagrant/bigdata/java","CONFLUENT_HOME" => "/home/vagrant/bigdata/confluent"}
		hm.vm.network "private_network", ip: "192.168.56.70"
			
	end 
end
