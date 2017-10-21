# Declaring Variable
export M2_HOME="/opt/devops_tooling/maven-3.3.3"

function maven_compile()
{
	echo "Starting Cleaning"
	echo "==========================================="
	${M2_HOME}/bin/mvn clean

	echo "Starting compilation"
	echo "==========================================="
	${M2_HOME}/bin/mvn compile
}

function upload_artifact()
{
	echo "Publishing the ZIP in AWS S3 Bucket"
	echo "=============================================="
	set -e
	 aws s3 cp target/*.war s3://build-artifacts-imom/${application}/${BRANCH}.${BUILD_NUMBER}/
	set +e
	echo "=============================================="
	echo "Package Published Successfully"
}
function maven_package()
{
	maven_compile
	echo "Starting ZIP Creation"
	echo "==========================================="
	${M2_HOME}/bin/mvn package
	#upload_artifact
}
function maven_veracode()
{
	maven_compile
	echo "Starting ZIP Creation"
	echo "==========================================="
	${M2_HOME}/bin/mvn package
}

if [ $# -eq 1 ]
then
	case $1 in
		package) echo "Calling Clean, Compile, Package and Upload"
					maven_package;;
		compile) echo "Calling Clean and Compile"
					maven_compile;;
		veracode) echo "Calling Clean and Compile"
					maven_veracode;;
	esac
else
	echo "Please pass the correct argument to perform the relevant operation (ex. compile, package)"
	exit 1
fi