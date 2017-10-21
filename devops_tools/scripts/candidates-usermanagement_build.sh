# Declaring Variable
application=usermanagement

function activator_compile()
{
	echo "Starting Cleaning"
	echo "==========================================="
	./activator clean

	echo "Starting compilation"
	echo "==========================================="
	./activator compile
}
function upload_artifact()
{
	echo "Publishing the ZIP in AWS S3 Bucket"
	echo "=============================================="
	set -e
	 aws s3 cp *.zip s3://build-artifacts-imom/${application}/${BRANCH}.${BUILD_NUMBER}/
	set +e
	echo "=============================================="
	echo "Package Published Successfully"
}
function activator_package()
{
	activator_compile
	echo "Starting ZIP Creation"
	echo "==========================================="
	./activator usermanagement-cp
	cp -r ${WORKSPACE}/app/mappers ${WORKSPACE}/target/universal/usermanagement-cp/
	cd target/universal/
	zip -r usermanagement-cp usermanagement-cp 
	upload_artifact
}
function activator_veracode()
{
	activator_compile
	echo "Starting ZIP Creation"
	echo "==========================================="
	./activator usermanagement-cp
	cd target/universal/
	zip -r usermanagement-cp usermanagement-cp 
}

if [ $# -eq 1 ]
then
	case $1 in
		package) echo "Calling Clean, Compile, Package and Upload"
					activator_package;;
		compile) echo "Calling Clean and Compile"
					activator_compile;;
		veracode) echo "Calling Clean and Compile"
					activator_veracode;;			
	esac
else
	echo "Please pass the correct argument to perform the relevant operation (ex. compile, package)"
	exit 1
fi
