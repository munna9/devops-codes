function download_artifacts()
{
	set -e
	echo "********* Downloading artifacts ******"
	mkdir -p ${build_artifact_no}
	aws s3 cp ${s3_bucket_name}/${application}/${ClientName}/${build_artifact_no} ${build_artifact_no} --recursive
	set +e
}

function localise_propertyfiles()
{
	echo "********* Updating property file $c inside the artifact"
	if [ -f ${devops_prop_file} ]
	then 
		echo "Devops properties file exist"
		if [ -d ${build_prop_dir}/${application}/${ENVIRONMENT}/${ClientName} ]
		then
			echo "Build directory exist"
			mkdir ${build_artifact_no}/config
			cp ${build_prop_dir}/${application}/${ENVIRONMENT}/${ClientName}/* ${build_artifact_no}/config/
			cd ${build_artifact_no} && zip -r ${ClientName}.zip *
			cd ..
		else
			echo "Build directory ${build_prop_dir}/${application}/${ENVIRONMENT}/${ClientName} does not exist"
		fi
	else
		echo "Devops $ENVIRONMENT file does not exist"
	fi
}

function apply_stop()
{
	echo "********* Removing the old application code and directories from server $i *********"
	#ssh -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no -tt ${deployuser}@${hostname} 'echo "kill -9 \`/usr/sbin/lsof -i tcp:9031 | grep java | awk '\'{print '\$2' }$'\' | sort | uniq\`" > stop.sh; sh stop.sh; sleep 10'
	ssh -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no -tt ${deployuser}@${hostname} "echo ClientName=${ClientName} >stop.sh"
	ssh -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no -tt ${deployuser}@${hostname} 'echo "kill -9 \`ps -ef| grep \${ClientName} | grep -v grep | awk '\'{print '\$2' }$'\'\`" >>stop.sh; sh stop.sh; sleep 10'
}

function removefiles()
{
	echo "********* Removing the old application code and directories from server $i *********"
	ssh -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no -tt ${deployuser}@${hostname} "rm -rf ${deploydir}/${application}/${ClientName}/*; mkdir -p ${deploydir}/${application}/${ClientName}/resumes"
}

function copyToserver()
{
	set -e
	echo "********* deploy the s3 artifact on server $i *********"
	scp -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no ${build_artifact_no}/${ClientName}.zip ${deployuser}@${hostname}:${deploydir}/${application}/${ClientName}/
	ssh -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no -tt ${deployuser}@${hostname} "
	unzip ${deploydir}/${application}/${ClientName}/${ClientName}.zip -d ${deploydir}/${application}/${ClientName}/"
	set +e
}


function apply_start()
{	
	set -e
	echo "********* Starting the Apply services *********"
	ssh -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no -tt ${deployuser}@${hostname} "
	cd ${deploydir}/${application}/${ClientName};
	echo 'nohup java -jar ./*.jar &' > start.sh; sh start.sh; sleep 10"
	set +e
}

function deploy()
{
	set -x
	instance_count=`cat ${devops_prop_file} | grep "node.*" | awk -F"." '{print $1}' | sort | uniq | wc -l`
	s3_bucket_name=`cat ${devops_prop_file} | grep s3.bucket.name | cut -d"=" -f2`
	download_artifacts
	localise_propertyfiles
	
	echo "********* Deployment started at `date` "	
	for ((i=1; i<=$instance_count; i++))
	{
		set -e
		# Declaration of Variables
		hostname=`cat ${devops_prop_file} | grep node${i}.hostname | cut -d"=" -f2`
		accesskey=`cat ${devops_prop_file} | grep node${i}.accesskey | cut -d"=" -f2`
		deployuser=`cat ${devops_prop_file} | grep node${i}.deployuser | cut -d"=" -f2`
		deploydir=`cat ${devops_prop_file} | grep node${i}.deploydir | cut -d"=" -f2`
		set +e
		
		apply_stop
		removefiles
		copyToserver
		apply_start	
	}
	set +x
}
if [ $# -eq 3 ]
then
	ENVIRONMENT=$1						#ex: QA, DEV, PROD
	build_info=$2				#ex: "1.0.30-release_1.0"
	repo_data_path=$3
	build_artifact_no=`echo ${build_info} | awk -F"-" '{print $1}'`	
	application=`echo ${build_info} | awk -F"-" '{print $2}'`
	ClientName=`echo ${build_info} | awk -F"-" '{print $3}'`
	
	build_prop_dir=${repo_data_path}/buildproperties
	devops_config_dir=${repo_data_path}/devops_tools
	devops_prop_file=${repo_data_path}/devops_tools/server_properties_files/${application}_${ENVIRONMENT}.properties
	
	
	echo  "Calling Deployment " 
	deploy ${ENVIRONMENT} ${build_info} ${repo_data_path}
else
	echo "Error Message: Deployment is failing. Please provide the correct parameters"
	exit 2
fi
