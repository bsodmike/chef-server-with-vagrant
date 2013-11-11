# chef-server-with-vagrant

This repo is already primed to allow you to get to grips with Opscode's
Chef.  You will first be able to interact with chef-server that's
automatically setup as soon as you launch this with Vagrant.

To get started, install VirtualBox and download and install the latest
version of Vagrant.  This was created with Vagrant v1.3.5

Install the following first

    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-omnibus

Then, simply do

    vagrant up

This will spawn three virtual instances

* chef              # Visit http://10.33.33.33, this is our test chef
server
* chef_client       # Bootstrap your first node @ 10.33.33.50
* chefserver        # Use Knife-solo to bootstrap a chef server
@ 10.33.33.40; this is how you would bootstrap a chef server on a VPS!

Note that HTTPS has been disabled on these chef servers to allow your
Knife to work.

## Controlling Chef 11.0.8

Check that your chef server is running by visiting `https://10.33.33.33/version`

```
chef-server 11.0.8

Component               Installed Version   Version GUID
-------------------------------------------------------------------------------------------
bookshelf               0.2.1               git:0a01f74ffd1313c4dc9bf0d236e03a871add4e01
chef-expander           11.0.0              git:14b11a96da1273b362f39ab11c411470688a8bd6
chef-gem                11.4.0
chef-pedant             1.0.3               git:15de6cd06f16ee5dee501d6aba36f4ba60162e62
chef-server-cookbooks   11.0.8
chef-server-ctl         11.0.8
chef-server-scripts     11.0.8
chef-server-webui       11.0.4              git:498097c0793e51e4f4e7df9f35ee1a3ed3282841
chef-solr               11.0.1              git:bcd45175fd402f3082e7146f94c5d571b0620434
erchef                  1.2.6               git:77ade20f166367b5f0cde468e3c6066b8a327475
nginx                   1.2.3               md5:0a986e60826d9e3b453dbefc36bf8f6c
postgresql              9.2.4               md5:6ee5bb53b97da7c6ad9cb0825d3300dd
preparation             11.0.8
rabbitmq                2.7.1               md5:34a5f9fb6f22e6681092443fcc80324f
runit                   2.1.1               md5:8fa53ea8f71d88da9503f62793336bc3
unicorn                 4.2.0
version-manifest        11.0.8
```

First, copy all the `*.pem` files from your chef server to your kitchen's `.chef/` folder.

Now configure your knife with `knife configure -i`

```
-> % knife configure -i
Overwrite /Users/mdesilva/core_data_imac_27_inch/code/vagrant/chef-test-server/.chef/knife.rb? (Y/N) y
Please enter the chef server URL: [http://imac.local:4000] http://10.33.33.33
Please enter a clientname for the new client: [mdesilva] admin
Please enter the existing admin clientname: [chef-webui]
Please enter the location of the existing admin client's private key: [/etc/chef/webui.pem] .chef/chef-webui.pem
Please enter the validation clientname: [chef-validator]
Please enter the location of the validation key: [/etc/chef/validation.pem] .chef/chef-validator.pem
Please enter the path to a chef repository (or leave blank):
Creating initial API user...
```

A properly configured knife will respond as follows

```
-> % knife client list
  chef-validator
  chef-webui
```

Your knife config at `.chef/knife.rb` will look like

```
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/Users/mdesilva/core_data_imac_27_inch/code/vagrant/chef-test-server/.chef/admin.pem'
validation_client_name   'chef-validator'
validation_key           '.chef/chef-validator.pem'
chef_server_url          'http://10.33.33.33'
cache_type               'BasicFile'
cache_options( :path => '/Users/mdesilva/core_data_imac_27_inch/code/vagrant/chef-test-server/.chef/checksums' )
```

### Updating Cookbooks via Berkshelf

Use Berkshelf to manage our cookbooks and let's store them in
`site-cookbooks/`.  This is because when we use Knife-solo the
`cookbooks/` folder is cleared out.

    -> % berks install --path site-cookbooks

Upload all cookbooks to the chef server

    -> % berks upload
    Installing chef-server (2.0.0) from git: 'git://github.com/opscode-cookbooks/chef-server.git' with branch: 'master' at ref: '2be4832608ad97777f49b29a0e3172f50f976b69'
    Using build-essential (1.4.2) at path
    Uploading chef-server (2.0.0) to: 'http://10.33.33.33:80/'
    Uploading build-essential (1.4.2) to: 'http://10.33.33.33:80/'

### Uploading Roles

Let's upload all the roles to our chef server

    -> % knife role from file roles/*.json
    Updated Role base!
    Updated Role chefserver!
    Updated Role node_base!
    Updated Role vagrant_chefserver!

## Bootstrapping a node with Knife

```
-> % knife bootstrap 10.33.33.50 -x vagrant -P vagrant --sudo --node-name web.node
Bootstrapping Chef on 10.33.33.50
10.33.33.50 --2013-11-11 13:19:33--  https://www.opscode.com/chef/install.sh
10.33.33.50 Resolving www.opscode.com (www.opscode.com)... 184.106.28.82
10.33.33.50 Connecting to www.opscode.com (www.opscode.com)|184.106.28.82|:443... connected.
10.33.33.50 HTTP request sent, awaiting response... 200 OK
10.33.33.50 Length: 6790 (6.6K) [application/x-sh]
10.33.33.50 Saving to: `STDOUT'
10.33.33.50
100%[======================================>] 6,790       --.-K/s   in 0s
10.33.33.50
10.33.33.50 2013-11-11 13:19:35 (1.19 GB/s) - written to stdout [6790/6790]
10.33.33.50
10.33.33.50 Downloading Chef 11.8.0 for ubuntu...
10.33.33.50 Installing Chef 11.8.0
10.33.33.50 Selecting previously unselected package chef.
(Reading database ... 51095 files and directories currently installed.)
10.33.33.50 Unpacking chef (from .../chef_11.8.0_amd64.deb) ...
10.33.33.50 Setting up chef (11.8.0-1.ubuntu.12.04) ...
10.33.33.50 Thank you for installing Chef!
10.33.33.50 Starting Chef Client, version 11.8.0
10.33.33.50 Creating a new client identity for web.node using the validator key.
10.33.33.50 resolving cookbooks for run list: []
10.33.33.50 Synchronizing Cookbooks:
10.33.33.50 Compiling Cookbooks...
10.33.33.50 [2013-11-11T13:20:37+00:00] WARN: Node web.node has an empty run list.
10.33.33.50 Converging 0 resources
10.33.33.50 Chef Client finished, 0 resources updated

# Your client list will now include the new node, and will be listed on your chef server as well
-> % knife client list
chef-validator
chef-webui
web.node

# View your node list
-> % knife node list
web.node

# Inspect the new node
-> % knife client show web.node
admin:      false
chef_type:  client
json_class: Chef::ApiClient
name:       web.node
public_key: -----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs2W5AsOA9bLjkDQQRKtz
r7Isz36W6ZsGqjfi6KjRTyoNtkzVFbDidd9+PMA9TbuEgLHRxqlDjgPMfRseAEiM
mJ0dYxEMvRUFw4m552bCgiOqYND1tvfP8BD8LdDM2rlf10RcmRkBXeNvcqNhEQRj
zwtpTlMgqVWzGfeM6h0nj5tcUhtpCPahrwc7p5EhwaKboWQKc6wp9iXxbmBdQMOv
oUM+kh/wyBOBSvyHht32R8rzGQxfk/Q5wCFanaVpVD1/Eraxp5Dgs+c7bEU0m4cF
v5AmrjvLPV7rBLSb10cj2i7TaeNGzQhxKBQEZOx2PotakjY5UKzi3qoUrlR+qcPY
9wIDAQAB
-----END PUBLIC KEY-----

validator:  false

# Updating a node's run_list via knife
-> % knife node run_list add web.node "role[base]"
web.node:
  run_list: role[base]
```

## Bootstrapping a Chef server with Knife-solo

Update the knife config `.chef/knife.rb` to include

```ruby
cookbook_path    ["cookbooks", "site-cookbooks"]
node_path        "nodes"
role_path        "roles"
environment_path "environments"
data_bag_path    "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"
```

Ensure a `JSON` file for the Chef server exists named `nodes/chefserver.json`

    knife solo cook 10.33.33.40 -x vagrant -P vagrant --node-name chefserver

## License

This project rocks and uses MIT-LICENSE.
