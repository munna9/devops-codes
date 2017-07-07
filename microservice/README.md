microservice-cookbook
=========================
Deploy and configure  operations on microservice cookbook.

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
|-------------------------------|-----------|-----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  | AWSLinux  |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                               |  2017.03  |  2016.09  | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|-----------|----------|----------|----------|----------|
| ecr_deploy                    |    √      |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|-----------|----------|----------|----------|----------|
| ecr_undeploy                  |    √      |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|-----------|----------|----------|----------|----------|

```
Recipe details
----------------

A recipe is the most fundamental configuration element within the organization. Recipe is authored using 
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required.
* Is always executed in the same order as listed in a run-list. 
* Must be stored in a cookbook under recipes directories.
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration parameters for any recipe(s)

### microservice::ecr_deploy

Deploys microservice container by referring data bag item microservice of services data bag.

1. Load data bag item phenom from credentials data bag 
1. Identify phenom user's home_directory and create each directory provided under `['microservice']['app']['directory_list']` 
1. Loads data bag referred by vault_name and app_name.
1. Pulls docker image from Elastic container registry to the running node.
1. It runs container with specifications mentioned under data bag item microservice of services data bag.

### microservice::ecr_undeploy

Remove Deployed microservice container by referring data bag item microservice of services data bag.

1. Loads data bag referred by vault_name and app_name.
1. Container is stopped and removed after deregistering from ELB if defined.
1. It removes image(s) from the host
### attributes/default.rb

|Attribute Name                                         | Type          | Description                                                   |
|-------------------------------------------------------|---------------|---------------------------------------------------------------|
| ['microservice']['app']['directory_list']             | Array         | directories which need to be present for microservice         |


## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)