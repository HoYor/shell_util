# /bin/bash
###
 # @Author: hr
 # @Date: 2020-08-19 19:30:25
 # @LastEditors: hr
 # @LastEditTime: 2020-08-19 19:40:18
 # @Description: description
### 

install_apk(){
    for apk in `ls $1`
    do
        if [[ -d $1/$apk ]]
        then
        	install_apk $1/$apk
        elif [[ $apk == *.apk ]]
        then
            adb install -r $1/$apk
        fi
    done
}

install_apk $1