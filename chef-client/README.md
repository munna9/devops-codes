chef-client-cookbook
=========================
A chef-client is an agent that runs locally on every node that is under management by Chef. 
When a chef-client is run, it will perform all of the steps that are required to bring the node into the expected state
This cookbook configures chef-client daemon and log rotation script for chef-client process.

Requirements
------------
* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client 

Recipes and supported platforms
-------------------------------
The following platforms have been tested with Test Kitchen. You may be 
able to get it working on other platform, with appropriate configuration updates
```
|-------------------------------|-----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                               |  2016.09  | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|----------|----------|----------|----------|
| configure                     |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| service                       |    -      |    -     |    -     |    -     |    -     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| uninstall                     |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|

```
Recipe details
----------------

A recipe is the most fundamental configuration element within the organization. Receipe is authored using 
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required.
* Is always executed in the same order as listed in a run-list. 
* Must be stored in a cookbook under recipes directories.
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration paramaters for any recipe(s)

### chef-client::configure

Creates essential directories and files for configuration and log rotation of chef-client daemon

1. Creates `[chef-client]['conf']['directory']`,`['chef-client']['log']['directory']` and `['chef-client']['lock']['directory']` directories recursively along with missing directories.
1. Creates `['chef-client']['log']['filename']`, `['chef-client']['lock']['filename']`, `['chef-client']['conf']['encrypted_data_bag_secret']` and `['chef-client']['log']['conf_file']` files if missing.

### chef-client::service

Configures chef-client deamon and converts it as a init.d and systemd service

1. Identifies running node's platform and its version.
1. Creates chef-client_service and chef-client file(s) and starts.
1. Chef-client on each node based on `[chef-client]['pool']['interval']` and `['chef-client']['pool']['splay']`.
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

### chef-client::uninstall

Removes chef-client configuration file(s) and directories 

1. Stops and disables chef-client
1. Removes following directories `[chef-client]['conf']['directory']`,`['chef-client']['log']['directory']` and `['chef-client']['lock']['directory']`
1. Removes configuration files `['chef-client']['log']['filename']`, `['chef-client']['lock']['filename']`, `['chef-client']['conf']['encrypted_data_bag_secret']` and `['chef-client']['log']['conf_file']`


Attributes
====
Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                         | Type          | Description                                                   |
|-------------------------------------------------------|---------------|---------------------------------------------------------------|
| ['chef-client']['binary']['path']                     | String        | Default Chef client binary version                            |
| ['chef-client']['conf']['directory']                  | String        | Base configuration directory of chef-client deamon            |
| ['chef-client']['conf']['encrypted_data_bag_secret']  | String        | Encrypted file for decrypted file                             |
| ['chef-client']['service']['name']                    | String        | Binary path of chef-client                                    |
| ['chef-client']['conf']['client_file']                | String        | Main configuration file of chef-client daemon                 |
| ['chef-client']['service']['conf_file']               | String        | Main service configuration file, ready by chef-client daemon  |
| ['chef-client']['log']['directory']                   | String        | Log directory for chef-client daemon logs                     |
| ['chef-client']['log']['file_name']                   | String        | Chef-client deamon logs into the given file and at location   |
| ['chef-client']['log']['conf_file']                   | String        | Logrotator configuration file of chef-client daemon           |
| ['chef-client']['lock']['directory']                  | String        | Lock file name holder to avoid concurrent services            |
| ['chef-client']['lock']['file_name']                  | String        | Lock file name to avoid concurrent service                    |
| ['chef-client']['pool']['interval']                   | Number        | Run chef-client periodically, in seconds                      |
| ['chef-client']['pool']['splay']                      | Number        | The splay time for running at intervals, in seconds           |   


## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
