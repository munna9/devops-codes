# Declaring Variable
export GULP_HOME="/home/ec2-user/.nvm/v0.10.30/bin"

function gulp_compile()
{
	#maven_compile
	echo "Starting GULP Compile"
	echo "==========================================="
	gulp dev
}
function gulp_package()
{
	gulp_compile
	echo "Starting GULP package"
	echo "==========================================="
	mv build candidates-appui
	zip -r candidates-appui.zip candidates-appui
}

if [ $# -eq 1 ]
then
	case $1 in
		compile) echo "Calling Gulp Compile"
					gulp_compile;;
		package) echo "Calling Gulp Compile"
					gulp_package;;			
	esac
else
	echo "Please pass the correct argument to perform the relevant operation (ex. compile, package)"
	exit 1
fi