zookeeper-cookbook
=========================
Installs and configures zookeeper single and multinode cluster. Zookeeper is essentially a distributed hierarchical key-value store,which is used to provide a distributed configuration service,synchronization service, and naming registry for large distributed systems.

Requirements
------------
* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client 
* Oracle_java recipe of basic-essentials cookbook

Recipes and supported platforms
-------------------------------
The following platforms have been tested with Test Kitchen. You may be 
able to get it working on other platform, with appropriate configuration updates

```
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| Recipe Name                     | AWSLinux  | AWSLinux  |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                                 |  2017.03  |  2016.09  | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| configure                       |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| default                         |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| install                         |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| service                         |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|

```
Recipe details
----------------

A recipe is the most fundamental configuration element within the organization. Receipe is authored using 
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required
* Is always executed in the same order as listed in a run-list 
* Must be stored in a cookbook under recipes directories
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration paramaters for any recipe(s)

### zookeeper::configure

1. Creates `['zookeeper']['conf']['dataDir']` ,`['zookeeper']['conf']['dataLogDir']` directories if not exists
1. Create/update `['zookeeper']['conf']['dataDir']`/myid file which contains brokerid of respective machine participating in `[zookeeper']['cluster']`
1. Create/update  main configuration file `['zookeeper']['conf']['dataDir']`/zoo.cfg and notifies delayed restart of `['zookeeper']['service']['name']`


### zookeeper::install

1. Download zookeeper binaries from `['zookeeper']['package']['uri']` to Chef::Config['file_cache_path']/`['zookeeper']['package']['name']`
1. Extact above downloaded package to `['zookeeper']['app']['base_directory']` as `['zookeeper']['app']['install_directory']`
1. Create/update symbolic link from `['zookeeper']['app']['install_directory']` to `['zookeeper']['app']['home_directory']`

### zookeeper::service

1. Create/update zookeeper system configuration from `['platform_family']`/zookeeper_sysconfig.erb to `['zookeeper']['service']['conf_file']` which restarts when service[`['zookeeper']['service']['name']`]
1. Downloads intialization script from `['platform_family']`/zookeeper_init.erb to /etc/init.d/`['zookeeper']['service']['name']` which restarts when service[`['zookeeper']['service']['name']`]
1. Do the following actions start and enable and supports start ,stop and restart in  `['zookeeper']['service']
['name']`

### zookeeper::uninstall

1.Disables and stops the zookeeper service
1.Deletes created files
1.Deletes symbolic link
1.Deletes created directories

Attributes
====
Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                                      | Type          | Description                                               |
|--------------------------------------------------------------------|---------------|-----------------------------------------------------------|
|['zookeeper']['package]['version']                                  | String        | Zookeeper  package version                                                                      |             
|['zookeeper']['package]['name]                                      | String        | Zookeper package name                                                                           |
|['zookeeper']['package]['uri']                                      | String        | URI for fetching zookeeper                                                                      |
|['zookeeper']['app'][base_directory']                               | String        | Base directory to store packages                                                                |
|['zookeeper']['app']['install_directory']                           | String        | Stores package of particular version                                                            |
|['zookeeper']['app']['home_directory']                              | String        | Stores soft links of each  latest    package installation  directory                            |
|['zookeeper']['service']['name']                                    | String        | Stores service name                                                                             |
|['zookeeper']['conf']['home_directory']                             | String        | Directory to store configuration binaries  of zookeeper package                             |
|['zookeeper']['service']['conf_file']                               | String        | Stores system configurations of differernt platforms                                       |
|['zookeeper']['conf']['dataDir']                                    | String        | Directory to store configuration files                                                                             |
|['zookeeper']['conf']['dataLogDir']                                 | String        | Directory to store logs                                                                         |
|['zookeeper']['conf']['clientPort']                                 | String        | Stores the client port                                                                          |
|['zookeeper']['leader']['connector_port']                           | String        | Stores the  connector port                                                                      |
|['zookeeper']['leader']['elector_port']                             | String        | Stores the elector port                                                                         |
|['zookeeper']['conf']['options']                                    | Hash          | Stores the configuration options                                                                |    

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)
* Akshitha Tekulapally (<akshitha.tekulapalli@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
