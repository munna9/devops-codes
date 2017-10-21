
DHOME=$4
build_no=$2
inputTask=$1
prop_file=$3
function trim()
{
	trim_output=`echo $1 | sed 's/^ *//;s/ *$//'`
	echo "$trim_output"
}
function localizefile()
{
	echo "		--Localizing the given property file inside the artifact "
	input=$1
	build_number=$2
	artifactName=`echo $input | awk -F"##" '{print $2}'`
	artifactName=`echo $artifactName | sed 's/^ *//;s/ *$//'`
	property_file=`echo $input | awk -F"##" '{print $3}'`
	property_file=`echo $property_file | sed 's/^ *//;s/ *$//'`
	build_property_file=`echo $input | awk -F"##" '{print $4}'`
	build_property_file=`echo $build_property_file | sed 's/^ *//;s/ *$//'`
	echo "-- test: $build_number/$artifactName"
	if [ -f ${DHOME}/$build_property_file ] && [ -f "$build_number/$artifactName"  ]
	then
		echo "		--both property and artifact files exist"
		prop_dir=`echo $property_file | awk -F"/" '{ $NF = ""; print $0 }' | sed 's/\ /\//g'`
		mkdir -p $prop_dir
		cp ${DHOME}/$build_property_file $prop_dir
		jar uvf $build_number/$artifactName $property_file
		rm -rf $prop_dir
	else
		echo "ERROR:- Either ${DHOME}/$build_property_file or $build_number/$artifactName doesn't exist in workspace"
		exit 1
	fi
}
function s3download()
{
	set -e
	echo "		--Downloading artifacts s3 bucket************"
	input=$1
	build_number=$2
	#echo "input line ----- $1"
	s3_server=`echo $input | awk -F"##" '{print $2}'`
	s3_server=$(trim $s3_server)
	s3_application_name=`echo $input | awk -F"##" '{print $3}'`
	s3_application_name=`echo $s3_application_name | sed 's/^ *//;s/ *$//'`
	s3_artifact_dir=`echo $input | awk -F"##" '{print $4}'`
	s3_artifact_dir=`echo $s3_artifact_dir | sed 's/^ *//;s/ *$//'`
	s3_artifact_name=`echo $input | awk -F"##" '{print $5}'`
	s3_artifact_name=`echo $s3_artifact_name | sed 's/^ *//;s/ *$//'`
	s3_path=${s3_server}/${s3_application_name}/${build_number}/${s3_artifact_dir}
	s3_path=`echo $s3_path | sed 's#//$#/#g'`
	echo "---	s3_server			:	$s3_server"
	echo "---	s3_application_name	:	$s3_application_name"
	echo "---	s3_artifact_dir		:	$s3_artifact_dir"
	echo "---	s3_artifact_name	:	$s3_artifact_name"
	
	mkdir -p ${build_number}
	echo "aws s3 cp ${s3_path} ${build_no} --recursive "
	aws s3 cp ${s3_path} ${build_number} --recursive 
	if [ $? -eq 0 ]
	then
		echo "		--The S3 download artifact has been successfully completed ********"
	else
		echo "-- ALERT: Something went wrong with S3 download  method, please check"
		exit 1
	fi
	set +e
}
function s3applydownload()
{
	set -e
	echo "		--Downloading artifacts s3 bucket************"
	input=$1
	build_number=$2
	#echo "input line ----- $1"
	s3_server=`echo $input | awk -F"##" '{print $2}'`
	s3_server=$(trim $s3_server)
	s3_application_name=`echo $input | awk -F"##" '{print $3}'`
	s3_application_name=`echo $s3_application_name | sed 's/^ *//;s/ *$//'`
	s3_path=${s3_server}/${s3_application_name}/${build_number}
	s3_path=`echo $s3_path | sed 's#//$#/#g'`
	echo "---	s3_server			:	$s3_server"
	echo "---	s3_application_name	:	$s3_application_name"
	
	echo "aws s3 cp ${s3_path} . --recursive "
	aws s3 cp ${s3_path} . --recursive 
	if [ $? -eq 0 ]
	then
		echo "		--The S3 download artifact has been successfully completed ********"
	else
		echo "-- ALERT: Something went wrong with S3 download  method, please check"
		exit 1
	fi
	set +e
}
function backup()
{
	#set -x
	input=$1
	build_number=$2
	serverName=`echo $input | awk -F"##" '{print $2}' | sed 's/^ *//;s/ *$//'`
	user=`echo $input | awk -F"##" '{print $3}' | sed 's/^ *//;s/ *$//'`
	accessKey=`echo $input | awk -F"##" '{print $4}' | sed 's/^ *//;s/ *$//'`
	backupFile=`echo $input | awk -F"##" '{print $5}' | sed 's/^ *//;s/ *$//'`
	onlyFileName=`echo $backupFile | awk -F"/" '{print $NF}'`
	onlyFileName=$(trim $onlyFileName)
	backupDir=`echo $input | awk -F"##" '{print $6}' | sed 's/^ *//;s/ *$//'`
	backupFile_tmp=`echo $onlyFileName`"_"`date +"%Y%m%d_%H%M%S"`
	echo "		--Removing the $backupFile from $serverName  ***"
	#echo "-- accessKey: $accessKey"
	#echo "-- user: $user"
	#echo "-- backupFile: $backupFile"
	#echo backupFile_tmp: $backupFile_tmp
	ssh -o "StrictHostKeyChecking no" -i ${DHOME}/${accessKey} -p 2929 -tt ${user}@${serverName} "if [ -d $backupDir ]; then if [ -f $backupFile ]; then mv $backupFile $backupDir/$backupFile_tmp; else echo There is no $backupFile to take backup; fi; else echo The $backupDir doesnt exist so creating it; mkdir -p $backupDir  ; if [ -f $backupFile ]; then mv $backupFile $backupDir/$backupFile_tmp; else echo There is no $backupFile to take backup; fi; fi"
	
	echo "		--End of Backup method "
	#set +x
}

function copy()
{
	#set -x
	input=$1
	build_number=$2
	serverName=`echo $input | awk -F"##" '{print $2}' | sed 's/^ *//;s/ *$//'`
	user=`echo $input | awk -F"##" '{print $3}' | sed 's/^ *//;s/ *$//'`
	accessKey=`echo $input | awk -F"##" '{print $4}' | sed 's/^ *//;s/ *$//'`
	srcFile=`echo $input | awk -F"##" '{print $5}' | sed 's/^ *//;s/ *$//'`
	destFile=`echo $input | awk -F"##" '{print $6}' | sed 's/^ *//;s/ *$//'`
	lastNameinPath=`echo $destFile | sed s'#\/$##' | awk -F"/" '{print $NF}'`
	destDir=`echo $destFile | awk -F"$lastNameinPath" '{print $1}'`
	
	echo "		--deploy the s3 artefacts on $serverName"

	ssh -o "StrictHostKeyChecking no" -i ${DHOME}/${accessKey} -p 2929 -tt ${user}@${serverName} " if [ -d $destDir ]; then echo "dest dir exist"; else mkdir -p $destDir; fi"
	scp -o "StrictHostKeyChecking no" -i ${DHOME}/${accessKey} -P 2929 ${build_number}/${srcFile} ${user}@${serverName}:${destFile}
	if [ $? -eq 0 ]
	then
		echo "		--The copying artifact $srcFile has been successfully completed ********"
	else
		echo "-- ALERT: Something went wrong with COPY method, please check"
		exit 1
	fi
}
function localize()
{
	echo "		--LOCALIZE_FILE function to find replace given strings in a file **********"
	build_number=$2
	input=$1
	artifactName=`echo $input | awk -F"##" '{print $2}' | sed 's/^ *//;s/ *$//'`
	fileName=`echo $input | awk -F"##" '{print $3}' | sed 's/^ *//;s/ *$//'`
	findString=`echo $input | awk -F"##" '{print $4}' | sed 's/^ *//;s/ *$//'`
	replaceString=`echo $input | awk -F"##" '{print $5}' | sed 's/^ *//;s/ *$//'`
	absolutePath=
	if [ -f $build_number/$artifactName ]
	then
		echo "		-- The file $fileName exist and performing the localize"
		jar xf $build_number/$artifactName $fileName
		sed -i "s%$findString%$replaceString%g" $fileName 
		jar uvf $build_number/$artifactName $fileName
		rm -rf $fileName
	else 
		echo "ERROR:- The $build_number/$artifactName doesn't exist in workspace"
		exit 1
	fi
}
function run()
{
	#set -x
	input=$1
	build_number=$2
	serverName=`echo $input | awk -F"##" '{print $2}' | sed 's/^ *//;s/ *$//'`
	user=`echo $input | awk -F"##" '{print $3}' | sed 's/^ *//;s/ *$//'`
	accessKey=`echo $input | awk -F"##" '{print $4}' | sed 's/^ *//;s/ *$//'`
	command=`echo $input | awk -F"##" '{print $5}' | sed 's/^ *//;s/ *$//'`
	
	echo "		--Executing the given commands  <${command}> on remote server "
	
	ssh -o "StrictHostKeyChecking no" -i ${DHOME}/${accessKey} -p 2929 -tt ${user}@${serverName} "${command}"
	if [ $? -eq 0 ]
	then
		echo "		-- The  <${command}> has been successfully completed"
	else
		echo "-- ALERT: Something went wrong with RUN method, please check"
		exit 1
	fi
}
function executelocal()
{
	#set -x
	input=$1
	command=`echo $input | awk -F"##" '{print $2}' | sed 's/^ *//;s/ *$//'`
	
	echo "		--Executing the given commands  <${command}> on local machine "
	
	${command}
	if [ $? -eq 0 ]
	then
		echo "		-- The  <${command}> has been successfully completed"
	else
		echo "-- ALERT: Something went wrong with executelocal method, please check"
		exit 1
	fi
}
function copylocalfile()
{
	#set -x
	input=$1
	filelocation1=`echo $input | awk -F"##" '{print $2}' | sed 's/^ *//;s/ *$//'`
	filelocation2=`echo $input | awk -F"##" '{print $3}' | sed 's/^ *//;s/ *$//'`
	
	echo "		--Executing the given commands  <cp ${DHOME}/${filelocation1} ${filelocation2}/> on local machine "
	
	cp ${DHOME}/${filelocation1} ${filelocation2}/
	if [ $? -eq 0 ]
	then
		echo "		-- The  <cp ${DHOME}/${filelocation1} ${filelocation2}/> has been successfully completed"
	else
		echo "-- ALERT: Something went wrong with copylocalfile method, please check"
		exit 1
	fi
}
function servercopy()
{
	#set -x
	input=$1
	serverName=`echo $input | awk -F"##" '{print $2}' | sed 's/^ *//;s/ *$//'`
	user=`echo $input | awk -F"##" '{print $3}' | sed 's/^ *//;s/ *$//'`
	accessKey=`echo $input | awk -F"##" '{print $4}' | sed 's/^ *//;s/ *$//'`
	srcFile=`echo $input | awk -F"##" '{print $5}' | sed 's/^ *//;s/ *$//'`
	destFile=`echo $input | awk -F"##" '{print $6}' | sed 's/^ *//;s/ *$//'`
	lastNameinPath=`echo $destFile | sed s'#\/$##' | awk -F"/" '{print $NF}'`
	destDir=`echo $destFile | awk -F"$lastNameinPath" '{print $1}'`
	
	echo "		--deploy the s3 artefacts on $serverName"

	ssh -o "StrictHostKeyChecking no" -i ${DHOME}/${accessKey} -p 2929 -tt ${user}@${serverName} " if [ -d $destDir ]; then echo "dest dir exist"; else mkdir -p $destDir; fi"
	scp -o "StrictHostKeyChecking no" -i ${DHOME}/${accessKey} -P 2929 ${srcFile} ${user}@${serverName}:${destFile}
	if [ $? -eq 0 ]
	then
		echo "		--The copying artifact $srcFile has been successfully completed ********"
	else
		echo "-- ALERT: Something went wrong with COPY method, please check"
		exit 1
	fi
}

if [ $# -eq 4 ]
then
	build_no=$2
	inputTask=$1
	prop_file=$3
	DHOME=$4
	> dep.properties
	if [ -f ${DHOME}/devops_tools/server_properties_files/$3 ]
	then
	awk "/%%$inputTask{/{flag=1;next}/%%}/{flag=0}flag" ${DHOME}/devops_tools/server_properties_files/$3 > dep.properties
	else
		echo "ERROR: There is no $3 config file inside server_properties_files dir"
	fi
	echo "STARTED AT: `date`"
	cat dep.properties | while read line
	do {
		comment_chr=`echo $line | awk '{print $1}' | cut -c1`
		if [ "$comment_chr" == "@" ] || [ -z "$line" ]
		then
		 continue 
		fi
		task=`echo $line | awk -F"##" '{print $1}'`
		#echo "Task Name:  $task"
		task=`echo $task | sed 's/^ *//;s/ *$//'`
		
			case $task in
				s3download)	echo "!!!!****** s3download Method ******!!!!" 
							s3download "$line" "$build_no" ;;
				s3applydownload)	echo "!!!!****** s3applydownload Method ******!!!!" 
							s3applydownload "$line" "$build_no" ;;
				localizefile)	echo "!!!!****** Calling localizefile Method ******!!!!" 
							localizefile "$line" "$build_no";;
				localize)	echo "!!!!****** Calling localize Method ******!!!!" 
							localize "$line" "$build_no";;
				copy) 		echo "!!!!****** COPY Method Copying of artifacts ******!!!!"
							copy "$line" "$build_no" ;;
				servercopy) 		echo "!!!!****** ServerCOPY Method Copying of artifacts ******!!!!"
							servercopy "$line" ;;			
				backup)		echo "!!!!****** BACKUP the given artifacts on given server ******!!!!"
							backup "$line" "$build_no"  ;;
				run) 		echo "!!!!****** RUN Method ******!!!!" 
							run "$line" ;;
				executelocal) echo "!!!!****** execute local Method ******!!!!" 
							executelocal "$line" ;;
				copylocalfile) 	echo "!!!!****** execute local copy Method ******!!!!" 
							copylocalfile "$line" ;;				
				*) 			echo "!!!!****** Wrong Choice : $task ******!!!!"
			esac
		} < /dev/null; done
		echo "COMPLETED AT: `date`"
else
	echo "Error Message: Deployment script is failed. Please provide the correct parameters"
	echo "USAGE: sh deploy.sh <deploy> <BUILD_ID> <PROP_FILE_NAME> <DHOME>"
	exit 2
fi