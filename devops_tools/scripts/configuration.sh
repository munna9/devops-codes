## Server Access Keys
#root_key=/home/jenkins/.jenkins/repo_data/devops_tools/server_access/$loginuser.pem
#deployment_key=/home/jenkins/.jenkins/repo_data/devops_tools/server_access/phenom.pem
#s3_bucket=s3://software-imom
##These will be part of jenkins inherit global variables
java
## Phenom user creation

if [[ ${user_creation} == true ]]
then
set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt  $loginuser@$serverip '
  user=`grep "phenom" /etc/passwd |cut -d":" -f1`
  user="${user#"${user%%[![:space:]]*}"}"
  if [ $user == "phenom" ]
  then
  echo "phenom user already exist"
  else
  echo "Creating phenom user"
  sudo useradd phenom
  sudo mkdir /home/phenom/.ssh
  sudo chown phenom:phenom /home/phenom/.ssh
  sudo chmod 700 /home/phenom/.ssh
  fi'
set +e
	echo "Phenom user created"
fi

## Phenom user key addition
if [[ ${keycopy} == true ]]
then
set -e
	scp -o "StrictHostKeyChecking no" -i $root_key /home/jenkins/.jenkins/repo_data/phenom.ppk $loginuser@$serverip:
	ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip 'sudo truncate -s 0 /home/phenom/.ssh/authorized_keys'
	ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip 'cat ~/phenom.ppk | sudo tee --append /home/phenom/.ssh/authorized_keys; sudo chmod 600 /home/phenom/.ssh/authorized_keys; sudo chown phenom:phenom /home/phenom/.ssh/authorized_keys; rm -fr ~/phenom.ppk'
set +e
	echo "Phenom userkey copied"
fi

## Deployment folder creation
if [[ ${deployment_directory_creation} == true ]]
then
set -e
	ssh -o "StrictHostKeyChecking no" -i $root_key -tt  $loginuser@$serverip '
  if [[ ! -d /opt/deployment ]]
  then
  echo "Creating deployment directory"
  sudo mkdir  -p /opt/deployment
  sudo chown -R phenom:phenom /opt/deployment
  else
  echo "deployment directory already exist"
  fi'
set +e
	echo "Phenom base directory created"
fi

## JAVA7 installation
if [[ ${java7} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/sunjdk/jdk-7u79-linux-x64.gz .
  set +e
   artifact=`echo sunjdk/jdk-7u79-linux-x64.gz |cut -d"/" -f2`
set -e  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $deployment_key $artifact phenom@$serverip:/opt/deployment/
  
  echo "Extracting artifact on Deployment server"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt phenom@$serverip "tar -xvf /opt/deployment/$artifact -C /opt/deployment/"
  
  echo "Removing tar,zip artifact from Deployment server"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt phenom@$serverip "rm -rf /opt/deployment/$artifact"
  
  echo "Configure Java on system level and setting up the JAVA_HOME path($loginuser)"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo rm -fr /etc/alternatives/java /usr/lib/jvm/java
  sudo ln -sf /opt/deployment/jdk1.7.0_79/bin/java /etc/alternatives/java
  sudo ln -sf /opt/deployment/jdk1.7.0_79 /usr/lib/jvm/java
  sudo java -version"
set +e  
fi


## JAVA8 installation
if [[ ${java8} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/sunjdk/jdk-8u45-linux-x64.gz .
  set +e
   artifact=`echo sunjdk/jdk-8u45-linux-x64.gz |cut -d"/" -f2`
set -e  
  echo "Deploy artifact to Deployment server"
  echo "==============================================" 
  scp -o "StrictHostKeyChecking no" -i $deployment_key $artifact phenom@$serverip:~; 
  
  echo "Extracting artifact on Deployment server"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt phenom@$serverip "tar -xvf /home/phenom/$artifact -C /opt/deployment/"
  
  echo "Removing tar,zip artifact from Deployment server"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt phenom@$serverip "rm -rf /opt/deployment/$artifact"

  echo "Configure Java on system level and setting up the JAVA_HOME path($loginuser)"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo rm -fr /etc/alternatives/java /usr/lib/jvm/java
  sudo ln -sf /opt/deployment/jdk1.8.0_45/bin/java /etc/alternatives/java
  sudo ln -sf /opt/deployment/jdk1.8.0_45 /usr/lib/jvm/java
  sudo java -version"
set +e  
fi

## Tomcat installation
## ports order for tomcat installation : connector , shutdown , AJP , redirect

if [ ${default_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh tomcat8 8080 8005 8099 8443; fi
if [ ${cc_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh cc-tomcat 8080 8005 8099 8443; fi
if [ ${ngcc} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh ngcc-tomcat 8080 8005 8099 8443; fi
if [ ${cc_admin} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh cc-admin-tomcat 8080 8005 8099 8443; fi
if [ ${cc_scheduling_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh cc-scheduling-tomcat 8080 8005 8099 8443; fi
if [ ${jobs2web_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh jobs2web-tomcat 8080 8005 8099 8443; fi
if [ ${online_search_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh online-search-tomcat 8090 8010 8020 8030; fi
if [ ${offline_search_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh offline-search-tomcat 8094 8014 8024 8034; fi
if [ ${decision_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh decision-tomcat 8091 8011 8021 8031; fi
if [ ${online_content_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh online-content-tomcat 8092 8012 8022 8032; fi
if [ ${offline_content_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh offline-content-tomcat 8093 8013 8023 8033; fi
if [ ${crypto_services_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh crypto-service 8080 8005 8009 8443; fi
if [ ${hotjobs_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh hotjobs 8080 8005 8099 8443; fi
if [ ${online_similar_jobs} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh online-similar-jobs 8880 8810 8820 8830; fi
if [ ${offline_recommendations_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh offline-recommendations-tomcat 8881 8811 8821 8831; fi
if [ ${online_recommendations_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh online-recommendations-tomcat 8882 8812 8822 8832; fi
if [ ${analytics_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh analytics-tomcat 8080 8005 8099 8443; fi
if [ ${analytics_datapull1} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh analytics-datapull1	8090 8015 8099 8453; fi
if [ ${analytics_datapull2} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh analytics-datapull2	8090 8015 8099 8453; fi
if [ ${candidates_search} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh candidates-search 9080 9005 9089 9443; fi
if [ ${apply_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh apply-tomcat 8080 8005 8099 8443; fi
if [ ${factor_spaces} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh factor-spaces-tomcat 8095 8015 8025 8035; fi
if [ ${essync_commons} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh essync-commons-tomcat 8096 8016 8026 8036; fi
if [ ${ngcc_rbc} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh ngcc-rbc-tomcat 8090 8010 8020 8030; fi
if [ ${offline_user_tables} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh offline-user-tables-tomcat 8097 8017 8027 8037; fi
if [ ${cc_scheduler_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh cc-scheduler-tomcat 8090 8010 8020 8030; fi
if [ ${job_scoring_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh job-scoring-tomcat 8098 8018 8028 8038; fi
if [ ${phenom_bot_tomcat} == true ]; then ${repo_data_path}/devops_tools/scripts/newtomcat_deploy.sh phenom-bot-tomcat 8099 8019 8029 8039; fi
## Nagios installation
if [[ ${Nagios_Client} == true ]]
then
  echo "Starting Nagios Client Configuration"
  echo "=============================================="
  ssh -i $root_key -tt $loginuser@$serverip "
  sudo yum install -y gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel
  sudo useradd nagios
  #sudo passwd nagios
  sudo mkdir -p /root/nagios
  cd /root/nagios
  sudo wget https://www.nagios-plugins.org/download/nagios-plugins-1.5.tar.gz
  sudo tar -zxvf nagios-plugins-1.5.tar.gz
  cd nagios-plugins-1.5
  sudo ./configure 
  sudo make
  sudo make install
  
  sudo chown nagios.nagios /usr/local/nagios
  sudo chown -R nagios.nagios /usr/local/nagios/libexec
  sudo yum install -y xinetd
  
  cd /root/nagios
  sudo wget http://pkgs.fedoraproject.org/repo/pkgs/nrpe/nrpe-2.15.tar.gz/3921ddc598312983f604541784b35a50/nrpe-2.15.tar.gz
  sudo tar -zxzf nrpe-2.15.tar.gz
  cd nrpe-2.15
  sudo ./configure
  sudo make all
  sudo make install-plugin
  sudo make install-daemon
  sudo make install-daemon-config
  sudo make install-xinetd
  
  sudo sed -i '/only_from/c \        only_from       = 127.0.0.1 localhost ec2-54-189-67-205.us-west-2.compute.amazonaws.co' /etc/xinetd.d/nrpe
  sudo sed -i '$ a\nrpe            5666/tcp                 NRPE' /etc/services
  sudo service xinetd restart
  sudo netstat -at | grep nrpe"
  echo "Completed Nagios Client Configuration"
  echo "=============================================="
fi


## Elastic search installation
if [[ ${elasticsearch} == true ]]
then
  echo "Downloading the elastic search package from S3"
set -e
  aws s3 cp s3://software-imom/elasticsearch-$ES_VERSION.tar.gz .
  
  #mv elasticsearch-$ES_VERSION.tar.gz elasticsearch.tar.gz
  scp -i $deployment_key elasticsearch-$ES_VERSION.tar.gz phenom@$serverip:/opt/deployment/
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt  phenom@$serverip '
  cd /opt/deployment/
  echo "Extracting.."
  tar xvzf elasticsearch-*.tar.gz -C /opt/deployment/
  rm -fr elasticsearch elasticsearch-*.tar.gz
  
  mv elasticsearch-* elasticsearch
  echo "Download plugins.."
  cd elasticsearch
  
  echo "Installing ..."
  echo "River Mongo"
  bin/plugin --install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.9
  
  echo "Bigdesk.."
  bin/plugin -install lukas-vlcek/bigdesk
  
  echo "Head.."
  bin/plugin -install mobz/elasticsearch-head
  
  echo "Kopf.."
  bin/plugin --install lmenezes/elasticsearch-kopf
  
  echo "Paramedic.."
  bin/plugin -install karmi/elasticsearch-paramedic
  
  echo "HQ.."
  bin/plugin -install royrusso/elasticsearch-HQ
  
  echo "installation complete."
  echo "ES Setup complete"'
set +e  
fi

if [[ ${kafka} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/kafka_2.10-0.8.2.2.tgz .
   aws s3 cp $s3_bucket/init-scripts/kafka.sh .
   aws s3 cp $s3_bucket/init-scripts/zookeeper.sh .
  set +e
   artifact=kafka_2.10-0.8.2.2.tgz
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $deployment_key $artifact phenom@$serverip:/opt/deployment/
  scp -o "StrictHostKeyChecking no" -i $root_key kafka.sh $loginuser@$serverip:
  scp -o "StrictHostKeyChecking no" -i $root_key zookeeper.sh $loginuser@$serverip:
  
  echo "Extracting artifact on Deployment server"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt phenom@$serverip "tar -xvf /opt/deployment/$artifact -C /opt/deployment/"
  
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt phenom@$serverip "mv /opt/deployment/kafka_2.10-0.8.2.2 /opt/deployment/kafka
  sed -i 's/producer.type=sync/producer.type=async/g' /opt/deployment/kafka/config/producer.properties
  sed -i 's/#batch.num.messages=/batch.num.messages=100/g' /opt/deployment/kafka/config/producer.properties
  sed -i 's/num.partitions=1/num.partitions=6/g' /opt/deployment/kafka/config/server.properties
  sed -i 's/zookeeper.connection.timeout.ms=6000/zookeeper.connection.timeout.ms=1000000/g' /opt/deployment/kafka/config/server.properties"
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv kafka.sh /etc/init.d/kafka
  sudo mv zookeeper.sh /etc/init.d/zookeeper
  sudo chmod 755 /etc/init.d/kafka /etc/init.d/zookeeper
  sudo chkconfig kafka on
  sudo chkconfig zookeeper on
  sudo chkconfig --list kafka
  sudo chkconfig --list zookeeper
  echo 'phenom ALL=NOPASSWD: /etc/init.d/kafka *' |sudo tee -a /etc/sudoers
  echo 'phenom ALL=NOPASSWD: /etc/init.d/zookeeper *' |sudo tee -a /etc/sudoers"
  set +e
  
  echo "Removing tar,zip artifact from Deployment server"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $deployment_key -tt phenom@$serverip "rm -rf /opt/deployment/$artifact"
fi

if [[ ${candidates_kpagevisits} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates-kapp.sh .
  set +e
   artifact=candidates-kpagevisits
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates-kapp.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates-kapp.sh /etc/init.d/candidates-kpagevisits
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/candidates-kpagevisits
  sudo chkconfig candidates-kpagevisits on
  sudo chkconfig --list candidates-kpagevisits
  echo 'phenom ALL=NOPASSWD: /etc/init.d/candidates-kpagevisits *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${candidates_facets} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates.sh .
  set +e
   artifact=candidates-facets
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates.sh /etc/init.d/candidates-facets
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/candidates-facets
  sudo chkconfig candidates-facets on
  sudo chkconfig --list candidates-facets
  echo 'phenom ALL=NOPASSWD: /etc/init.d/candidates-facets *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${candidates_microservice} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates.sh .
  set +e
   artifact=candidates-microservice
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates.sh /etc/init.d/candidates-microservice
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/candidates-microservice
  sudo chkconfig candidates-microservice on
  sudo chkconfig --list candidates-microservice
  echo 'phenom ALL=NOPASSWD: /etc/init.d/candidates-microservice *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${candidates_usermanagement} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates.sh .
  set +e
   artifact=candidates_usermanagement
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates.sh /etc/init.d/candidates_usermanagement
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/candidates_usermanagement
  sudo chkconfig candidates_usermanagement on
  sudo chkconfig --list candidates_usermanagement
  echo 'phenom ALL=NOPASSWD: /etc/init.d/candidates_usermanagement *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${candidates_ksubscribers} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates-kapp.sh .
  set +e
   artifact=candidates-ksubscribers
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates-kapp.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates-kapp.sh /etc/init.d/candidates-ksubscribers
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/candidates-ksubscribers
  sudo chkconfig candidates-ksubscribers on
  sudo chkconfig --list candidates-ksubscribers
  echo 'phenom ALL=NOPASSWD: /etc/init.d/candidates-ksubscribers *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${sendgridwebhook} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates-kapp.sh .
  set +e
   artifact=sendgridwebhook
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates-kapp.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates-kapp.sh /etc/init.d/sendgridwebhook
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/sendgridwebhook
  sudo chkconfig sendgridwebhook on
  sudo chkconfig --list sendgridwebhook
  echo 'phenom ALL=NOPASSWD: /etc/init.d/sendgridwebhook *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${candidates_kjobvisits} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates-kapp.sh .
  set +e
   artifact=candidates-kjobvisits
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates-kapp.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates-kapp.sh /etc/init.d/candidates-kjobvisits
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/candidates-kjobvisits
  sudo chkconfig candidates-kjobvisits on
  sudo chkconfig --list candidates-kjobvisits
  echo 'phenom ALL=NOPASSWD: /etc/init.d/candidates-kjobvisits *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${candidates} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/candidates.sh .
  set +e
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key candidates.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv candidates.sh /etc/init.d/candidates
  sudo chmod 755 /etc/init.d/candidates
  sudo chkconfig candidates on
  sudo chkconfig --list candidates
  echo 'phenom ALL=NOPASSWD: /etc/init.d/candidates *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${logs2db} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/logs2db.sh .
  set +e
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key logs2db.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv logs2db.sh /etc/init.d/logs2db
  sudo chmod 755 /etc/init.d/logs2db
  sudo chkconfig logs2db on
  sudo chkconfig --list logs2db
  echo 'phenom ALL=NOPASSWD: /etc/init.d/logs2db *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${phenomtrackapi} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/phenomtrackapi.sh .
  set +e
   artifact=phenomtrackapi
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key phenomtrackapi.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv phenomtrackapi.sh /etc/init.d/phenomtrackapi
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/phenomtrackapi
  sudo chkconfig phenomtrackapi on
  sudo chkconfig --list phenomtrackapi
  echo 'phenom ALL=NOPASSWD: /etc/init.d/phenomtrackapi *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${events} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/phenomtrackapi.sh .
  set +e
   artifact=events
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key phenomtrackapi.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv phenomtrackapi.sh /etc/init.d/events
  sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
  sudo chmod 755 /etc/init.d/events
  sudo chkconfig events on
  sudo chkconfig --list events
  echo 'phenom ALL=NOPASSWD: /etc/init.d/events *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${apply_jar} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/apply-jar.sh .
  set +e
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key apply-jar.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv apply-jar.sh /etc/init.d/apply-jar
  sudo chmod 755 /etc/init.d/apply-jar
  sudo chkconfig apply-jar on
  sudo chkconfig --list apply-jar
  echo 'phenom ALL=NOPASSWD: /etc/init.d/apply-jar *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${jobpull} == true ]]
then
  echo "Downloading artifact from AWS S3 Bucket"
  echo "=============================================="
  set -e
   aws s3 cp $s3_bucket/init-scripts/jobpull.sh .
  set +e
  
  echo "Deploy artifact to Deployment server"
  echo "=============================================="
  scp -o "StrictHostKeyChecking no" -i $root_key jobpull.sh $loginuser@$serverip:
  
  set -e
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo mv jobpull.sh /etc/init.d/jobpull
  sudo chmod 755 /etc/init.d/jobpull
  sudo chkconfig jobpull on
  sudo chkconfig --list jobpull
  echo 'phenom ALL=NOPASSWD: /etc/init.d/jobpull *' |sudo tee -a /etc/sudoers"
  set +e
  echo "=============================================="
  echo "Init File copied successfully"
fi

if [[ ${hostname_change} == true ]]
then
  echo "Setting up server hostname"
  echo "=============================================="
  ssh -o "StrictHostKeyChecking no" -i $root_key -tt $loginuser@$serverip "
  sudo sed -i 's/localhost.localdomain/'$HNAME'/g' /etc/sysconfig/network
  echo '127.0.0.1   $HNAME' |sudo tee -a /etc/hosts
  sudo reboot"
  
  echo "Hostname Setup Completed"
  echo "=============================================="
fi

if [[ ${collectd} == true ]]
then
  echo "installing collectd"
  echo "=============================="
  cp /home/jenkins/collectd.conf  /home/jenkins/collectd.conf.copy

  sed -i '12 i Hostname    "'$hostname'"  ' /home/jenkins/collectd.conf.copy


  scp -o "StrictHostKeyChecking no"  -i /home/jenkins/.jenkins/repo_data/devops_tools/server_access/venkatb.pem  /home/jenkins/collectd.conf.copy  $loginuser@$serverip:/home/$user;

  ssh -o "StrictHostKeyChecking no"  -i /home/jenkins/.jenkins/repo_data/devops_tools/server_access/venkatb.pem  $loginuser@$serverip 'sudo yum install collectd -y;

  sudo cp /etc/collectd.conf   /etc/collectd.conf_bkp;

  sudo chmod 666 /etc/collectd.conf;

  sudo cat /home/$user/collectd.conf.copy  > /etc/collectd.conf; 

  sudo service collectd start;

  sudo chkconfig collectd on;'

  rm /home/jenkins/collectd.conf.copy -rf;



  cp /home/jenkins/graphitemetrics.properties  /home/jenkins/graphitemetrics.properties.copy

  sed -i '5 i Hostname    "'$hostname'"  ' /home/jenkins/graphitemetrics.properties.copy

  scp -o "StrictHostKeyChecking no" -i keylocation /home/jenkins/graphitemetrics.properties.copy  $loginuser@$serverip:/home/$user

  ssh -i key $loginuser@$serverip 'sudo cp ~/graphitemetrics.properties.copy   /opt/deployment/cc-tomcat/conf/graphitemetrics.properties 
  
  sudo chmod 600 /opt/deployment/cc-tomcat/conf/graphitemetrics.properties 
  
  sudo chown  phenom:phenom /opt/deployment/cc-tomcat/conf/graphitemetrics.properties'

  rm -rf /home/jenkins/graphitemetrics.properties.copy
  
  echo "installing collectd successfully"
  echo "====================================="
fi
 
