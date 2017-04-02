aws-cookbook
=========================
This cookbook provides resources for configuring and managing nodes running in Amazon Web Services as well as several AWS service offerings.

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
| inspector_agent_install       |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|---------- |----------|----------|----------|----------|
| inspector_agent_uninstall     |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|---------- |----------|----------|----------|----------|
| docker_undeploy               |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|

```
Recipe details
----------------

A recipe is the most fundamental configuration element within the organization. Receipe is authored using 
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required.
* Is always executed in the same order as listed in a run-list. 
* Must be stored in a cookbook under recipes directories.
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration paramaters for any recipe(s)

### aws::cli_install
Depends on basic-essentials::install_pip recipe and requires pip to be installed.

1. Refers `['aws']['cli']['packages']` hash and identifies pip packages to be installed.
1. Create/update symbolic link to /usr/loca/bin/aws from /usr/local/bin/aws if not exists.

### aws::cli_uninstall
Depends on basic-essentials::install_pip recipe and requires pip to be installed.

1. Refers `['aws']['cli']['packages']` hash and identifies pip packages to be uninstalled.
1. deletes symbolic link  /usr/loca/bin/aws.

### aws::ecr_login
In order to manage AWS components, authentication credentials need to be available to the node. There are 3 ways to handle this:

Enables login to AWS container registry service

    explicitly pass credentials parameter to the resource
    use the credentials in the ~/.aws/credentials file
    let the resource pick up credentials from the IAM role assigned to the instance

Also new resources can now assume an STS role, with support for MFA as well. Instructions are below in the relevant section.

Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['aws']['cli']['packages']                    | Hash          | Aws cli python command line packages dictionary                      |
| ['aws']['inspector_agent']['uri']             | String        | URL for downloading AWS inspector agent                              | 
| ['aws']['inspector_agent']['binary_path']     | String        | Location of installation binaries for aws inspector agent            |
| ['aws']['inspector_agent']['binary_name']     | String        | Binary package of inspector agent, based on node's platform family   |
| ['aws']['inspector_agent']['service_name']    | String        | Location of installation binaries for aws inspector agent            |
 

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
