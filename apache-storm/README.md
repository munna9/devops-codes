apache-storm cookbook
===============

Installs and configures apache-storm application stack. Apache storm is a free and open source distributed realtime computation system. Storm makes it easy to reliably process unbounded streams of data, doing for realtime processing what Hadoop did for batch processing. Storm is simple, can be used with any programming language, and is a lot of fun to use!
This cookbook can be used both as a standalone role or can be multiplexed with another cookbook.


Recipes and supported platforms
-------------------------------
The following platforms have been tested with Test Kitchen. You may be
able to get it working on other platform, with appropriate configuration updates
```
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| Recipe Name                   | AWSLinux  | AWSLinux |  CentOS  |  CentOS  |  Ubuntu  | Ubuntu   |
|                               |  2017.03  |  2016.09 | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   |
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| configure                     |     √     |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| service                       |     √     |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|
| uninstall                     |     √     |    √     |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|----------|

```
Recipe details
==============

A recipe is the most fundamental configuration element within the organization. Recipe is authored using
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required.
* Is always executed in the same order as listed in a run-list.
* Must be stored in a cookbook under recipes directories.
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration parameters for any recipe(s)

### apache-storm::configure

Configures Apache storm cluster configuration file which can be shared by storm cluster components such as nimbus(storm-master), storm-ui, storm-supervisor and storm-deployer

1. Create directory  `['storm']['conf']['home_directory']` for holding configuration files for apache storm cluster components
1. Create/update `['storm']['conf']['env_file']` file, to override environment variables set in the shell
1. Identify nimbus aka  storm-master hosts from environment who share same environment and successfully converged with apache-storm::storm_nimbus_install recipe
1. Set `nimbus_seeds` node variable with the results from above search

### apache-storm::storm_kafka_repo_remove

Removes storm-kafka repo directory recursively from node.

1. Load phenom data bag item from data bag credentials
1. Identify phenom user's home directory and buildproperties checkout directory
1. removes directory recursively based on `['storm']['kafka-repo']['checkout_directory']`

### apache-storm::storm_kafka_repo

Synchronizes storm-kafka repository. This recipe is dependent on basic-essentials::gitclient recipe. This recipe will be in use by supervisor and nimbus nodes

1. Load phenom data bag item from data bag credentials
1. Download git repo by referring `['storm']['kafka_repo']['uri']` value for repo name and `['storm']['kafka-repo']['branch']` and revision 
1. Synchronizes code to `['storm']['kafka-repo']['checkout_directory']`

### apache-storm::storm_master_uninstall

Uninstall and de-configure Storm master components such as nimbus and UI

1. Load data bag referred by vault_name and app_name for storm-nimbus and storm-ui components
1. Obtain local container name by referring vault_name and app_name for storm-nimbus and storm-ui component
1. Stops storm-ui and storm-nimbus containers if running
1. Removes `['storm']['conf']['file']` if exists
1. Removes docker images fetched for storm-ui and storm-nimbus components

### apache-storm::storm_master

Install and configure Storm master suite. Storm master suite will be referred by topology deployment contianer(s). Storm master includes storm-nimbus and storm-ui hosted on same machine for ease of administration.

1. Loads data bag referred by vault_name and app_name for storm-nimbus component.
1. Pulls **phenompeople/storm-nimbus** docker image from docker hub registry to the running node.
1. It runs container with specifications mentioned under data bag item **storm-nimbus** of **communities** data bag.
1. Loads data bag referred by vault_name and app_name for storm-ui component.
1. Pulls **phenompeople/storm-ui** docker image from docker hub registry to the running node.
1. It runs container with specifications mentioned under data bag item **storm-ui** of **communities** data bag.
1. Create docker_container resources for storm-nimbus and storm-ui with the names defined in their respective specifaction files. These resource name declarations are essentials for notifying container reloads/restarts with respective to specification chaanges
1. Create/Update `['storm']['conf']['file']` and notifies delayed start to nimbus and storm-ui containers 

### apache-storm::storm_supervisor_uninstall

Uninstall and de-configure Storm supervisor component

1. Load data bag referred by vault_name and app_name for storm-supervisor component
1. Obtain local container name by referring vault_name and app_name for storm-supervisor
1. Stops storm-supervisor container if running
1. Removes `['storm']['conf']['file']` if exists
1. Removes docker images fetched for storm-supervisor container

### apache-storm::storm_supervisor

Install and configure Storm supervisor suite. Storm supervisors are the nodes that follow instructions give by nimbus. Each supervisor has multiple worker processes and it governs worker processes to complete the tasks assigned by the nimbus. Worker process will execute tasks related to a specific topology.

1. Loads data bag referred by vault_name and app_name for storm-supervisor component.
1. Pulls **phenompeople/storm-supervisor** docker image from docker hub registry to the running node.
1. It runs container with specifications mentioned under data bag item **storm-supervisor** of **communities** data bag.
1. Create docker_container resource for storm-supervisor with the names defined in their respective specifaction file section. These resource name declarations are essentials for notifying container reloads/restarts with respective to specification chaanges
1. Create/Update `['storm']['conf']['file']` and notifies delayed start to nimbus and storm-ui containers 


Attributes
==========

Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/default.rb

|Attribute Name                                               | Type            | Description                                                          |
|-------------------------------------------------------------|-----------------|----------------------------------------------------------------------|
| ['storm']['app']['base_directory']                          | String          | Base directory for apache-storm configurations as per FHS3.0         |
| ['storm']['app']['home_directory']                          | String          | Home directory for apache-storm binaries and other essential files   |
| ['storm']['log']['home_directory']                          | String          | Home directory for apache-storm log files                            |
| ['storm']['conf']['home_directory']                         | String          | Home directory for apache-storm configuration files                  |
| ['storm']['worker']['memory_ceiling']                       | Float           | Memory cap defined for Storm workers for supervisor                  |
| ['storm']['worker']['processes']                            | Integer         | Number of worker processes defined for Strom supervisor              |    
| ['storm']['worker']['heap.memory.mb']                       | Derived Integer | Calculated based on memory availble/celing X number of processes     |
| ['storm']['worker']['max.heap.size.mb']                     | Derived Integer | Calculated based on memory availble/celing X number of processes     |
| ['storm']['topology']['sleep.spout.wait.stratergy.time.ms'] | Integer         | Milliseconds to wait for kafka spout for downstream                  | 
| ['storm']['nimbus']['ui_port']                              | Integer         | UI Port defined for Storm UI applicaiton                             |
| ['storm']['conf']['options']                                | Hash            | Configuraiton hash for storm.yml                                     |
| ['storm']['conf']['file']                                   | String          | Main configuration file for storm configurations                     |
| ['storm']['conf']['env_file']                               | String          | Storm configuration variables to be overriden by console variables   |
| ['storm']['container']['read_timeout']                      | Integer         | Time to wait for Docker container read I/O                           |
| ['storm']['container']['write_timeout']                     | Integer         | Time to wait for Docker container write I/O                          |
| ['storm']['container']['kill_after']                        | Integer         | Time to wait for Docker container to force kill                      |
| ['storm']['kafka-repo']['uri']                              | String          | URI for fetching storm-kafka of git repo                             |
| ['storm']['kafka-repo']['checkout_directory']               | String          | Directory name where storm-kafka repo to be cloned to                |
| ['storm']['kafka-repo']['branch']                           | String          | Git repo branch to checkout                                          |


## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
