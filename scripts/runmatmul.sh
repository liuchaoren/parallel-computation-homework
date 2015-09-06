#!/bin/bash

remoteHost=gitlab.oit.duke.edu
remoteUser=git
# replace the following line with your group number
Groups=20
remoteRepos=parprog.git
localCodeDir=tmprepo

for gitRepo in $remoteRepos
do

  for Group in $Groups
  do
	fullGroupName=parprog_f15_group$Group
    echo -e "Group = $Group gitRepo = $gitRepo localCodDir = $localCodeDir"
    localRepoDir=$(echo ${localCodeDir}/$fullGroupName/${gitRepo}|cut -d'.' -f1)
	echo -e "LocalRepoDir = $localRepoDir"
    if [ -d $localRepoDir ]; then 	
		echo -e "Directory $localRepoDir already exits, please remove it..."
	else
		cloneCmd="git clone $remoteUser@$remoteHost:$fullGroupName/"
		cloneCmd=$cloneCmd"$gitRepo $localRepoDir"
		
		echo -e "$cloneCmd"
	#	cloneCmdRun=$($cloneCmd 2>&1)

		cloneCmdRun=$($cloneCmd)
		echo -e "Running: \n$ $cloneCmd"
		echo -e "${cloneCmdRun}"
		pushd $PWD/$localRepoDir/labs/collective
		make
		echo -e "Run Serial Code"
		$PWD/matmul_serial
		echo -e "Run Serial Reorg Code"
		$PWD/matmul_reorg
		echo -e "Run openmp Code"
		$PWD/matmul_openmp
		echo -e "Run openmp Reorg Code"
		$PWD/matmul_openmp_reorg
		popd
    fi
  done
done
