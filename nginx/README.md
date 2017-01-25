nginx cookbook
===============

Installs and configures nginx. Nginx("engine X") is a high-performance web server and reverse proxy server.  
This cookbook can be used both as a standalone role or can be multiplexed with another cookbook. 

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
| install_client                |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| service                       |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| uninstall                     |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| default_site                  |    X      |    X     |    X     |    X     |    X     |    
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

### nginx::install

Installs platform and version specific binaries from respective providers.    

1. Reads `['nginx']['binary']['packages']` based on respective platform and platform_version.   
1. Creates/updates main configuration file of Nginx and instructs to restart at the end of converge.
1. Installs each of those hash key value pair(s) with specific binary version if `node['nginx]['pin_version']` is true,
   otherwise installs latest available version of package at the time converge.
1. Removes distribution specific configuration directories of debian family.


### nginx::service

Enables nginx service across multiple distributions listed from above table.

1. Identifies service name of nginx from `node['nginx']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

## nginx::uninstall

Removes nginx binaries and other configuration file(s). 

1. Stops and disables `['nginx']['service']['name']`.
1. Removes all binaries defined under `node['nginx']['binary']['packages']` hash based on running node's platform and platform_version.
1. Removes configuration files and/or directories if any.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['nginx']['pin_version']                      | Boolean       | If true, it installs only given version of package                   |
| ['nginx']['binary']['packages']               | Hash          | Binary package and version for listed distribution                   | 
| ['nginx']['service']['name']                  | String        | Nginx service name updated based on distribution                     |
| ['nginx']['service']['owner']                 | String        | Nginx service owner updated based on distribution                    |
| ['nginx']['service']['group']                 | String        | Nginx service group updated based on distribution                    |                                          |
| ['nginx']['app']['base_directory']            | String        | Base directory where all nginx configuration and binaries resides    |
| ['nginx']['app']['conf_directory']            | String        | Base directory of all configuration file resides                     |
| ['nginx']['app']['log_directory']             | String        | Base directory of all log files for nginx                            |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)