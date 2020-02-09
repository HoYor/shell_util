# !/bin/bash 

path=$1
domain="http://www.baidu.com/"

if [ -d $path ] 
then
	if [ ! -f info.json ]
	then
		echo '[' > 'info.json'
	fi
	apk_list=(`ls $path/*.apk`)
    for apk in ${apk_list[*]}
    do
    	apk_name=${apk##*/}
    	apk_name=${apk_name%.*}
    	if [ -d $path/${apk_name} ]
    	then
    		continue
    	fi
        echo "get the info of ${apk_name}"
    	echo '' > 'temp.json'
    	echo '{' >> 'temp.json'
        echo "\"apk_name\":\"${apk_name}\"," >> 'temp.json'
    	# echo "\"apk_url\":\"${domain}${apk##*/}\"," >> 'temp.json'
    	apk_info=`aapt dump badging ${apk}`
    	info1_list=(`echo "${apk_info}" | grep 'package: name' | awk -F "'" '{print $2" "$4" "$6" "$8}'`)
    	package_name=${info1_list[0]}
    	version_code=${info1_list[1]}
    	version_name=${info1_list[2]}
    	# platform_build_version_name=${info1_list[3]}
    	echo "\"package_name\":\"${package_name}\"," >> 'temp.json'
    	echo "\"version_code\":\"${version_code}\"," >> 'temp.json'
        echo "\"version_name\":\"${version_name}\"," >> 'temp.json'
        # echo "\"platform_build_version_name\":\"${platform_build_version_name}\"," >> 'temp.json'
        app_name=`echo "${apk_info}" | grep 'application: label' | awk -F "'" '{print $2}'`
        echo "\"app_name\":\"${app_name}\"," >> 'temp.json'
        # 因为app名可能有空格，所以不能用上面的方法
        icon_name=`echo "${apk_info}" | grep 'application: label' | awk -F "'" '{print $4}'`
        icon_folder=${icon_name}
        icon_name=${icon_name##*/}
        icon_name=${icon_name%.*}
        icon_folder=${icon_folder#*/}
        icon_folder=${icon_folder%/*}
        icon_folder=${icon_folder%%-*}
        echo "\"icon_name\":\"@${icon_folder}/${icon_name}\"," >> 'temp.json'
        # min_sdk_version=`echo "${apk_info}" | grep 'sdkVersion:' | awk -F "'" '{print $2}'`
        # echo "\"min_sdk_version\":\"${min_sdk_version}\"," >> 'temp.json'
        target_sdk_version=`echo "${apk_info}" | grep 'targetSdkVersion:' | awk -F "'" '{print $2}'`
        echo "\"target_sdk_version\":\"${target_sdk_version}\"," >> 'temp.json'
        # launchable_activity=`echo "${apk_info}" | grep 'launchable-activity' | awk -F "'" '{print $2}'`
        # echo "\"launchable_activity\":\"${launchable_activity}\"," >> 'temp.json'
        icon_list=(`echo "${apk_info}" | grep 'application-icon-' | awk -F "'" '{print $2}'`)
        icon_list=(`echo ${icon_list[*]} | tr ' ' '\n' | sort -u | tr '\n' ' '`)
        echo "\"icon_obj\":{" >> 'temp.json'
        for i in $(seq 0 `expr ${#icon_list[*]} - 1`)
        do
            icon=${icon_list[i]}
        	folder_name=${icon#*/}
        	folder_name=${folder_name%/*}
        	if [ $i == `expr ${#icon_list[*]} - 1` ]
        	then
	        	echo "\"${folder_name}\":\"${apk_name}/${icon}\"" >> 'temp.json'
	        else
	        	echo "\"${folder_name}\":\"${apk_name}/${icon}\"," >> 'temp.json'
	        fi
        done
        echo '},' >> 'temp.json'
        # icon_index=`expr ${#icon_list[*]} / 2`
        # echo "\"icon\":\"${icon_list[$icon_index]}\"," >> 'temp.json'
        permission_list=(`echo "${apk_info}" | grep 'uses-permission: name=' | awk -F "'" '{print $2}'`)
        permission_list=(`echo ${permission_list[*]} | tr ' ' '\n' | sort -u | tr '\n' ' '`)
        echo "\"permission_list\":[" >> 'temp.json'
        
     #    # 模拟异常
     #    if [ ${apk} == ${apk_list[${#apk_list[*]}-2]} ]
     #    then
     #    	exit
    	# fi

        for i in ${permission_list[*]}
        do
        	if [ $i == ${permission_list[${#permission_list[*]}-1]} ]
        	then
	        	echo "\"${i}\"" >> 'temp.json'
	        else
	        	echo "\"${i}\"," >> 'temp.json'
	        fi
        done
        echo ']' >> 'temp.json'
        if [ ${apk} == ${apk_list[${#apk_list[*]}-1]} ]
        then
        	echo '}' >> 'temp.json'
        else
        	echo '},' >> 'temp.json'
        fi
        cat temp.json >> 'info.json'

        # curl -H "Content-Type:application/json" -X POST --data `cat temp.json` "http://localhost:8080/apk"

        rm -rf temp
        unzip $apk ${icon_list[*]} -d temp
        mv -f temp/ $path/${apk_name}
    done 
    echo ']' >> 'info.json'
else 
    echo $path "not a folder"
fi
