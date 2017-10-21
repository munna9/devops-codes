# Declaring Variable
application=cp-facets

function activator_compile()
{
	echo "Starting Cleaning"
	echo "==========================================="
	./bin/activator clean

	echo "Starting compilation"
	echo "==========================================="
	./bin/activator compile
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
	./bin/activator stage
    cd target/universal/
	mv stage facets
	zip -r facets facets 
	upload_artifact
}
function activator_veracode()
{
	activator_compile
	echo "Starting ZIP Creation"
	echo "==========================================="
	./bin/activator stage
	cd target/universal/
	zip -r stage facets	
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
