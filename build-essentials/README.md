build-essentials-cookbook
=========================
Installs and configures  build and release task(s) which doesn't qualify to be dedicated cookbook.

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
|---------------------------------|-----------|----------|----------|----------|----------|
| Recipe Name                     | AWSLinux  |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                                 |  2016.09  | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|---------------------------------|-----------|----------|----------|----------|----------|
| build_properties                |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|---------- |----------|----------|----------|----------|
| deploy_user                     |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|----------|----------|----------|----------|

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

### build-essentials::buildproperties_repo.rb

Synchronizes buildproperties repository. This recipe is dependent on basic-essentials::gitclient recipe

1. Load phenom data bag item from data bag credentials.
1. Download git repo by referring `['build-essentials']['buildproperties_repo']['uri']` value for repo name and `['build-essentials']['buildproperties_repo']['branch']` and revision 
1. synchronizes code to `['build-essentials']['buildproperties_repo']['checkout_directory']`

### build-essentials::buildproperties_repo_remove.rb

Removes buildproperties repo directory recursively from node.

1. Load phenom data bag item from data bag credentials.
1. Identify phenom user's home directory and buildproperties checkout directory
1. removes directory recursively based on `['build-essentials']['buildproperties_repo']['checkout_directory']`

### build-essentials::deploy_user_assemble

Creates and configure deployment user

1. Load phenom data bag item from data bag credentials.
1. Create group as defined `phenom` data bag item.
1. Create user with details provided from `phenom` data bag item.
1. Create id_rsa key pair provided from `phenom` data data item.
1. Create/update ssh_config file for phenom deploy user.
1. Ensures phenom user directory is owned and accessible only by phenom user


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
| ['chefdk']['download']['uri']                 | Hash          | Binary artifact download URL                              |

#### attributes/default.rb

|Attribute Name                                 | Type          | Description                                               |
|---------------------------------------------- |---------------|------------------------------------------------------------
| ['gitclient']['pin_version']                  | Boolean       | If true, it installs only given version of package        |
| ['gitclient']['binary']['packages']           | Hash          | Binary package and version for listed distribution        |
| ['epel']['repo']['uri']                       | String        | EPEL repo configuration rpm URL                           |
| ['pip']['repo']['uri']                        | String        | get-pip.py downloaded URL                                 |

#### attributes/elastic.rb

|Attribute Name                                 | Type          | Description                                               |
|---------------------------------------------- |---------------|------------------------------------------------------------
| ['elastic']['repo']['packages']               | Hash          | packages which enable https based apt repositories        |
| ['elastic']['repo']['name']                   | String        | Name of the repository configuration files                |
| ['elastic']['repo']['base_uri']               | String        | Base URL for package repo identified based on platform    |
| ['elastic']['repo']['gpg_key']                | String        | GPG Key URL for repo identified based on platform         |

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
| ['oracle_java']['services']['binary_version'] | String        | Default Java artifaction version                          |
| ['oracle_java']['services']['binary_package'] | String        | Java binaries file name                                   |
| ['oracle_java']['services']['uri']            | String        | Java download artifact location                           |
| ['oracle_java']['services']['app_version']    | String        | Default Java application version                          |
| ['oracle_java']['services']['home_directory'] | String        | Extracted Java home directory                             |
| ['oracle_java']['services']['binary_path']    | String        | Oracle Java default binary path                           |

## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)
* Kiran Kota (<kiran.kota@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
