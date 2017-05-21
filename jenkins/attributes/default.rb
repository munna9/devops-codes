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

default['jenkins']['service']['port']=8080

default['jenkins']['app']['home_directory']='/var/lib/jenkins'

default['jenkins']['plugin']['home_directory']="#{node['jenkins']['app']['home_directory']}/plugins"
default['jenkins']['plugin']['uri']='https://updates.jenkins-ci.org/download/plugins'
default['jenkins']['plugin']['permalink']='https://updates.jenkins-ci.org/latest/'
default['jenkins']['plugin']['fetch_latest']=false

default['jenkins']['plugin']['packages'] = {
    'ansicolor' => '0.4.3',
    'ace-editor' => '1.0.1',
    'authentication-tokens' => '1.1',
    'bitbucket-oauth' => '0.5',
    'build-name-setter' => '1.6.5',
    'build-pipeline-plugin' => '1.5.6',
    'built-on-column' => '1.1',
    'branch-api' => '1.11',
    'cloudbees-folder' => '5.12',
    'conditional-buildstep' => '1.3.5',
    'copyartifact' => '1.31',
    'credentials' => '2.1.10',
    'credentials-binding' => '1.10',
    'dashboard-view' => '2.2',
    'display-url-api' => '0.5',
    'docker-build-step' => '1.37',
    'docker-commons' => '1.6',
    'docker-plugin' => '0.16.2',
    'docker-workflow' => '1.9',
    'durable-task' => '1.12',
    'dynamicparameter' => '0.2.0',
    'envinject' => '1.90',
    'git-client' => '2.2.0',
    'git' => '3.0.2',
    'git-parameter' => '0.8.0',
    'git-server' => '1.7',
    'greenballs' => '1.15',
    'hipchat' => '2.0.0',
    'handlebars' => '1.1',
    'icon-shim' => '2.0.3',
    'javadoc' => '1.4',
    'jquery' => '1.11.2-0',
    'jquery-detached' => '1.2.1',
    'jenkins-multijob-plugin' => '1.24',
    'junit' => '1.19',
    'mailer' => '1.18',
    'matrix-auth'=> '1.4',
    'matrix-project' => '1.7.1',
    'maven-plugin' => '2.14',
    'mapdb-api' => '1.0.1.0',
    'momentjs' => '1.1',
    'parameterized-trigger' => '2.32',
    'pipeline-input-step'  => '2.7',
    'pipeline-rest-api' => '2.4',
    'pipeline-graph-analysis' => '1.1',
    'pipeline-model-api' => '1.0',
    'pipeline-model-declarative-agent' => '1.0',
    'pipeline-stage-tags-metadata' => '1.0',
    'plain-credentials' => '1.3',
    'promoted-builds' => '2.28',
    'rebuild' => '1.25',
    'run-condition' => '1.0',
    'role-strategy' => '2.3.2',
    'script-security' => '1.26',
    'scriptler' => '2.9',
    'scm-api' => '2.0.7',
    'scm-sync-configuration' => '0.0.10',
    'subversion' => '2.7.1',
    'ssh-credentials' => '1.12',
    'ssh-slaves' => '1.6',
    'structs' => '1.6',
    'token-macro' => '2.0',
    'uno-choice' => '1.5.1',
    'workflow-aggregator' => '2.5',
    'workflow-job' => '2.9',
    'workflow-durable-task-step' => '2.8',
    'workflow-api' => '2.11',
    'workflow-cps' => '2.30',
    'workflow-support' => '2.14',
    'workflow-cps-global-lib' => '2.5',
    'workflow-multibranch' => '2.9.2',
    'pipeline-stage-view' => '2.4',
    'pipeline-model-definition' => '1.0',
    'pipeline-stage-step' => '2.2',
    'pipeline-build-step' => '2.4',
    'pipeline-milestone-step' => '1.3',
    'workflow-scm-step' => '2.4',
    'workflow-step-api' => '2.9',
    'workflow-basic-steps' => '2.3',
}

default['jenkins']['conf']['uri']='git@bitbucket.org:maheimom/jenkins-aws.git'