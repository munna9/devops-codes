#!/bin/sh

#Fetching the parameters
artifact=$1
http_port=$2
shut_port=$3
ajp_port=$4
proxy_port=$5

echo "Downloading artifact from AWS S3 Bucket"
echo "=============================================="
set -e
aws s3 cp $s3_bucket/tomcat.tar.gz .
aws s3 cp $s3_bucket/tomcat.sh .
set +e

echo "Deploy artifact to Deployment server"
echo "=============================================="
scp -o "StrictHostKeyChecking no" -i $key tomcat.tar.gz phenom@$serverip:/opt/deployment/
scp -o "StrictHostKeyChecking no" -i $key tomcat.sh $loginuser@$serverip:

echo "Remove old artifact copy from Deployment server"
echo "=============================================="
ssh -o "StrictHostKeyChecking no" -i $key -tt phenom@$serverip "rm -rf /opt/deployment/$artifact"

echo "Extracting artifact on Deployment server"
echo "=============================================="
ssh -o "StrictHostKeyChecking no" -i $key -tt phenom@$serverip "tar -xvf /opt/deployment/tomcat.tar.gz -C /opt/deployment/ ; mv /opt/deployment/tomcat /opt/deployment/$artifact"

ssh -o "StrictHostKeyChecking no" -i $key -tt phenom@$serverip "
sed -i 's/http_port/'$http_port'/g' /opt/deployment/$artifact/conf/server.xml
sed -i 's/shut_port/'$shut_port'/g' /opt/deployment/$artifact/conf/server.xml
sed -i 's/ajp_port/'$ajp_port'/g' /opt/deployment/$artifact/conf/server.xml
sed -i 's/proxy_port/'$proxy_port'/g' /opt/deployment/$artifact/conf/server.xml
echo JAVA_HOME=/opt/deployment/jdk1.8.0_45 > /opt/deployment/$artifact/bin/setenv.sh ;
echo 'export PATH=\$PATH:\$JAVA_HOME/bin' >> /opt/deployment/$artifact/bin/setenv.sh ;
chmod 755 /opt/deployment/$artifact/bin/setenv.sh"
echo "JAVA_HOME path updated in tomcat"

echo "Removing tar,zip artifact from Deployment server"
echo "=============================================="
ssh -o "StrictHostKeyChecking no" -i $key -tt phenom@$serverip "rm -rf /opt/deployment/tomcat.tar.gz"

echo "Removing tar,zip artifact from Deployment server"
echo "=============================================="
ssh -o "StrictHostKeyChecking no" -i $key -tt $loginuser@$serverip "
sudo cp tomcat.sh /etc/init.d/$artifact
sudo cp tomcat.sh /etc/init.d/$artifact
sudo chmod 755 /etc/init.d/$artifact
sudo sed -i 's/artifact/'$artifact'/g' /etc/init.d/$artifact
sudo chkconfig $artifact on
sudo chkconfig --list $artifact"