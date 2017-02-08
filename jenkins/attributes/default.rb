default['jenkins']['pin_version']=false
default['jenkins']['server']['name']='jenkins.phenom.com'

case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['jenkins']['install']['uri']='http://pkg.jenkins.io/redhat'
    default['jenkins']['install']['key']='https://jenkins-ci.org/redhat/jenkins-ci.org.key'
  when 'ubuntu'
    default['jenkins']['install']['uri']='http://pkg.jenkins.io/debian-stable'
    default['jenkins']['install']['key']='https://pkg.jenkins.io/debian/jenkins-ci.org.key'
end

default['jenkins']['binary']['packages']={
    'amazon' => {
      'jenkins' => '2.42-1.1'
    },
    'centos' => {
        'jenkins' => '2.42-1.1'
    },
    'ubuntu' => {
        'jenkins' => '2.32.1'
    }
}

default['jenkins']['service']['name']='jenkins'
default['jenkins']['service']['owner']='jenkins'
default['jenkins']['service']['group']='jenkins'

default['jenkins']['app']['home_directory']='/var/lib/jenkins'
default['jenkins']['app']['plugin_directory']="#{node['jenkins']['app']['home_directory']}/plugins"
default['jenkins']['plugin']['uri']='https://updates.jenkins-ci.org/download/plugins'
default['jenkins']['plugin']['packages'] = {
    'ansicolor' => '0.4.3',
    'authentication-tokens' => '1.1',
    'bitbucket-oauth' => '0.5',
    'build-pipeline-plugin' => '1.5.6',
    'cloudbees-folder' => '5.2.2',
    'conditional-buildstep' => '1.3.5',
    'credentials' => '2.1.10',
    'dashboard-view' => '2.2',
    'display-url-api' => '0.5',
    'docker-build-step' => '1.37',
    'docker-commons' => '1.4.0',
    'docker-plugin' => '0.16.2',
    'durable-task' => '1.3',
    'git-client' => '2.2.0',
    'git' => '3.0.2',
    'greenballs' => '1.15',
    'hipchat' => '2.0.0',
    'icon-shim' => '2.0.3',
    'javadoc' => '1.4',
    'jquery' => '1.11.2-0',
    'junit' => '1.19',
    'mailer' => '1.18',
    'matrix-auth'=> '1.4',
    'matrix-project' => '1.7.1',
    'maven-plugin' => '2.14',
    'mapdb-api' => '1.0.1.0',
    'parameterized-trigger' => '2.32',
    'plain-credentials' => '1.3',
    'promoted-builds' => '2.28',
    'run-condition' => '1.0',
    'role-strategy' => '2.3.2',
    'script-security' => '1.25',
    'scm-api' => '2.0.1',
    'scm-sync-configuration' => '0.0.10',
    'subversion' => '2.7.1',
    'ssh-credentials' => '1.12',
    'ssh-slaves' => '1.6',
    'structs' => '1.5',
    'token-macro' => '2.0',
    'workflow-scm-step' => '2.3',
    'workflow-step-api' => '2.6',

}
default['jenkins']['plugin']['latest_permalink']='https://updates.jenkins-ci.org/latest/'
default['jenkins']['plugin']['fetch_latest']=false

default['jenkins']['conf']['uri']='git@bitbucket.org:maheimom/jenkins-aws.git'