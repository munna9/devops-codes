apache cookbook
===============

Installs and configures apache. Apache is an open source web sever software.   
This cookbook can be used both as a standalone role or can be multiplexed with another cookbook. 

Recipes and supported platforms
-------------------------------
The following platforms have been tested with Test Kitchen. You may be 
able to get it working on other platform, with appropriate configuration updates
```
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  | AWSLinux |  CentOS  |  CentOS  |  Ubuntu  | Ubuntu   |
|                               |  2017.03  |  2016.09 | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| fix_vulnerabilities           |           |          |          |          |          |          |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| install                       |           |          |          |          |          |          |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| service                       |           |          |          |          |          |          |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| uninstall                     |           |          |          |          |          |          |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|

```
Recipe details
==============

A recipe is the most fundamental configuration element within the organization. Recipe is authored using 
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required.
* Is always executed in the same order as listed in a run-list. 
* Must be stored in a cookbook under recipes directories.
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration parameters for any recipe(s)

### apache::fix_vulnerabilities

### apache::install

Installs platform and version specific binaries from respective providers.    

1. Reads `['apache']['binary']['packages']` based on respective platform and platform_version.   
1. Creates/updates main configuration file of apache.
1. Installs each of those hash key value pair(s) with specific binary version if `node['apache']['pin_version']` is true,
   otherwise installs latest available version of package at the time converge.

### apache::service

Enables apache service across multiple distributions listed from above table.

1. Identifies service name of apache from `node['apache']['service']['name']`. This variable is updated according to the distribution.
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

## apache::uninstall

Removes apache binaries and other configuration file(s). 

1. Stops and disables `['apache']['service']['name']`.
1. Removes all binaries defined under `node['apache']['binary']['packages']` hash based on running node's platform and platform_version.
1. Removes configuration files and/or directories if any.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['apache']['pin_version']                      | Boolean       | If true, it installs only given version of package                   |
| ['apache']['binary']['packages']               | Hash          | Binary package and version for listed distribution                   | 
| ['apache']['service']['name']                  | String        | Apache service name updated based on distribution                     |
| ['apache']['service']['owner']                  | String        | Apache service owner updated based on distribution                     |
| ['apache']['service']['group']                  | String        | Apache service group updated based on distribution                     |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
