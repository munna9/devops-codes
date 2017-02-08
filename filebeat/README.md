filebeat cookbook
===============

Installs and configures filebeat. Filebeat sends log files to Logstash or directly to Elasticsearch. 

Requirements
------------
* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client
* elastic_repo recipe of basic-essentials cookbook
* Requires hostname appropriately updated as <env>-<application><seq.number> failing which, it defaults  to _default-dummy01

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
| install                       |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| prospectors                   |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| service                       |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| uninstall                     |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|

```
Recipe details
==============

A recipe is the most fundamental configuration element within the organization. Receipe is authored using 
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required.
* Is always executed in the same order as listed in a run-list. 
* Must be stored in a cookbook under recipes directories.
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration paramaters for any recipe(s)

### filebeat::configure

Configures default configuration file and ssl certificate files and other essential directories.

1. Creates directories `['filebeat']['conf']['home_directory'], ['filebeat']['ssl']['home_directory']` recursively
1. Create/update private ssl certificate of respective environment.
1. Remove filebeat full parsing configuration file to avoid fludding with log readings from /var/log.
1. Identify logstash servers and enable load balancing features for filebeat
1. Create/update main filebeat configuration file `['filebeat']['conf']['file']` and notifies service `['filebeat']['service]['name']` to be restarted
 
### filebeat::install

Installs platform and version specific filebeat binaries from elastic repositories.     

1. Reads `['filebeat']['package']['name']` and `['filebeat']['package']['version']` based on platform.   
1. Installs package with specific binary version available at the time converge based on platform.

### filebeat::prospectors

Create/update configurations files under `['filebeat']['conf']['home_directory']`.    

1. Invokes parse_host_name function from libraries/default.rb which updates two varialbes `host_env` and `host_role` by parsing at hostname 
1. Refers an un-encrypted data bag item fb_prospectors/`host_env-host_role`and loads hash `app_files_to_watch`.
1. Merges above result with key-value pair of`['filebeat']['files_to_watch']`.  
1. converts `['filebeat']['files_to_watch']` to yaml syntax and remove header section.
1. creates each application specific configuration file with key name as filename and value as yml file.
1. notifies service `['filebeat]['service]['name']` to be restarted

### filebeat::service

Enables filebeat service across multiple distributions listed from above table.

1. Identifies service name of filebeat from `node['filebeat']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

## filebeat::uninstall

Removes filebeat binaries and other configuration file(s). 

1. Stops and disables `['filebeat']['service']['name']`.
1. Removes all binaries defined under `node['package']['name']` based on running node's platform and platform_version.
1. Removes configuration files and/or directories if any.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['filebeat']['package']['name']               | String        | Binary package name of filebeat as defined by elastic-repo           |
| ['filebeat']['package']['version']            | String        | Binary package version of file beat based on distribution family     | 
| ['filebeat']['package']['log_file']           | String        | Distribution specific log file for identifying package management    | 
| ['filebeat']['service']['name']               | String        | Filebeat service name updated based on distribution                  |
| ['filebeat']['conf']['base_directory']        | String        | Base directory of main filebeat configuration file                   |
| ['filebeat']['conf']['home_directory']        | String        | Base directory where filebeat prospector configuration files resides |
| ['filebeat']['conf']['file']                  | String        | Absolute path of filebeat main configuration file                    |
| ['filebeat']['conf']['workers']               | String        | Number of process for harvesting files and forward to LS server      | 
| ['filebeat']['ssl']['home_directory']         | String        | Base directory where ssl certificate exists                          |
| ['filebeat']['ssl']['cert']                   | String        | Absolute path of logstash server's certificate file                  |
| ['filebeat']['files_to_watch']                | Hash          | Minimum files monitored by filebeat irrespective host chracteristics |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors
License:: Copyright (C) 2017 Phenompeople Pvt Ltd
Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
