zookeeper-cookbook
=========================
Installs and configures zookeeper single and multinode cluster. Zookeeper is essentially a distributed hierarchical key-value store,which is used to provide a distributed configuration service,synchronization service, and naming registry for large distributed systems.

Requirements
------------
* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client 
* oracle_java recipe of basic-essentials cookbook

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

1. Create `['zookeeper']['conf']['dataDir']` ,`['zookeeper']['conf']['dataLogDir']` directories if not exists
1. Create/update `['zookeeper']['conf']['dataDir']`/myid file with brokerid of respective machine participating in `[zookeeper']['cluster']`
1. Create/update main configuration file `['zookeeper']['conf']['file']` and notifies delayed restart of `['zookeeper']['service']['name']` if any change occurs


### zookeeper::install

1. Download zookeeper binaries from `['zookeeper']['package']['uri']`
1. Extact above downloaded package to `['zookeeper']['app']['base_directory']` as `['zookeeper']['app']['install_directory']`
1. Create symbolic link from `['zookeeper']['app']['install_directory']` to `['zookeeper']['app']['home_directory']` if not exists

### zookeeper::service

1. Identifies running node's platform and its version
1. Creates `['zookeeper']['service']['name']` init service and configuration options file
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility

### zookeeper::uninstall

1. Stops and disables `['zookeeper']['service']['name']`
1. Removes following files `['zookeeper']['service']['conf_file'],/etc/init.d/#{node['zookeeper']['service']['name']},Chef::Config['file_cache_path']}/#{node['zookeeper']['package']['name']}`
1. Removes following directories `['zookeeper']['conf']['dataDir'],['zookeeper']['conf']['dataLogDir'],['zookeeper']['app']['install_directory']`
1. Removes symbolic link `['zookeeper']['app']['home_directory']`

Attributes
==========
Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                     | Type          | Description                                                        |
|---------------------------------------------------|---------------|--------------------------------------------------------------------|
|['zookeeper']['package']['version']                | String        | Binary package version of zookeeper                                | 
|['zookeeper']['package']['name']                   | String        | Binary package name of zookeeper                                   |
|['zookeeper']['package']['uri']                    | String        | URI for downloading archived packages of zookeeper                 |
|['zookeeper']['app']['base_directory']             | String        | Base directory of zookeeper binaries and configurations            |
|['zookeeper']['app']['install_directory']          | String        | Home directory of zookeeper binaries of given version              |
|['zookeeper']['app']['home_directory']             | String        | Reference directory of zookeeper binaries and configurations       |
|['zookeeper']['service']['name']                   | String        | Zookeeper service name updated based on distribution               |
|['zookeeper']['service']['conf_file']              | String        | Stores system configurations of differernt platforms               |
|['zookeeper']['conf']['file']                      | String        | Main configuration file zookeeper service                          |
|['zookeeper']['conf']['dataDir']                   | String        | Location of in-memory database snapshots                           |
|['zookeeper']['conf']['dataLogDir']                | String        | Directory to store transaction log of updates to the database      |
|['zookeeper']['conf']['clientPort']                | String        | The port to listen for client connections                          |
|['zookeeper']['conf']['options']                   | Hash          | Configuration options matrix derived for zookeeper service         |
|['zookeeper']['leader']['connector_port']          | String        | Port used for connecting to leader                                 |
|['zookeeper']['leader']['elector_port']            | String        | Port used for electing leader,required when electionAlg not '0'    |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
