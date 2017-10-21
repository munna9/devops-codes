# Declaring Variable
application=careerconnect

function set_home()
{
	echo "Setting up Java Version"
	echo "==========================================="
	export JAVA_HOME=/opt/devops_tooling/jdk1.8.0_45
	export GRAILS_HOME=/opt/devops_tooling/grails-2.4.3
	export PATH=$PATH:$JAVA_HOME/bin:$GRAILS_HOME
}

function grails_compile()
{
	set_home
	echo "Grails Cleaning"
	echo "==========================================="
	${GRAILS_HOME}/bin/grails clean

	echo "Staring grails compilation"
	echo "==========================================="
	${GRAILS_HOME}/bin/grails compile
}

function upload_artifact()
{
	echo "Publishing the war in AWS S3 Bucket"
	echo "=============================================="
	set -e
	 aws s3 cp target/*.war s3://build-artifacts-imom/${application}/${BRANCH}.${BUILD_NUMBER}/
	set +e
	echo "=============================================="
	echo "Package Published Successfully"
}

function grails_package()
{
	grails_compile
	echo "Staring grails WAR Creation"
	echo "==========================================="
	${GRAILS_HOME}/bin/grails war
	upload_artifact
}
function grails_veracode()
{
	grails_compile
	echo "Staring grails WAR Creation"
	echo "==========================================="
	${GRAILS_HOME}/bin/grails war
}

if [ $# -eq 1 ]
then
	case $1 in
		package) echo "Calling Clean, Compile, Package and Upload"
					grails_package;;
		compile) echo "Calling Clean and Compile"
					grails_compile;;
		veracode) echo "Calling Clean and Compile"
					grails_veracode;;
	esac
else
	echo "Please pass the correct argument to perform the relevant operation (ex. compile, package)"
	exit 1
fi