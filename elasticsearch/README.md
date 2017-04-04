elasticsearch cookbook
===============

Installs and configures elasticsearch. Elasticsearch is a distributed RESTful search engine built for the cloud

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
| install                       |    √      |    √     |    √     |    √     |    √     |    
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

### elasticsearch::configure

Configures default configuration file and master-slave setup of ES cluster.

1. Creates directory `['elasticsearch']['conf']['home_directory']`if not exists 
1. Create/update configurations file and notifies service `['elasticsearch']['service]['name']` to be restarted

### elasticsearch::install

Installs platform and version specific elasticsearch binaries from elastic repositories.    
 

1. Reads `['elasticsearch']['package']['name']` and `['elasticsearch']['package']['version']` based on platform.   
1. Installs package with specific binary version available at the time of converge based on platform.

### elasticsearch::service

Enables elasticsearch service across multiple distributions listed from above table.

1. Identifies service name of elasticsearch from `['elasticsearch']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

## elasticsearch::uninstall

Removes elasticsearch binaries and other configuration file(s). 

1. Stops and disables `['elasticsearch']['service']['name']`.
1. Removes all binaries defined under `['elasticsearch']['package']['name']` based on running node's platform and platform_version.
1. Removes configuration files and/or directories if any.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['elasticsearch']['package']['name']          | String        | Binary package name of elasticsearch as defined by elastic-repo      |
| ['elasticsearch']['package']['version']       | String        | Binary package version of elasticsearch based on distribution family | 
| ['elasticsearch']['service']['name']          | String        | Elasticsearch service name updated based on distribution             |
| ['elasticsearch']['service']['owner']         | String        | Name of elasticserach service owner name                             |
| ['elasticsearch']['service']['group']         | String        | Name of elasticsearch service group name                             |
| ['elasticsearch']['conf']['home_directory']   | String        | Base directory of elasticearch configurations                        |
| ['elasticsearch']['conf']['file']             | String        | Main configuration file of  elasticsearch                            |
| ['elasticsearch']['conf']['options']          | Hash          | Configuration options for mutating elasticsearch service             |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors
License:: Copyright (C) 2017 Phenompeople Pvt Ltd
Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)