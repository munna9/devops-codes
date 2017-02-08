kibana cookbook
===============

Installs and configures kibana. Kibana Explore and visualize your Elasticsearch data

Requirements
------------

* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client
* elastic_repo recipe of basic-essentials cookbook
* epel_repo recipe of basic-essentials cookbook for RedHat family 
* install,service recipes from nginx cookbook

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

### kibana::configure

Configures default configuration file and nginx configuration files and other essential directories.

1. Creates directory `['kibana']['conf']['home_directory']`if not exists 
1. Create/update configuration file of kibana and notifies service `['kibana']['service]['name']` to be restarted

### kibana::nginx
1. Create/update configuration file of nginx-kibana integration file and notifies service `['nginx]['service]['name]` to be reloaded 

### kibana::install

Installs platform and version specific kibana binaries from elastic repositories.    

1. Reads `['kibana']['package']['name']` and `['kibana']['package']['version']` based on platform.   
1. Installs package with specific binary version available at the time of converge based on platform.

### kibana::service

Enables kibana service across multiple distributions listed from above table.

1. Identifies service name of kibana from `['kibana']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

## kibana::uninstall

Removes kibana binaries and other configuration file(s). 

1. Stops and disables `['kibana']['service']['name']`.
1. Removes all binaries defined under `['kibana']['package']['name']` based on running node's platform and platform_version.
1. Removes configuration files and/or directories if any.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['kibana']['package']['name']                 | String        | Binary package name of kibana refers to elastic-repo                 |
| ['kibana']['package']['version']              | String        | Binary package version of kibana based on distribution family        | 
| ['kibana']['service']['name']                 | String        | Kibana service name updated based on distribution                    |
| ['kibana']['service']['port']                 | String        | Kibana service port updated based on host and environment            |
| ['kibana']['service']['uri']                  | String        | Kibana service URI, defaults to localhost                            |
| ['kibana']['conf']['home_directory']          | String        | Base directory of kibana configurations                              |
| ['kibana']['conf']['file']                    | String        | Main configuration file of kibana service                            |
| ['kibana']['nginx']['conf_file']              | String        | Absolute path of kibana-nginx configuration file                     |
| ['kibana']['index']['name']                   | String        | Absolute path of logstash server's key file                          |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
