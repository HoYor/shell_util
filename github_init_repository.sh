###
 # @Author: hr
 # @Date: 2020-02-08 16:26:01
 # @LastEditTime : 2020-02-08 16:46:06
 # @LastEditors  : Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: /undefined/Users/yym/Desktop/github_init_repository.sh
 ###
#!/bin/bash

if [ $# -lt 2 ]
then
    echo 'please input the local path of git and the remote url of git'
    exit
fi
cd $1;
if [ $# -gt 2 ]
then
    echo "# $3" > README.md
fi
git init
git add .
git commit -m "init"
git remote add origin $2
git push -u origin master
