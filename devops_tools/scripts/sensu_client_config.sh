key=${repo_data_path}/devops_tools/server_access/${loginuser}.pem
sensu_location=${repo_data_path}/devops_tools/sensu
	
echo "Installing the Sensu Client on target machine"
scp -i $key -o StrictHostKeyChecking=no ${sensu_location}/setup/sensu.repo $loginuser@$client_node_ip:
ssh -i $key -o StrictHostKeyChecking=no -tt $loginuser@$client_node_ip "sudo cp sensu.repo /etc/yum.repos.d/sensu.repo; sudo yum install sensu -y; sudo chkconfig sensu-client on; sudo chkconfig sensu-client --list"
ssh -i $key -o StrictHostKeyChecking=no -tt $loginuser@$client_node_ip "sudo yum install -y ruby ruby-dev build-essential; sudo gem install sensu-plugin"
echo "Client Installation complete"
cp ${sensu_location}/client/config.json .
sed -i "s/clientname/$client_node_name/g" config.json
sed -i "s/clientip/$client_node_ip/g" config.json
sed -i "s/sublist/$client_type/g" config.json
#scp -i pem config.json $loginuser@$client_node_ip:/etc/sensu/config.json
#plugin_stack="check-disk.rb check-httpd.rb check-load.rb check-memory.sh check-process.sh"
#for file in $plugin_stack
#do 
#	echo $file
#    zip sensu.zip file
#done
echo "Packaging the client configuration files"
cp -r ${sensu_location}/server/plugins .
zip -r sensu.zip *
scp -i $key -o StrictHostKeyChecking=no sensu.zip $loginuser@$client_node_ip:
ssh -i $key -o StrictHostKeyChecking=no -tt $loginuser@$client_node_ip "sudo rm -fr /etc/sensu/*"
ssh -i $key -o StrictHostKeyChecking=no -tt $loginuser@$client_node_ip "sudo cp sensu.zip /etc/sensu/; sudo unzip sensu.zip -d /etc/sensu/; sudo rm -rf sensu.zip"
ssh -i $key -o StrictHostKeyChecking=no -tt $loginuser@$client_node_ip "sudo service sensu-client restart"

echo "Sensu Client started on target machine"