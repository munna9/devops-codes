jenkins cookbook
================

Installs and configures Jenkins. Jenkins monitors executions of repeated jobs, such as building a software
project or jobs run by cron. Among those things, current Jenkins focuses on the following two jobs:
- Jenkins provides an easy-to-use so-called continuous integration system, making it easier for developers to integrate
  changes to the project, and making it easier for users to obtain a fresh build. 
- Monitoring executions of externally-run jobs, such as cron jobs and procmail jobs, even those that are run on a remote machine. 

Requirements
------------
* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client
* oracle_java,epel_repo,gitclient and chefdk recipes of basic-essentials cookbook

Recipes and supported platforms
-------------------------------
The following platforms have been tested with Test Kitchen. You may be 
able to get it working on other platform, with appropriate configuration updates
```
|-------------------------------|-----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                               |  2016.09  | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|----------|----------|----------|----------|
| chef_workstation              |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| conf_restore                  |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| configure                     |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| docker                        |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| install                       |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| nginx                         |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| plugins                       |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| service                       |    √      |    √     |    √     |    √     |    √     |    
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

### jenkins::chef_workstation

Configure Chef Administrator's workstation for `['jenkins']['service]['owner']`. This recipe is associated with chefdk recipe of basic-essentials 

1. Create/update `.chef/trusted_certs`, `.chef/knife.rb` directories along with it missing parents if not exits
1. Reads `jenkins` data bag from encrypted data bag  `credentials` and stores its result into a local variable jenkins_credentials
1. Create/update validation client and workstation client pem files for `['jenkins']['service']['owner']` 
1. Create/update ssl validation certificate with the name of currently registered chef server
1. Copy customized kitchen-docker-phenom gem to temporary location `Chef::Config['file_cache_path']`
1. Install kitchen-docker-phenom after copied to `Chef::Config['file_cache_path']`
1. Create/update configruation file for Chef administrator under `['jenkins']['app']['home_directory']`

### jenkins::conf_restore

Restore jenkins configuration files as a disaster stratergy

1. Refers `['jenkins']['conf']['uri']` and synchronizes to `['jenkins']['app']['home_directory]/jenksins_backup`
1. Synchronizes files from `['jenkins']['app']['home_directory]/jenksins_backup` to `['jenkins']['app']['home_directory]` and notifies jenkins for delayed restart
1. Ensures `['jenkins']['app']['home_directory]` recursively owned by `['jenkins']['service]['owner']` and `['jenkins']['service]['group']`

### jenkins::configure

Configure jenkins service and updates configurations

1. Create/update group `['jenkins']['service']['group']`
1. Create/update login shell for `['jenkins']['service']['owner']` to /bin/bash
1. Add `['jenkins']['service']['owner']` to `['docker']['service']['group']` to facilitate jenkins user to execute docker CLI without sudo command
1. Create/update `.ssh`, `.aws` directories along with it missing parents if not exits
1. Create `.ssh/config` for jenkins application user to mutate ssh configuration option to ignore HostKeyChecking and not to preserver known_hosts
1. Reads `jenkins` data bag from encrypted data bag  `credentials` and stores its result into a local variable jenkins_credentials
1. Create/update id_rsa key pair by reffering jenkins_credentials hash
1. Create authorized_keys with public key of id_rsa key pair to complete loop for password less logins for `['jenkins']['service']['owner']`
1. Create/update `.aws/config` file to define region of converging node by referring node['aws']['region']
1. Create/update policies configuration file for ECR repositories  
1. Create jenkins reverse proxy configuration file for Nginx proxy server 
1. Ensure all directories and files under jenkins's application user home directory are owned by `['jenkins']['service']['owner']` and `['jenkins']['service']['group']`


### jenkins::install

Installs jenkins binary packages and completed first boot configuration 

1. Based on converging node configure jenkins repository configuration file
1. Reads `['jenkins']['binary']['packages']` based on running platform and platform_version.
1. Installs each of those hash key value pair(s) with specific binary version if `node['jenkins]['pin_version']` is true,
   otherwise installs latest available version of package at the time converge.
1. Update `node['jenkins']['app']['home_directory']}/jenkins.install.InstallUtil.lastExecVersion` with '2.0' to skip unlock edition for unattended installation

### jenkins::nginx

Configures Reverse proxy configuration setup for Jenkins web UI. This recipe can be integrated with nginx cookbook and its recipes 
 
1. Query chef server for all hosts which are converged with jenkins_master role under this environment
1. Create/update jenkins.conf under `['nginx']['app']['conf_directory']` which is an reverse proxy setup for Jenkins web UI and notify nginx service for a delayed reload for any changes identified.

### jenkins::plugins

Configure Jenkin plugins for easy of administration. This recipe assume jenkins service installed and configured prior

1. Ensure `['jenkins']['app']['home_directory']/plugins` directory created and managed by `['jenkins']['service']['owner']` and `['jenkins']['service']['group']`
1. Traverse through `['jenkins']['plugin']['packages']` hash load plugin_name and its corresponding plugin_version for further processing.
1. If `['jenkins']['plugin']['fetch_latest']` is set true, download plugin from`['jenkins']['plugin']['permalink']` as `['jenkins']['plugin']['permalink']/plugin_name.hpi` to `['jenkins']['plugin']['home_directory]`
1. If `['jenkins']['plugin']['fetch_latest']` is set to false, download plugin from`['jenkins']['plugin']['uri']` as `['jenkins']['plugin']['uri']/plugin_name/plugin_version/plugin_name.hpi` to `['jenkins']['plugin']['home_directory]`.
1. In either the case of `['jenkins']['plugin']['fetch_latest']`, ensure each package is owned by `['jenkins']['service']['owner']` and `['jenkins']['service']['group']` notify `['jenkins']['service']['name']` delayed restart for any change

### jenkins::service

Enables jenkins service across multiple distributions listed from above table.

1. Identifies service name of jenkins from `['jenkins']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.


### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['jenkins']['pin_version']                    | Boolean       | If set true, each package is installed with specific version         |
| ['jenkins']['server']['name']                 | String        | Jenkins service name updated based on distribution                   |
| ['jenkins']['install']['uri']                 | String        | Jenkins repository base URL                                          | 
| ['jenkins']['install']['key']                 | String        | Jenkins repository GPG key location                                  | 
| ['jenkins']['binary']['packages']             | Hash          | Distribution specific hash for identified based on distribution      | 
| ['jenkins']['service']['name']                | String        | Service name of Jenkins binary package                               | 
| ['jenkins']['service']['owner']               | String        | Service owner of Jenkins binary package                              | 
| ['jenkins']['service']['group']               | String        | Service group of Jenkins binary package                              |
| ['jenkins']['service']['port']                | Number        | Service port alloted for Jenkins service                             |
| ['jenkins']['app']['home_directory']          | String        | Application home directory of Jenkins user                           |
| ['jenkins']['plugin']['home_directory']       | String        | Directory where each jenkins plugin is stored                        |
| ['jenkins']['plugin']['uri']                  | String        | Jenkins plugin base URI for fetching packages                        |
| ['jenkins']['plugin']['permalink']            | String        | Jenkins plugin permanent URI for fetching packages                   |
| ['jenkins']['plugin']['fetch_latest']         | Boolean       | If set true, latest packages will be fetched on every converge       |
| ['jenkins']['plugin']['packages']             | Hash          | Dictionary of packages with version for installation                 |
| ['jenkins']['restore']['uri']                 | String        | Git repository for restoring jenkins configurations                  |

## Environmental Variable

|Attribute Name                                | Type          | Description                                                          |
|----------------------------------------------|---------------|----------------------------------------------------------------------|
| ['aws_account_id']                           | String        | Aws account id defined for the converging node                       |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

License:: Copyright (C) 2017 Phenompeople Pvt Ltd

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
