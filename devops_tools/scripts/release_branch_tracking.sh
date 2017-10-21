function update_report()
{
	echo "*************Direct commits on project $repo : $1 branch"
	day=1
	master_commit=`git log origin/$1 --since=$day.day --first-parent --no-merges --oneline`
	if [ "k$master_commit" == "k" ]
	then  
	  echo "NO COMMITS HAPPEND !!!!!"
	else
	  echo "COMMITS Found !!!!!"
	  m_user=`git log origin/$1 --since=$day.day --first-parent --no-merges | grep Author | cut -d":" -f2`
	  m_commitId=`git log origin/$1 --since=$day.day --first-parent --no-merges | grep  commit | sed 's/commit//g'`
	  m_date=`git log origin/$1 --since=$day.day --first-parent --no-merges | grep  Date | sed 's/Date://g'`
	  echo "<tr> <td>$repo</td><td>$1</td><td>$m_user</td> <td>$m_commitId</td> <td>$m_date</td>  </tr> " >> $location/report.html
	fi
}

function clonerepo()
{
	echo "=======Copy the supporting file in workspace directory======="
	cp ${repo_data_path}/devops_tools/scripts/clone.txt $location/clone.txt
	
	echo "=======Fetching the latest code from the repositories======="
	for repo in $(cat $location/clone.txt)
	do 
		path=`pwd`
		if [ -d "$repo" ]
		then
			echo "Repo exist $repo"
			cd $repo; git clean -d --force; git reset --hard HEAD; git pull;
		else
			echo "Cloning repository $repo"
			git clone ssh://git@bitbucket.org/maheimom/$repo.git
		fi
		cd $path
	done
	echo "=======Fetching Completed======="
}

function branchcommits()
{
	clonerepo
	for repo in $(cat $location/clone.txt)
		do 
			path=`pwd`
			cd $path/$repo
			git branch -a | grep origin/release | grep -v release_*.*_dev | grep -v release.*_support | sed 's/^ *//;s/ *$//' | cut -d "/" -f3 >$location/branch.txt
			git branch -a | grep remotes/origin/master | sed 's/^ *//;s/ *$//' | cut -d "/" -f3 >>$location/branch.txt
			for bname in $(cat $location/branch.txt)
			do
				update_report "$bname"
				a="$a$m_user"
			done
			cd $path
		done
}

location=$1
> report.html
echo '<html><body><table border="1"><th>Repository</th><th>Branch</th><th>User</th><th>Commit ID</th><th>Date</th></tr>' > $location/report.html
a=""

branchcommits;

echo '</table></body></html>' >> $location/report.html


echo "======================================================="
echo "Checking Commits Existence"
echo "======================================================="
if [ "$a" == "" ]
then
	echo "NO COMMITS exist so failing the Jenkins job: No email will trigger"
	exit 1
fi
