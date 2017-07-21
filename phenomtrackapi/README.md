phenomtrack-api-cookbook
=========================
Deploy and configure  operations on phenomtrack-api cookbook.

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
| maxmind_repo                  |    √      |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|-----------|----------|----------|----------|----------|
| maxmind_repo_remove           |    √      |    √      |    √     |    √     |    √     |    √     |    
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

### phenomtrack-api::ecr_deploy

Deploys phenomtrack-api container by referring data bag item phenomtrack-api of communities data bag.

1. Loads data bag referred by vault_name and app_name.
1. Pulls docker image from Elastic container registry to the running node.
1. It runs container with specifications mentioned under data bag item **phenomtrack-api** of **services** data bag.

### phenomtrack-api::ecr_undeploy

Remove Deployed phenomtrack-api container by referring data bag item **phenomtrack-api** of **services** data bag.

1. Loads data bag referred by vault_name and app_name.
1. Container is stopped and removed after deregistering from ELB if defined.
1. It removes image(s) from the host.

### phenomtrack-api::maxmind_repo

Synchronizes maxmind_dbs repository. This recipe is dependent on basic-essentials::gitclient recipe

1. Load phenom data bag item from data bag credentials
1. Download git repo by referring `['phenomtrackapi']['maxmind_repo']['uri']` value for repo name and `['phenomtrackapi']['maxmind_repo']['branch']` and revision 
1. synchronizes code to `['phenomtrackapi']['maxmind_repo']['checkout_directory']`

### build-essentials::buildproperties_repo_remove

Removes buildproperties repo directory recursively from node.

1. Load phenom data bag item from data bag credentials
1. Identify phenom user's home directory and maxmind checkout directory
1. removes directory recursively based on `['phenomtrackapi']['maxmind_repo']['checkout_directory']`


## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)
* Hadassah Pearlyn (<hadassah.nagathota@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)