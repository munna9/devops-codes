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
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| Recipe Name                     | AWSLinux  | AWSLinux  |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                                 |  2017.03  |  2016.09  | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| build_properties_repo           |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| build_properties_repo_remove    |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| deploy_user_assemble            |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| deploy_user_dismantle           |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| maven_install                   |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| maven_uninstall                 |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| nodejs_install                  |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|
| nodejs_uninstall                |    √      |    √      |    √     |    √     |    √     |    √     |    
|---------------------------------|-----------|-----------|----------|----------|----------|----------|

```
Recipe details
----------------

A recipe is the most fundamental configuration element within the organization. Receipe is authored using 
Chef resources (DSL) and Ruby designed to read and behave in a predictable manner.

* Recipe is a collection of resource(a statement of configuration),
  and additional ruby code supported from libraries as and when required
* Is always executed in the same order as listed in a run-list 
* Must be stored in a cookbook under recipes directories
* Must be added to a run-list before it can be used by the chef-client

Please read attributes section for configuration paramaters for any recipe(s)

### build-essentials::buildproperties_repo

Synchronizes buildproperties repository. This recipe is dependent on basic-essentials::gitclient recipe

1. Load phenom data bag item from data bag credentials
1. Download git repo by referring `['build-essentials']['buildproperties_repo']['uri']` value for repo name and `['build-essentials']['buildproperties_repo']['branch']` and revision 
1. synchronizes code to `['build-essentials']['buildproperties_repo']['checkout_directory']`

### build-essentials::buildproperties_repo_remove

Removes buildproperties repo directory recursively from node.

1. Load phenom data bag item from data bag credentials
1. Identify phenom user's home directory and buildproperties checkout directory
1. removes directory recursively based on `['build-essentials']['buildproperties_repo']['checkout_directory']`

### build-essentials::deploy_user_assemble

Creates and configure deployment user

1. Load phenom data bag item from data bag credentials
1. Create group as defined `phenom` data bag item
1. Create user with details provided from `phenom` data bag item
1. Create id_rsa key pair provided from `phenom` data data item
1. Create/update ssh_config file for phenom deploy user
1. Ensures phenom user directory is owned and accessible only by phenom user

### build-essentials::deploy_user_assemble

Remove deploy_user files and remove user from node

1. Load phenom data bag item from data bag credentials
1. Remove user with details provided from `phenom` data bag item
1. Remove group as defined `phenom` data bag item
1. Remove directory .ssh under home_directory of `phenom` data bag item

### build-essentials::maven_install

Installs and configures Linux X64 apache-maven-3.5.0

1. Downloads Apache maven binary from official mirrors to `file_cache_path` location if not exists
1. Extracts downloaded binaries from `file_cache_path` to defined location under `node['build-essentials']['maven']['base_directory']`
1. Create/update symbolic link from `node['build-essentials']['maven']['app_directory']` to `node['build-essentials']['maven']['home_directory']`

### basic-essentials::maven_uninstall

Removes and de-configures Linux X64 apache-maven-3.5.0

1. Removes/unlinks symbolic link of `node['build-essentials']['maven']['app_directory']`
1. Removes directory recursively under `node['build-essentials']['maven']['home_directory']`
1. Removes downloaded artifact from `file_cache_path`.

### build-essentials::nodejs_install

Installs and configures Node JS, NPM and Gulp and NG

1. Downloads NodeJS repository setup script as defined in `['nodejs']['repo']['uri']` to `file_cache_path` location if not exists
1. Execute NodeJS repository setup script for setting repository based on converging node's platform
1. Installs `['nodejs']['binary']['package']` with specific binary version if `['nodejs']['pin_version']` is true, otherwise installs latest available version of package at the time converge.

### basic-essentials::maven_uninstall

Removes and de-configures Node JS, NPM and Gulp and NG

1. Removes Gulp, NG binaries from converging node
1. Removes `['nodejs']['binary']['package']` with specific binary version if `['nodejs']['pin_version']` is true, otherwise removes  available version of package at the time converge.
1. Removes NodeJS repository setup script `file_cache_path`.

Attributes
====
Ohai collects attribute data about each node at the start of the chef-client run.
When a cookbook is loaded during a chef-client run, these attributes are compared to the attributes that are already present on the node.
For each cookbook, attributes in the `default.rb` file are loaded first, and then additional attribute files(if present are loaded) in lexical sorted order.


#### attributes/default.rb

|Attribute Name                                                      | Type          | Description                                               |
|--------------------------------------------------------------------|---------------|-----------------------------------------------------------|
|['buildproperties']['buildproperties_repo']['uri']                  | String        | URI for fetching buildproperties of git repo              |
|['buildproperties']['buildproperties_repo']['checkout_directory']   | String        | Diectory name where buildproperties repo checked out      |
|['buildproperties']['buildproperties_repo']['branch']               | String        | git repo branch to checkout                               |
|['buildproperties']['maven']['version']                             | String        | Apache maven binary version                               |
|['buildproperties']['maven']['binary_package']                      | String        | Maven binary file name                                    |
|['buildproperties']['maven']['uri']                                 | String        | Maven download artifact location                          |
|['buildproperties']['maven']['base_directory']                      | String        | Base directory for hosting apache maven binaries          |
|['buildproperties']['maven']['home_directory']                      | String        | Directory of maven binaries after extraction              |
|['buildproperties']['maven']['app_directory']                       | String        | Symbolic link of latest maven installation binaries       |
#### attributes/nodejs.rb
|Attribute Name                                                      | Type          | Description                                               |
|--------------------------------------------------------------------|---------------|-----------------------------------------------------------|
|['nodejs']['repo']['uri']                                           | String        | URI for fetching nodejs repo directory                    |
|['nodejs']['binary']['packages']                                    | String        | Binary package name for node JS                           |
|['nodejs']['binary']['version']                                     | String        | Version of Node JS binary                                 |
|['nodejs']['gulp']['binary_path']                                   | String        | Gulp binary package path                                  |
|['nodejs']['ng']['binary_path']                                     | String        | Gulp binary package path                                  |


## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

Author:: Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)
