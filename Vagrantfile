# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define :chef do |chef_config|

    chef_config.vm.box = "precise64"
    chef_config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    chef_config.vm.network :private_network, :ip => "10.33.33.33"

    VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'vagrant.json').read)

    chef_config.vm.provision :chef_solo do |chef|
       chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
       chef.roles_path = "roles"
       chef.data_bags_path = "data_bags"

       chef.run_list = VAGRANT_JSON.delete('run_list')
       chef.json = VAGRANT_JSON
       # old way
       #VAGRANT_JSON['run_list'].each do |recipe|
       # chef.add_recipe(recipe)
       #end if VAGRANT_JSON['run_list']

       Dir.glob(Pathname(__FILE__).dirname.join('roles', '*.json')).each do |role|
        chef.add_role(Pathname.new(role).basename(".*").to_s)
       end
    end
  end

  config.vm.define :chef_client do |chef_client_config|
    chef_client_config.vm.box = "precise64"
    chef_client_config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    chef_client_config.vm.network :private_network, :ip => "10.33.33.50"
  end

end
