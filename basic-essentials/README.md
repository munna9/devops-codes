#basic-essentials-cookbook

Installs and configures  basic task(s) which doesn't qualify to be dedicated cookbook.

##Recipes and supported platforms

<table>
    <tr>
        <th>Recipe Name</th>
        <th>Platforms supported</th>
    </tr>
    <tr>
        <td>oracle_java_default</td>
        <td>Any Linux distribution</td>
    </tr>
    <tr>
        <td>oracle_java_default_uninstall</td>
        <td>Any Linux distribution</td>
    </tr>            
    <tr>
        <td>gitclient</td>
        <td>
             Amazonlinux- 2016.09 <br>
             CentOS - 7.3.1611 <br>
             CentOS - 7.2.1511 <br>
             Ubuntu - 16.04 <br>
             Ubuntu - 14.04 <br>
        </td>
    </tr>
    <tr>
        <td>gitclient_uninstall</td>
        <td>
             Amazonlinux- 2016.09 <br>
             CentOS - 7.3.1611 <br>
             CentOS - 7.2.1511 <br>
             Ubuntu - 16.04 <br>
             Ubuntu - 14.04 <br>
        </td>
    </tr>
    <tr>
        <td>epel_repo</td>
        <td>
             Amazonlinux- 2016.09 <br>
             CentOS - 7.3.1611 <br>
             CentOS - 7.2.1511 <br>
        </td>
    </tr>
    <tr>
        <td>epel_repo_uninstall</td>
        <td>
             Amazonlinux- 2016.09 <br>
             CentOS - 7.3.1611 <br>
             CentOS - 7.2.1511 <br>
        </td>
    </tr>           

</table>

## Continuous Integration Platforms
<table>
    <tr>
        <th>CI Environment- Tools</th>
        <th>Platform tested</th>        
    </tr>
    <tr>
        <td>Docker<br><br>
            kitchen-docker-phenom<br>
        </td>
        <td>
             Amazonlinux- 2016.09 <br>
             CentOS - 7.3.1611 <br>
             CentOS - 7.2.1511 <br>
             Ubuntu - 16.04 <br>
             Ubuntu - 14.04 <br>
        </td>
    </tr>
</table>

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['oracle_java']['app']['base_directory']</tt></td>
    <td><tt>String</tt></td>
    <td><tt>Java artifact directory<tt></td>
  </tr>
  <tr>
    <td><tt>['oracle_java']['app']['default_path']</tt></td>
    <td><tt>String<tt></td>
    <td><tt>Java binary default path<tt></td>
  </tr>
  <tr>
    <td><tt>['oracle_java']['default']['binary_version']</tt></td>
    <td><tt>String<tt></td>
    <td><tt>Oracle java artifact version to dowload<tt></td>
  </tr>
  <tr>
    <td><tt>['oracle_java']['default']['binary_package']</tt></td>
    <td><tt>String<tt></td>
    <td><tt>Oracle java artifact file <tt></td>
  </tr>
  <tr>
    <td><tt>['oracle_java']['default']['uri']</tt></td>
    <td><tt>String<tt></td>
    <td><tt>Oracle java artifact download URI <tt></td>
  </tr>
  <tr>
    <td><tt>['oracle_java']['default']['app_version']</tt></td>
    <td><tt>String<tt></td>
    <td><tt>Oracle java default artifact version<tt></td>
  </tr>
  <tr>
    <td><tt>['oracle_java']['default']['home_directory']</tt></td>
    <td><tt>String<tt></td>
    <td><tt>Oracle java artifact extracted directory <tt></td>
  </tr>
  <tr>
    <td><tt>['oracle_java']['default']['binary_path']</tt></td>
    <td><tt>String<tt></td>
    <td><tt>Oracle java default artifact path <tt></td>
  </tr>
   <tr>
      <td><tt>['gitclient']['pin_version']</tt></td>
      <td><tt>Boolean<tt></td>
      <td><tt>To hook package version<tt></td>
    </tr>
    <tr>
      <td><tt>['gitclient']['binary']['packages']</tt></td>
      <td><tt>Hash<tt></td>
      <td><tt>key value pair of binary package and its version<tt></td>
    </tr>    
</table>

## Purpose

### basic-essentials::oracle_java_default
Installs and configures oracle JDK - 1.8.0_111

### basic-essentials::oracle_java_default_uninstall
Removes and de-configures oracle JDK - 1.8.0_111

### basic-essentials::gitclient
Installs git client binaries by referring distribution specific hash

### basic-essentials::gitclient_uninstall
remove git client binaries by referring distribution specific hash

## License and Authors
Author:: Rajesh Jonnalagadda (rajesh.jonnalagadda@phenompeople.com)
