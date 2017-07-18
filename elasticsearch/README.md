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
* install_pip recipe of basic-essentials cookbook for curator recipe
* pod recipe of nginx-cookbook for elastic_elb

Recipes and supported platforms
-------------------------------

The following platforms have been tested with Test Kitchen. You may be 
able to get it working on other platform, with appropriate configuration updates
```
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  | AWSLinux |  CentOS  | CentOS   |  Ubuntu  |  Ubuntu  |
|                               |  2017.03  |  2016.09 | 7.2.1511 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| app_cluster_configure         |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| curator                       |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| elastic_elb                   |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| elk_cluster_configure         |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| install_from_archive          |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| install_from_repo             |    √      |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| plugins                       |    √      |    √     |    √     |    √     |    √     |    √     |    
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

### elasticsearch::app_cluster_configure

Configures application elasticsearch configuration file and master-slave setup of ES cluster.

1. Creates directory `['elasticsearch']['conf']['home_directory']`if not exists 
1. Creates directory `['elasticsearch']['app']['data_directory']`if not exists and update ownership for `['elasticsearch']['service']['owner']` and `['elasticsearch']['service']['group']`
1. Identify unicast hosts from environment who share same role and `es_cluster_name` and filter ipadress of each host
1. Notify minimum master nodes of identified unicast hosts by adding (number of unicast hosts)/2 +1
1. Remove current node from above identified hosts and finalize unicast hosts
1. Create/update elasticsearch sysconfig file options such as Garbage collector and ES_JAVA_OPTS and ES_HEAP_SIZE 
1. Create/update configurations file `[elasticsearch']['conf']['file']` and notify service `['elasticsearch']['service]['name']` for delayed restart
1. Create/update elasticsearch htpassword protected file for administrative operations
1. Creates elasticsearch nginx configuration file for protecting against any accidental or incidental removal of indexes

### elasticsearch::curator

Curator performs sanitation activities of elasticsearch metricbeat and logstash indices. Curator requires to access elasticsearch without nginx protection layer

1. Reads `['curator']['pip']['packages']`and identifies package name along with version and installs them along with its dependencies
1. Once the package is successfully installed, create a timestamp file at `Chef::Config['var_cache_path']` to maintain idempotent
1. Create symbolic link from `/usr/local/bin/curator` to `/usr/bin/curator` if not exists 
1. Create directory for holding curator configuration file(s)
1. Create and manage main configuration file at `node['curator']['conf']['home_directory']/curator.yml`
1. Create curator action configuration file by referring attributes `['curator']['logstash']['close']` and `['curator]['logstash]['delete']` values.
1. Cron Job will be scheduled based on length of characters of each action to avoid concurrent activities and uniqueness.

### elasticsearch::elastic_elb

Create light weight ngix load balancer to distribute request load keeping record persistancy. This recipe depends on nginx-pod recipe of nginx cookbook. 

1. Identify elasticsearch hosts from environment who share same role and `es_cluster_name` and filter ipadress of each host
1. Create/update elastic_elb.conf under `['nginx']['app']['directory']` with nodes identified from above array
1. Notify nginx-pod container to reload to reflect changes

### elasticsearch::elk_cluster_configure

Configures application elasticsearch configuration file and master-slave setup of ES cluster.

1. Creates directory `['elasticsearch']['conf']['home_directory']`if not exists 
1. Creates directory `['elasticsearch']['app']['data_directory']`if not exists and update ownership for `['elasticsearch']['service']['owner']` and `['elasticsearch']['service']['group']`
1. Identify unicast hosts from environment who share same role and `es_cluster_name` and filter ipadress of each host
1. Notify minimum master nodes of identified unicast hosts by adding (number of unicast hosts)/2 +1
1. Remove current node from above identified hosts and finalize unicast hosts
1. Create/update elasticsearch sysconfig file options such as Garbage collector and ES_JAVA_OPTS and ES_HEAP_SIZE
1. Create/update configurations file `[elasticsearch']['conf']['file']` and notify service `['elasticsearch']['service]['name']` for delayed restart
1. Create/update elasticsearch htpassword protected file for administrative operations
1. Creates elasticsearch nginx configuration file for protecting for any accidental or incidental removal of indexes

### elasticsearch::install_from_archive

Installs platform and version specific elasticsearch binaries from elastic archives.    
 
1. Downloads `['elasticsearch']['archive']['package']` from `['elasticsearch']['package']['uri']` based on platform
1. Installs package with specific binary version available with the help of `['elasticsearch']['package']['installer']` at the time of converge based on platform

### elasticsearch::install_from_repo


Installs platform and version specific elasticsearch binaries from elastic repositories.    
 
1. Reads `['elasticsearch']['package']['name']` and `['elasticsearch']['package']['version']` based on platform
1. Installs package with specific binary version available at the time of converge based on platform

### elasticsearch::plugins


Installs platform and version specific elasticsearch plugins from elastic repositories
 
1. Reads `['elasticsearch']['plugins']` hash based on `['elasticsearch']['package']['version']`
1. Identify plugin installer binaries based on `['elasticsearch']['package']['version']`
1. Installs plugins with specific version available at the time of converge based on platform

### elasticsearch::service

Enables elasticsearch service across multiple distributions listed from above table.

1. Identifies service name of elasticsearch from `['elasticsearch']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

### elasticsearch::uninstall

Removes elasticsearch binaries and other configuration file(s). 

1. Stops and disables `['elasticsearch']['service']['name']`.
1. Removes all binaries defined under `['elasticsearch']['package']['name']` based on running node's platform and platform_version.
1. Removes configuration files and/or directories if any.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/curator.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['curator']['pip']['packages']                | Hash          | Python pip packages along with version                               |
| ['curator']['conf']['home_directory']         | String        | Directory for curator configuration files                            | 
| ['curator']['indices']                        | Hash          | Indices and actions dictionary will remain open for accessing        |

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['elasticsearch']['package']['name']          | String        | Binary package name of elasticsearch as defined by elastic-repo      |
| ['elasticsearch']['package']['version']       | String        | Binary package version of elasticsearch based on distribution family | 
| ['elasticsearch']['archive']['package']       | String        | Binary pacakge name of elasticsearch archives                        |
| ['elasticsearch']['package']['installer']     | String        | Package installer based  on converging operating system family       |
| ['elasticsearch']['package']['uri']           | String        | URI for downloading archived packages                                |
| ['elasticsearch']['service']['name']          | String        | Elasticsearch service name updated based on distribution             |
| ['elasticsearch']['service']['owner']         | String        | Name of elasticserach service owner name                             |
| ['elasticsearch']['service']['group']         | String        | Name of elasticsearch service group name                             |
| ['elasticsearch']['nginx']['shield']          | Boolean       | Boolean flag to enable nginx security wrapper over elasticsearch     s|
| ['elasticsearch']['service']['host']          | String        | Application host IPV4 address where elasticsearch is hosted          |
| ['elasticsearch']['service']['port']          | Number        | Application TCP port where native ES application is listening        |
| ['elasticsearch']['service']['admin_port']    | Number        | Application TCP port where administraive operations can be performed |
| ['elasticsearch']['conf']['home_directory']   | String        | Base directory of elasticearch configurations                        |
| ['elasticsearch']['conf']['file']             | String        | Main configuration file of  elasticsearch                            |
| ['elasticsearch']['app']['home_directory']    | String        | Home directory of elasticearch binaries and other configurations     |
| ['elasticsearch']['app']['data_directory']    | String        | Home directory of elasticearch data and indices                      |
| ['elasticsearch']['conf']['home_directory']   | String        | Base directory of elasticearch configurations                        |
| ['elasticsearch']['plugins']                  | Hash          | Plugin along with version specific to elasticsearch binary pacakge   |  
| ['elasticsearch']['cluster']['options']       | Hash          | Configuration options for mutating elasticsearch application service |

## Role Variables

|Attribute Name                        | Type          | Description                                                                   |
|------------------------------------- |---------------|-------------------------------------------------------------------------------|
| ['elasticsearch']['heap_memory']     | String        | Elasticsearch application heap memory ceiling value                           |

## Environment Variables

|Attribute Name                        | Type          | Description                                                                   |
|------------------------------------- |---------------|-------------------------------------------------------------------------------|
| ['es_cluster_name']                  | String        | Elasticsearch application cluster name, used by app_cluster_configure.rb      |
| ['elk_cluster_name']                 | String        | Elasticsearch ELK cluster name, used by elk_cluster_configure.rb              |
| ['elasticsearch']['cluster_name']    | String        | Cluster Name appears for Elasticsearch                                        |
| ['elasticsearch']['server_name']     | String        | FQDN referred by Elasticsearch nginx wrapper configuration                    |
| ['elasticsearch']['server_port']     | String        | Elasticsearch node exposed port for HTTP REST API calls                       |
| ['elasticsearch']['elb_hostname']    | String        | Elasticsearch ELB host name, referred by Nginx service                        |
| ['elasticsearch']['elb_port']        | Number        | Elasticsearch ELB service port, referred by Nginx service                     |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors
License:: Copyright (C) 2017 Phenompeople Pvt Ltd
Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
