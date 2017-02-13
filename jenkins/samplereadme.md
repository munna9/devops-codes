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
| admin_workstation             |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| conf_restore                  |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| configure                     |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| docker                        |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| install                       |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| plugins                       |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| service                       |    X      |    X     |    X     |    X     |    X     |    
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



Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['filebeat']['package']['name']               | String        | Binary package name of filebeat as defined by elastic-repo           |
| ['filebeat']['package']['version']            | String        | Binary package version of file beat based on distribution family     | 
| ['filebeat']['package']['log_file']           | String        | Distribution specific log file for identifying package management    | 
| ['filebeat']['service']['name']               | String        | Filebeat service name updated based on distribution                  |
| ['filebeat']['conf']['base_directory']        | String        | Base directory of main filebeat configuration file                   |
| ['filebeat']['conf']['home_directory']        | String        | Base directory where filebeat prospector configuration files resides |
| ['filebeat']['conf']['file']                  | String        | Absolute path of filebeat main configuration file                    |
| ['filebeat']['conf']['workers']               | String        | Number of process for harvesting files and forward to LS server      | 
| ['filebeat']['ssl']['home_directory']         | String        | Base directory where ssl certificate exists                          |
| ['filebeat']['ssl']['cert']                   | String        | Absolute path of logstash server's certificate file                  |
| ['filebeat']['files_to_watch']                | Hash          | Minimum files monitored by filebeat irrespective host chracteristics |

## Maintainers

* Venkat Bumireddy (<venkat.bumireddy@phenompeople.com>)

## License and Authors
License:: Copyright (C) 2017 Phenompeople Pvt Ltd
Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
