mongodb cookbook
===============

Installs and configures mongodb package suite. MongoDB is built for scalability, performance and high availability, scaling from single server deployments to large, complex multi-site architectures. By leveraging in-memory computing, MongoDB provides high performance for both reads and writes.MongoDB's native replication and automated failover enable enterprise-grade reliability and operational flexibility. MongoDB is an open-source database used by companies of all sizes, across all industries and for a wide variety of applications. It is an agile database that allows schemas to change quickly as applications evolve, while still providing the functionality developers expect from traditional databases, such as secondary indexes, a full query language and strict consistency. MongoDB has a rich client ecosystem including hadoop integration, officially supported drivers for 10 programming languages and environments, as well as 40 drivers supported by the user community. 

Requirements
------------
* Chef 12.5.x or higher
* Ruby 2.1 or higher (preferably, the Chef full-stack installer)
* Internet accessible node/client 

Recipes and supported platforms
-------------------------------
The following platforms have been tested with Test Kitchen. You may be able to get it working on other platform, with appropriate configuration updates
Ubuntu is not considered as a database hosting operating systems due to business and package distribution stratergy

```
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  | AWSLinux |  CentOS  |  CentOS  |  Ubuntu  | Ubuntu   |
|                               |  2017.03  |  2016.09 | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| configure                     |    √      |    √     |    √     |    √     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| fine_tunning                  |    X      |    √     |    √     |    √     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| install                       |    √      |    √     |    √     |    √     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| master                        |    √      |    √     |    √     |    √     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| service                       |    √      |    √     |    √     |    √     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| uninstall                     |    √      |    √     |    √     |    √     |    X     |    X     |    
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

Please read attributes section for configuration parameters for any recipe(s)

### mongodb::configure

Configures main configuration file and essential elements of mongodb     

1. Creates directory recursively `[mongodb']['storage']['path']`
1. Creates/updates symmetric key file `['mongodb']['app']['key_file']` if not exists
1. Creates/updates `['mongodb']['conf']['file']` and instructs mongodb service restarts at the end of converge

### mongodb::fine_tunning

Mutate host for better performance and best practices depicted for mongodb

1. Create/update `/etc/security/limits.d/['mongodb']['service']['owner'].conf` for setting update syslimits
1. Disable transparent huge pages for defrag and enabled
1. Disable NUMA(Non Uniform Memory allocation) for machine
1. Disable SELinux if enabled on every converge
1. Create/update `['mongodb']['sysctl']['conf']` for updating sysctl updation options
1. Set Read ahead for block drives mounted for `['mongodb']['storage']['path']`

### mongodb::install

Installs platform and version specific binaries from respective providers    

1. Creates mongodb-repo repository based on running node's platform family
1. Reads `['mongodb']['binary']['packages']` based on respective platform and platform_version.   
1. Installs each of those hash key value pair(s) with specific binary version based on  `['mongodb']['major']['version']` 

### mongodb::master

Configure master/primary node of mongodb cluster

1. Create `['mongodb']['storage']['path']` directory if not exists
1. Create `['nongodb']['conf']['file']` for plain authentication
1. Create/update `['mongodb']['app']['base_directory']/mongo_users.js` for creating basic users for authentication
1. Create/update `['mongodb']['app']['base_directory']/mongo_replica.js` for creating replica nodes by identifying hosts which configured with mongodb::configure converged

### mongodb::service

Enables nginx service across multiple distributions listed from above table.

1. Identifies service name of nginx from `['mongodb']['service']['name']`. This variable is updated according to the distribution.
1. Controls how the chef-client is to attempt to manage a service `:enable`, `:start`,`:restart`, `:status`, `:reload` 
1. Performs action of `:enable` to keep the service up and running on successive restarts whereas `:start` to make service available for immediate accessibility.

### mongodb::uninstall

Removes mongodb service packages and its associated files and directories

1. Stop and disable `['mongodb']['service']['name']`
1. Remove files created during configure and fine_tunning services such as `['mongodb']['app']['key_file']`,`['mongodb']['conf']['file']`,`/etc/security/limits.d/['mongodb']['service']['owner'].conf`. `['mongodb']['sysctl']['conf']`, `/etc/yum.repos.d/mongdb-org.conf`
1. Remove directories creates during configure such as `['mongodb']['storage']['path']`
1. Removes all binaries defined under `['mysql']['binary']['packages']` hash based on running node's platform and platform_version.

### mongodb::logrotate_install

MongoDB’s standard log rotation approach archives the current log file and starts a new one. To do this, the mongod or mongos instance renames the current log file by appending a UTC timestamp to the filename, in ISODate format. It then opens a new log file, closes the old log file,compress it  and remove the older than 90 days files, and sends all new log entries to the new log file.

1. Get the mongodb logpath and lock file location.
1. Check the mongodb log file `['mongodb']['log']['file']` exists or not, if file not exists terminate the session.
1. Rotate the mongodb log by sending a SIGUSR1 signal to the mongod process
1. Compressing new logfile and remove the old mongodb logs files as defined `[mongodb']['logfile']['retension'] `

### mongodb::logrotate_uninstall 

Remove the cron job and delete  shell srcipt  from the converging node. 

1. Remove cron entry for root user from the cron seheduler 
1. Delete shell script from converging node

Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['mongodb']['pin_version']                    | Boolean       | If true, it installs only given version of package                   |
| ['mongodb']['major']['version']               | String        | Major Mongodb-org version for identifying binary packages            | 
| ['mongodb']['download']['uri']                | String        | Mongodb-org binary repository URL location                           | 
| ['mongodb']['binary']['packages']             | Hash          | Mongodb-org package suite based on platform and its major version    | 
| ['mongodb']['service']['name']                | String        | Mongodb service name updated based on distribution                   |
| ['mongodb']['service']['owner']               | String        | Mongodb service owner updated based on distribution                  |
| ['mongodb']['service']['group']               | String        | Mongodb service group updated based on distribution                  |
| ['mongodb']['service']['port']                | String        | Mongodb service port updated based on distribution                   |
| ['mongodb']['log']['file']                    | String        | Absolute log path for mongodb service                                |
| ['mongodb']['storage']['path']                | String        | Storage base directory for Mongo data volume                         |
| ['mongodb']['conf']['file']                   | String        | Main configuration file for mongodb service                          |
| ['mongodb']['app']['base_direcotry']          | String        | Base directory for mongodb application authentication                |
| ['mongodb']['app']['key_file']                | String        | Absolute path of application authentication key                      |
| ['mongodb']['binary']['path']                 | String        | Absolute path of mongodb binary path                                 |
| ['mongodb']['sysctl']['home_directory']       | String        | Base directory of Kernel sysctl additional configuration files       |
| ['mongodb']['sysctl']['conf']                 | String        | Absolute path of sysctl configurations for Mongodb                   |
| ['mongodb']['sysctl']['options']              | Hash          | Key-value pair of sysctl options for mongodb service                 |
['mongodb']['service']['lock_file']             |               | Key-value pair of lock file , which contains mongodb process id      |
['mongodb']['logfile']['retension']             |  S            | Retention period of the mongdb archive of logs files.  Based on the environment  we can adjust the retension values for example for dev/QA setup configure the retension period as 30 days , where as it comes to prod set the retension period  to 90 days.

## Environment Variables

|Attribute Name                                 | Type          | Description                                                          |
|---------------------------------------------- |---------------|----------------------------------------------------------------------|
| ['mongodb']['key_authentication']             | Boolean       | If true, it enables symmetric key based communication between nodes  |
| ['mongodb']['replication_name']               | String        | Replication set name shared by all nodes for forming cluster         | 


## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
