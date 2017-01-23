basic-essentials-cookbook
=========================
Installs and configures  basic task(s) which doesn't qualify to be dedicated cookbook.

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
| chefdk                        |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| chefdk_uninstall              |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| epel                          |    X      |    X     |    X     |    -     |    -     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| epel_uninstall                |    X      |    X     |    X     |    -     |    -     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| oracle_java_default           |    X      |    X     |    X     |    X     |    X     |    
|-------------------------------|-----------|----------|----------|----------|----------|
| oracle_java_default_uninstall |    X      |    X     |    X     |    X     |    X     |    
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

### basic-essentials::chefdk

Installs Chef development kit by referring distribution specific String variable `['chefdk']['download']['uri']`

1. Identifies running node's platform and its version.
1. If match found, load variable `['chefdk']['download']['uri']` and downloads rpm/deb to `file_cache_path`.
1. As soon the rpm/deb is downloaded, it notifies package resource for its installation.

### basic-essentials::chefdk_uninstall

Remove Chef development kit by referring distribution specific String variable `['chefdk']['download']['uri']`

1. Identifies running node's platform and its version.
1. Removes binaries by referring `node['chefdk']['binary']['package']`
1. Removes rpm/deb is downloaded under `file_cache_path.`

## basic-essentials::oracle_java_default

Installs and configures Linux X64 oracle JDK - 1.8.0_111.

1. Downloads Oracle Java binaries from official download page by accepting license agreement to `file_cache_path` location if not exists.
1. Extracts downloaded binaries from `file_cache_path` to defined location under `node['oracle_java']['app']['base_directory']`.
1. Create/update symbolic link from `node['oracle_java']['default']['binary_path']` to `/etc/alternatives/java`
1. Create/update symbolic link from `/etc/alternaives/java` to `/usr/bin/java`

### basic-essentials::oracle_java_default_uninstall

Removes and de-configures Linux X64 oracle JDK - 1.8.0_111.

1. Removes/unlinks symbolic link of `/etc/alternatives/java` and `/usr/bin/java`.
1. Removes directory recursively under `node['oracle_java']['default']['home_directory']` and `node['oracle_java']['app']['base_directory']`
1. Removes downloaded artifact from `file_cache_path`.

### basic-essentials::epel_repo

Installs epel_repo binaries by referring distribution specific String variable `node['epel']['repo']['uri']`

1. Identifies running node's platform and its version. for example, CentOS-7.3's platform centos and its version 7.3.1611.
1. If match found, load variable `node['epel']['repo']['uri']` and downloads rpm to `file_cache_path`.
1. As soon the rpm is downloaded, it notifies package resource for its installation

### basic-essentials::epel_repo_uninstall

Remove epel_repo binaries by referring distribution specific String variable `node['epel']['repo']['uri']`

1. Identifies running node's platform_family.
1. Removes epel.repo, epel-testing.repo files under `/etc/yum.repos.d/`
1. Removes rpm downloaded under `file_cache_path.`

### basic-essentials::gitclient

Installs git client binaries by referring distribution specific ruby hash `node['gitclient']['binary']['packages']`

1. Identifies running node's platform and its version. for example, CentOS-7.3's platform centos and its version 7.3.1611.
1. Compiles `node['gitclient']['binary']['packages']` with above values
1. Installs each of those hash key value pair(s) with specific binary version if `node['gitclient]['pin_version']` is true,
   download latest available at the time converge.

### basic-essentials::gitclient_uninstall

Remove git client binaries by referring distribution specific hash `node['gitclient']['binary']['packages']`

1. Identifies running node's platform and its version. for example, CentOS-7.3's platform centos and its version 7.3.1611.
1. Compiles `node['gitclient']['binary']['packages']` with above values
1. Removes each of those hash key value pair(s)


Attributes
====
Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.

#### attributes/chefdk.rb

|Attribute Name                                 | Type          | Description                                               |
|---------------------------------------------- |---------------|------------------------------------------------------------
| ['chefdk']['binary']['version']               | String        | Default Chef DK artifaction version                       |
| ['chefdk']['binary']['package']               | Hash          | Binary package and version for listed platform family     |
| ['chefdk']['package']['name']                 | Hash          | Binary artifact name                                      |
| ['chefdk']['download']['uri']                 | Hash          | Binary artifact download URL                           |

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                               |
|---------------------------------------------- |---------------|------------------------------------------------------------
| ['gitclient']['pin_version']                  | Boolean       | If true, it installs only given version of package        |
| ['gitclient']['binary']['packages']           | Hash          | Binary package and version for listed distribution        |
| ['epel']['repo']['uri']                       | String        | EPEL repo configuration rpm URL                           |

#### attributes/oracle_java.rb

|Attribute Name                                 | Type          | Description                                               |
|---------------------------------------------- |---------------|------------------------------------------------------------
| ['oracle_java']['app']['base_directory']      | String        | Base directory for various Java extracted artifacts       |
| ['oracle_java']['app']['default_path']        | String        | Default Java binary location inside machine               |
| ['oracle_java']['default']['binary_version']  | String        | Default Java artifaction version                          |
| ['oracle_java']['default']['binary_package']  | String        | Java binaries file name                                   |
| ['oracle_java']['default']['uri']             | String        | Java download artifact location                           |
| ['oracle_java']['default']['app_version']     | String        | Default Java application version                          |
| ['oracle_java']['default']['home_directory']  | String        | Extracted Java home directory                             |
| ['oracle_java']['default']['binary_path']     | String        | Oracle Java default binary path                           |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
