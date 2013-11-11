log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/Users/mdesilva/core_data_imac_27_inch/code/vagrant/chef-test-server/.chef/admin.pem'
validation_client_name   'chef-validator'
validation_key           '.chef/chef-validator.pem'
chef_server_url          'http://10.33.33.33'
cache_type               'BasicFile'
cache_options( :path => '/Users/mdesilva/core_data_imac_27_inch/code/vagrant/chef-test-server/.chef/checksums' )

# Knife-solo Config
cookbook_path    ["cookbooks", "site-cookbooks"]
node_path        "nodes"
role_path        "roles"
environment_path "environments"
data_bag_path    "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"
