docker cookbook
===============

Installs and configures docker binaries and other application programs. 
The Docker Cookbook is a library cookbook that provides custom resources for use in recipes.

Requirements
============
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
| install                       |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| service                       |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| uninstall                     |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| wrappers                      |    X      |    X     |    X     |    X     |    X     |    
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

### docker::install

Installs and configures docker-engine binaries based on `['docker']['binary']['packages']`

1. Identifies running node's platform and its version.
1. Create repository configuration file based on platform distribution.
1. Install docker binaries and its version based on platform and platform_version key-value pair. 
1. Installs each of those hash key value pair(s) with specific binary version if `node['docker]['pin_version']` is true,
   otherwise installs latest available version of package at the time converge.


### docker::service

Enables docker service across multiple distributions listed from above table.

1. Identifies service name of docker-enginer from `node['docker']['service']['name']`
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status` 
1. Performs action of `:enable` to keep the service up and running on successive restart whereas `:start` to make service up for current system

## docker::uninstall

Removes docker binaries, images, containers and services from host. 

1. Removes all containers and images by running `node['docker']['wrapper']['base_directory]/docker-clean_all`
1. Stops and disables `node['docker']['service']['name']`.
1. Removes all binaries defined under `node['docker']['binary']['packages']` hash based on running node's platform and platform_version.
1. Removes all wrapper scripts and docker-profile scripts.
1. Removes repository configuration files based on the distribution.
1. Removes sanitation script cron scheduler.

### docker::wrappers

Adds handy scripts and sanitation scripts for docker deamon. These scripts are should prefix with `docker-` and should not have spaces. 

1. Creates docker profile script `docker.sh` under `/etc/profile.d`.

    * This script reads user input and shifts the first command line argument and identifies the sub-command.
    * It locates for the script under default `$PATH` variables and executes the same. If not found, it switches back to docker deamon.

1. Create/update wrapper script(s) under `node['docker']['wrapper']['base_directory']`

    * `docker-access`     - It is advanced mode of `docker attach`,It accepts container name/ID as an input and invokes /bin/bash into it. If no container name/ID is given it displays running containers on interactive mode.  
    * `docker-clean`      - Identifies dangling images on host and cleans up. This script also run as a sanitation script on every day at 12:00 Hrs.
    * `docker-clean_all`  - Removes all containers including running containers and images.
    * `docker-destroy`    - It performs same job of `docker-access`, but its removes the given container name.
    * `docker-flush`      - It removes unused/stopped containers from the host.
    * `docker-flush_all`  - It remove all cotainers from the host including those which are currently running.

Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['docker']['repo']['base_uri']                | String        | Docker-engine repo URI as defined in installation manuals            |
| ['docker']['repo']['gpg_key']                 | String        | Docker-engine repo GPG Key URI as defined in installation manuals    |
| ['docker']['repo']['key_id']                  | String        | Docker-engine repo GPG Key URI (Applicable only for Debian family)   |
| ['docker']['download']['uri']                 | Hash          | Binary artifacts download URL                                        |
| ['docker']['pin_version']                     | Boolean       | If true, it installs only given version of package                   |
| ['docker']['binary']['packages']              | Hash          | Binary package and version for listed distribution                   |
| ['docker']['service']['name']                 | String        | docker-engine service name                                           |
| ['docker']['service']['owner']                | String        | docker-engine service owner                                          |
| ['docker']['service']['group']                | String        | docker-engine service group                                          |
| ['docker']['wrapper']['base_directory']       | String        | base location of wrapper scripts resides                             |
| ['docker']['wrapper']['scripts']              | Array         | List of script names which should be maintained                      |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
