Metricbeat cookbook
===============

Installs and configures Metricbeat. Metricbeat sends log files directly to Elasticsearch. 

Requirements
------------
* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client
* elastic_repo recipe of basic-essentials cookbook

Recipes and supported platforms
-------------------------------
The following platforms have been tested with Test Kitchen. You may be 
able to get it working on other platform, with appropriate configuration updates
```
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  | AWSLinux |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                               |  2017.03  |  2016.09 | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| configure                     |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| import_dash_board             |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| install                       |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| service                       |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| uninstall                     |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|

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

### metricbeat::configure

Configures default configuration file and update metricbeat configurations

1. Refers an un-encrypted data bag item beat_prospectors/`node.chef_environment` and loads hash to `app_procs_to_watch`
1. Remove metricbeat full parsing configuration file to avoid fludding with processes read
1. Merges above result with key-value pair of`['metricbeat']['procs_to_watch']`  
1. Notifies service `['Metricbeat]['service]['name']` to be restarted

### metricbeat::import_dash_board

Installs metricbeat dashboard into elasticsearch

1. Create/update wrapper script, which import dashboard into elasticsearch at `node['metricbeat]['app']['base_directory']/scripts/es_dashboards` and execute on every change of elasticsearch server and/or port

### metricbeat::install

Installs platform and version specific Metricbeat binaries from elastic repositories.     

1. Reads `['metricbeat']['package']['name']` and `['metricbeat']['package']['version']` based on platform   
1. Installs package with specific binary version available at the time converge based on platform

### metricbeat::service

Enables Metricbeat service across multiple distributions listed from above table.

1. Identifies service name of metricbeat from `['metricbeat']['service']['name']`
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility

## Metricbeat::uninstall

Removes metricbeat binaries and other configuration file(s). 

1. Stops and disables `['metricbeat']['service']['name']`
1. Removes all binaries defined under `['metricbeat']['package']['name']` based on running node's platform and platform_version
1. Removes configuration files and/or directories from `['metricbeat']['conf']['base_directory']`if exists


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type      | Description                                                                |
|---------------------------------------------- |-----------|----------------------------------------------------------------------------|
| ['metricbeat']['package']['name']             | String    | Binary package name of Metricbeat as defined by elastic-repo               |
| ['metricbeat']['package']['pin_version']      | String    | If true, it installs only given version of package                         |
| ['metricbeat']['package']['version']          | String    | Binary package version of file beat based on distribution family           | 
| ['metricbeat']['service']['name']             | String    | Metricbeat service name updated based on distribution                      |
| ['metricbeat']['conf']['base_directory']      | String    | Base directory of main Metricbeat configuration file                       |
| ['metricbeat']['app']['base_directory']       | String    | Base directory where metricbeat is installed                               |
| ['metricbeat']['conf']['file']                | String    | Absolute path of Metricbeat main configuration file                        |
| ['metricbeat']['conf']['workers']             | String    | Number of process for harvesting files and forward to LS server            | 
| ['metricbeat']['procs_to_watch']              | Hash      | Minimum processes monitored by Metricbeat irrespective host chracteristics |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors
License:: Copyright (C) 2017 Phenompeople Pvt Ltd

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
