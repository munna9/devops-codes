#Devops repo update
cd ${repo_data_path}/devops_tools
git clean --force -d
git reset --hard HEAD
git pull
chmod 600 server_access/*
#Environment repo update
cd ${repo_data_path}/buildproperties
git clean --force -d
git reset --hard HEAD
git pull
#WORKSPACE
cd ${WORKSPACE}