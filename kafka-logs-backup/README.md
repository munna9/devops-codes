kafka-logs-backup-cookbook
=========================
Deploy and configure operations on kafka-logs-backup cookbook.

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

### kafka-logs-backup::ecr_deploy

Deploys kafka-logs-backup container by referring data bag item kafka-logs-backup of communities data bag.

1. Create/update directory `['kafka-logs-backup]['logs']['directory']` with stickybit enabled
1. Create/update log purging script for kafka events. This script stops kafka-logs-backup container and remove files residing under `['kafka-logs-backup']['logs']['directory']` and starts again
1. Load phenom data bag item from data bag credentials
1. Download git repo by referring `['kafka-logs-backup']['config_repo']['uri']` value for repo name and `['kafka-logs-backup']['config_repo']['branch']` and revision
1. Synchronizes code to `['kafka-logs-backup']['config_repo']['checkout_directory']` notify **kafka-logs-backup** delayed restart for any new changes identified
1. Loads data bag referred by vault_name and app_name
1. Pulls docker image from Elastic container registry to the running node.
1. It runs container with specifications mentioned under data bag item **kafka-logs-backup** of **services** data bag.

### kafka-logs-backup::ecr_undeploy

Remove Deployed kafka-logs-backup container by referring data bag item **kafka-logs-backup** of **services** data bag.

1. Load phenom data bag item from data bag credentials
1. Remove log rotation configuration file of kafka events backup files
1. Identify phenom user's home directory and buildproperties checkout directory
1. removes directory recursively based on `['kafka-logs-backup']['config_repo']['checkout_directory']`
1. Loads data bag referred by vault_name and app_name
1. Container is stopped and removed after deregistering from ELB if defined.
1. It removes image(s) from the host.

Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                               | Type            | Description                                                          |
|-------------------------------------------------------------|-----------------|----------------------------------------------------------------------|
| ['kafka-logs-backup']['logs']['directory']                  | String          | Base directory for apache-storm configurations as per FHS3.0         |
| ['kafka-logs-backup']['config_repo']['uri']                 | String          | URI for fetching kafka-logs-config of git repo                       |
| ['kafka-logs-backup']['config_repo']['checkout_directory']  | String          | Directory name where kafka-logs-config repo to be cloned to          |

#### Environment Variables
|Attribute Name                                               | Type            | Description                                                          |
|-------------------------------------------------------------|-----------------|----------------------------------------------------------------------|
| ['kafka-logs-backup']['kafka-repo']['branch']               | String          | Git repo branch to checkout                                          |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
