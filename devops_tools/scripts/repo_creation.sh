#!/bin/sh

reponame=$1
echo "Creating a New Repository"
curl --user mahe@imomentous.info:Phen@m1234 https://api.bitbucket.org/1.0/repositories/ --data name=$reponame --data is_private='true'

testparam=`echo $reponame | cut -d"-" -f1`
if [ "$testparam" == "apply" ]; then new_reponame=apply; elif [ "$testparam" == "jobpull" ]; then new_reponame=jobpull; else new_reponame=$reponame; fi


echo "Creating the respective groups"
curl --request POST --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/1.0/groups/mahe@imomentous.info --data "name=${new_reponame}_CR"
curl --request POST --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/1.0/groups/mahe@imomentous.info --data "name=${new_reponame}_DEV"

echo "Linking the respective repository and groups"
curl --request PUT --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/1.0/group-privileges/mahe@imomentous.info/$reponame/mahe@imomentous.info/${new_reponame}_cr --data write
curl --request PUT --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/1.0/group-privileges/mahe@imomentous.info/$reponame/mahe@imomentous.info/${new_reponame}_dev --data write

echo "Locking the New Repository"
curl --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/2.0/repositories/mahe@imomentous.info/$reponame/branch-restrictions/ --data kind='force' --data pattern='*'
curl --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/2.0/repositories/mahe@imomentous.info/$reponame/branch-restrictions/ --data kind='delete' --data pattern='*'

aws s3 cp s3://software-imom/group.json .
cp group.json group1.json
sed -i 's/accountname/mahe@imomentous.info/g' group1.json; sed -i 's/group1/'${new_reponame}_CR'/g' group1.json; sed -i 's/group2/admin/g' group1.json; sed -i 's/mypattern/master/g' group1.json;
curl -v --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/2.0/repositories/mahe@imomentous.info/$reponame/branch-restrictions/ --header "Content-Type: application/json" --data @group1.json
rm -rf group1.json

cp group.json group2.json
sed -i 's/accountname/mahe@imomentous.info/g' group2.json; sed -i 's/group1/'${new_reponame}_CR'/g' group2.json; sed -i 's/group2/admin/g' group2.json; sed -i 's/mypattern/release_*/g' group2.json;
curl -v --user mahe@imomentous.info:Phen@m1234 https://bitbucket.org/api/2.0/repositories/mahe@imomentous.info/$reponame/branch-restrictions/ --header "Content-Type: application/json" --data @group2.json
rm -rf group2.json

echo "Creating default release branches"
git clone git@bitbucket.org:maheimom/$reponame.git
cd $reponame
touch README.md
git add README.md
git commit -m "Initial Commit"
git push origin master
git checkout -b release_1.0
git push origin release_1.0

git checkout -b feature_1.0
git push origin feature_1.0