logstash cookbook
===============

Installs and configures logstash. An extensible logging pipeline. 

Requirements
------------

* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client
* elastic_repo recipe of basic-essentials cookbook
* oracle_java_default recipe of basic-essentials cookbook

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
| http_configure                |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| install                       |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| service                       |    X      |    √     |    √     |    √     |    X     |    
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

### logstash::http_configure

Configures default configuration file and ssl certificate files and other essential directories

1. Creates directories `['logstash']['conf']['home_directory']` recursively
1. Create/update http input and output configuration files and notifies service `['logstash']['service]['name']` to be delayed restart

### logstash::configure

Configures default configuration file and ssl certificate files and other essential directories.

1. Creates directories `['logstash']['conf']['home_directory'], ['logstash']['ssl']['home_directory']` recursively
1. Create/update ssl certificate key pair based on `['logstash']['certificate_name']` variable defined
1. Fetch grok patterns applied for each of the data bag item from un-encrypted data bag  `beat_propespectors`  and re-structure
1. Create/update main logstash input and output configuration files and notifies service `['logstash']['service]['name']` to be delayed restart
1. Create/update custom filters configurations file and notifies service `['logstash']['service]['name']` to be delayed restart

### logstash::install

Installs platform and version specific logstash binaries from elastic repositories.     

1. Reads `['logstash']['package']['name']` and `['logstash']['package']['version']` based on platform.   
1. Installs package with specific binary version available at the time of converge based on platform.
1. Executes `node['logstash']['app']['home_directory']/bin/system-install` to generate init script based on distribution

### logstash::service

Enables logstash service across multiple distributions listed from above table. Logstash binaries not supported to generate startup scripts on Amazon Linux and Ubuntu 14.04. 

1. Identifies service name of logstash from `node['logstash']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

## logstash::uninstall

Removes logstash binaries and other configuration file(s). 

1. Stops and disables `['logstash']['service']['name']`.
1. Removes all binaries defined under `node['logstash']['package']['name']` based on running node's platform and platform_version.
1. Removes configuration files ssl certifcate pair and/or directories if any.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['logstash']['package']['name']               | String        | Binary package name of logstash as defined by elastic-repo           |
| ['logstash']['package']['version']            | String        | Binary package version of logstash based on distribution family      | 
| ['logstash']['service']['name']               | String        | Logstash service name updated based on distribution                  |
| ['logstash']['service']['owner']              | String        | Logstash service owner                                               |
| ['logstash']['service']['group']              | String        | Logstash service group                                               |
| ['logstash']['service']['port']               | String        | Logstash service port updated based on host and environment          |
| ['logstash']['http']['port']                  | String        | Logstash http input service port                                     |
| ['logstash']['app']['home_directory']         | String        | Base directory of logstash binaries and other essentials tools       |
| ['logstash']['ssl']['home_directory']         | String        | Base directory of SSL  key pair certificate files exits              |
| ['logstash']['conf']['home_directory']        | String        | Base directory of logstash configurations                            |
| ['logstash']['ssl']['cert']                   | String        | Absolute path of logstash server's certificate file                  |
| ['logstash']['ssl']['key']                    | String        | Absolute path of logstash server's key file                          |
| ['logstash']['template']['name']              | String        | Logstash configuration template name to be loaded                    |
| ['logstash']['template']['file']              | String        | Absolute path of logstash configuration template file                |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

License:: Copyright (C) 2017 Phenompeople Pvt Ltd

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
