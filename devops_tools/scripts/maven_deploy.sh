function download_artifacts()
{
	set -e
	echo "********* Downloading artifacts ******"
	mkdir -p ${build_artifact_no}
	aws s3 cp ${s3_bucket_name}/${application}/${build_artifact_no} ${build_artifact_no} --recursive
	set +e
}

function localise_propertyfiles()
{
	echo "********* Updating property file inside the artifact"
	if [ -f ${devops_prop_file} ] 
	then
		propfile_count=`cat ${devops_prop_file} | grep "property.file*" | awk -F"." '{print NR}' | tail -1`
		for ((c=1; c<=$propfile_count; c++))
		{
			prop_file=`cat ${devops_prop_file} | grep "property.file${c}" | cut -d"=" -f2 | awk -F"/" '{print $NF}'`
			prop_dir=`cat ${devops_prop_file} | grep "property.file${c}" | cut -d"=" -f2 | awk -F"/" '{ $NF = ""; print $0 }' | sed 's/\ /\//g'`
			echo "prop_file : $prop_file"
			echo "prop_dir : $prop_dir"
			if [ -f ${build_prop_dir}/${application}/${ENVIRONMENT}/${prop_file} ]
			then
				mkdir -p ${prop_dir}
				cp ${build_prop_dir}/${application}/${ENVIRONMENT}/${prop_file} ${prop_dir}
				jar uvf ${build_artifact_no}/${artifactName} ${prop_dir}/${prop_file}
				rm -rf ${prop_dir}
			else
				echo "Error: The property file ${build_prop_dir}/${application}/${ENVIRONMENT}/${prop_file} DOESNT EXIST"
				exit 1
			fi
		 }
	else
		echo "Devops $ENVIRONMENT file does not exist"
	fi
}

function backupfiles()
{
	echo "********* Removing the old application code and directories from server $i *********"
	ssh -i ${devops_config_dir}/${accesskey} -tt ${deployuser}@${hostname} "rm -rf ${deploydir}/${artifact_value}*"
}

function copyToserver()
{
	set -e
	echo "********* deploy the s3 artifact on server $i *********"
	scp -i ${devops_config_dir}/${accesskey} ${build_artifact_no}/${artifactName} ${deployuser}@${hostname}:/${deploydir}/${targetartifactName}
	set +e
}

function tomcat_stop()
{
	echo "********* Stopping the tomcat instance - $i *********"
	ssh -i ${devops_config_dir}/${accesskey} -o StrictHostKeyChecking=no -tt ${deployuser}@${hostname} "${stop_cmd}"
}

function tomcat_start()
{	
	echo "********* Starting the tomcat instance - $i *********"
	ssh -i ${devops_config_dir}/${accesskey} -tt ${deployuser}@${hostname} "${start_cmd}"
}

function deploy()
{
	instance_count=`cat ${devops_prop_file} | grep "node.*" | awk -F"." '{print $1}' | sort | uniq | wc -l`
	s3_bucket_name=`cat ${devops_prop_file} | grep s3.bucket.name | cut -d"=" -f2`
	artifactName=`cat ${devops_prop_file} | grep artifactName | cut -d"=" -f2`
	targetartifactName=`cat ${devops_prop_file} | grep targetName | cut -d"=" -f2`
	artifact_value=`cat ${devops_prop_file} | grep targetName | cut -d"=" -f2 | cut -d"." -f1`
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
		stop_cmd=`cat ${devops_prop_file} | grep node${i}.stop | cut -d"=" -f2`
		start_cmd=`cat ${devops_prop_file} | grep node${i}.start | cut -d"=" -f2`
		set +e
		
		tomcat_stop
		backupfiles
		copyToserver
		tomcat_start
	}
}
if [ $# -eq 3 ]
then
	ENVIRONMENT=$1						#ex: QA, DEV, PROD
	build_artifact_no=$2				#ex: "1.0.30-release_1.0"
	home_dir=$3							# run pwd and pass the same
	build_prop_dir=${home_dir}/buildproperties
	devops_config_dir=${home_dir}/devops_tools
	devops_prop_file=${devops_config_dir}/server_properties_files/${application}_${ENVIRONMENT}.properties

	echo  "Calling Deployment " 
	deploy ${ENVIRONMENT} ${build_artifact_no} ${home_dir}
else
	echo "Error Message: Deployment is failing. Please provide the correct parameters"
	exit 2
fi
