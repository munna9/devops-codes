kafka-cookbook
=========================

Installs and configures kafka single and multinode cluster. Kafka is an open-source stream processing platform, aims to provide a unified, high-throughput, low-latency platform for handling real-time data feeds.

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

### kafka::configure

1. Create `['kafka']['data']['directory']` ,`['kafka']['conf']['home_directory']`, `['kafka']['log']['home_directory']` directories if not exists
1. Create/update main configuration file `['kafka']['conf']['home_directory']/server.properties` and notifies delayed restart of `['kafka']['service']['name']` if any change occurs


### kafka::install

1. Download zookeeper binaries from `['kafka']['package']['uri']`
1. Extact above downloaded package to `['kafka']['app']['base_directory']` as `['kafka']['app']['install_directory']`
1. Create symbolic link from `['kafka']['app']['install_directory']` to `['kafka']['app']['home_directory']` if not exists

### kafka::service

1. Identifies running node's platform and its version
1. Creates `['kafka']['service']['name']` init service and configuration options file
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility

### kafka::uninstall

1. Stops and disables `['kafka']['service']['name']`
1. Removes following files `['kafka']['service']['conf_file'],/etc/init.d/#{node['kafka']['service']['name']},Chef::Config['file_cache_path']}/#{node['kafka']['binary']['package']}`
1. Removes following directories `['kafka']['data']['directory'],['kafka']['conf']['home_directory'],['kafka']['data']['directory'],['kafka']['app']['install_directory'],['kafka']['log']['home_directory']`
1. Removes symbolic link `['zookeeper']['app']['home_directory']`

Attributes
==========
Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                | Type       | Description                                                        |
|----------------------------------------------|------------|--------------------------------------------------------------------|
|['kafka']['scala']['version']                 | String     | Binary package version of kafka scala                              |             
|['kafka']['package']['version']               | String     | Binary package version of kafka                                    |
|['kafka']['binary']['package']                | String     | Binary package name of kafka                                       |
|['kafka']['package']['uri']                   | String     | URI for downloading archived packages of kafka                     |
|['kafka']['app']['base_directory']            | String     | Base directory of kafka binaries and configurations                |
|['kafka']['app']['install_directory']         | String     | Home directory of kafka binaries of given version                  |
|['kafka']['app']['home_directory']            | String     | Reference directory of kafka binaries and configurations           |
|['kafka']['log']['home_directory']            | String     | Base directory of Kafka logs                                       |
|['kafka']['conf']['home_directory']           | String     | Base directory of kafka configuration files                        |
|['kafka']['service']['name']                  | String     | Service name defined for kafka service                             |
|['kafka']['service']['conf_file']             | String     | Stores system configurations of differernt platforms               |
|['kafka']['service']['port']                  | Integer    | Service port configured for Kafka                                  |
|['kafka']['data']['directory']                | String     | Kafka service data directory                                       |
|['kafka']['conf']['log.retention.hours']      | Integer    | Kafka log retention hours configuration option                     |
|['kafka']['conf']['compression.type']         | String     | Kafka data compression method at the producer                      |
|['kakfa']['conf']['options']                  | Hash       | Configuration options matrix derived for kafka service             |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
