#!/bin/bash

convert_file_format(){
    IFS="."
    arr=($1)
    IFS=" "
    iconv -f $2 -t $3 $1 > ${arr[0]}_uft8.${arr[${#arr[@]}-1]}
}
for file in $@
do
    convert_file_format $file GB18030 UTF-8
done