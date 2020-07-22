#!/bin/bash -e

script_root_dir=$(pwd)

has_install="no"
install_dir="$HOME/steam_dst/"
steam_dir="$install_dir/steam/"
dst_dir="$install_dir/dst"
start_stop_script_dir="$dst_dir"
dst_config_dir="$HOME/.klei/DoNotStarveTogether/"
cluster_name="MyDediServer"



function welcome()
{
    # 检测系统基本命令是否存在。
    if [[ "$(type whiptail &> /dev/null)" =~ "not found" ]]
    then
            echo -e "\n\tplease install whiptail!\n"
            exit 1
    fi
    
    # 规范程序执行方式（./file_name.sh or bash ./file_name.sh）。
    exe_file_name="dst_set.sh"
    if [ "$0" != "./$exe_file_name" ] && [ "$0" != "bash ./exe_file_name" ]
    then
    	printf "\n"
    	echo -e " please into source directory to execute \"./$exe_file_name\" or \"bash ./$exe_file_name\"!"
    	printf "\n"
    	exit 1
    fi
    
    # 欢迎界面。
    whiptail --title "welcome" --msgbox "         description: deploy DST linux server\n\n                   author: g-glory-n\n                   date: 2020.07.10\n" 10 60
}



function get_root()
{
    # 普通用户获取 root 权限（sudo 可用时间 5 分钟）。
    if [ "$(whoami)" == "root" ] # determine whether user is root
    then
        echo ""
        echo -e "\033[31m\tyou have get root permission!\033[0m"
        echo ""
    else
        for ((i = 0; i < 4; i++)) # get root permission
        do
            if [ "${i}" != "3" ]
            then
    	    PASSWD=$(whiptail --title "get root permission" --passwordbox "input your root password by three chances" 10 60 3>&1 1>&2 2>&3)
            fi
    
            if [ ${i} = "3" ]; then
                whiptail --title "message" --msgbox "you have tried many times and do not get root permission, the script will exit!" 10 60
                exit 0
            fi
        
            sudo -k
            if sudo -lS &> /dev/null << EOF
${PASSWD}
EOF
            then
                i=10
            else
                if [ "${i}" != "2" ]
                then
                    whiptail --title "get root permission" --msgbox "invalid password, please input corrent password!" 10 60 
                fi
            fi
        done
        
        echo ${PASSWD} | sudo ls > /dev/null 2>&1
        echo ""
        echo -e "\033[31m\tyou have get root permission!\033[0m"
        echo ""
    
    fi
}



function install_judge()
{
    if [ -d $HOME/.klei/ ] && [ -d $install_dir ] || [ -d /root/.klei/ ] && [ -d /root/steam_dst/ ]
    then
        has_install='yes'
    else
        has_install='no'
    fi
}



function install_rely()
{
    # 分辨系统。
    if type apt &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            sudo apt-get update
            sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 screen
        else
            sudo apt-get update
            sudo apt-get install -y libstdc++6 libgcc1 libcurl4-gnutls-dev screen
        fi
    
    fi
    
    if type yum &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            sudo yum -y install glibc.i686 libstdc++.i686 libcurl.i686 screen
        else
            sudo yum -y install glibc libstdc++ libcurl screen
        fi
    
    fi
}



function uninstall()
{
    # 分辨系统。
    if type apt &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            sudo apt-get remove libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 screen
            sudo apt-get autoclean
        else
            sudo apt-get remove libstdc++6 libgcc1 libcurl4-gnutls-dev screen
            sudo apt-get autoclean
        fi
    
    fi
    
    if type yum &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            sudo yum remove glibc.i686 libstdc++.i686 libcurl.i686 screen
            sudo yum clean
        else
            sudo yum remove glibc libstdc++ libcurl screen
            sudo yum clean
        fi
    
    fi
}



function install_steamcmd()
{
    mkdir -p $steam_dir
    cd $steam_dir
    if [ ! -f steamcmd_linux.tar.gz ]
    then
        wget -c https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
        tar -zxvf ./steamcmd_linux.tar.gz
    else
        mv ./steamcmd_linux.tar.gz ../
        rm -rf ./*
        mv ../steamcmd_linux.tar.gz ./
        tar -zxvf steamcmd_linux.tar.gz
    fi
}



function install_dst()
{
    mkdir -p $dst_dir
    cd $steam_dir
    ./steamcmd.sh +force_install_dir "$dst_dir" +login anonymous +app_update 343050 validate +quit
}



function dst_master_start()
{
    cd $dst_dir
    screen -S dst_master ./dontstarve_dedicated_server_nullrenderer -console -cluster "$cluster_name" -shard Master &
}

function dst_caves_start()
{
    cd $dst_dir
    screen -S dst_caves ./dontstarve_dedicated_server_nullrenderer -console -cluster "$cluster_name" -shard Caves &
}



function dst_master_stop()
{
     sudo kill -9 $(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Master | awk '{print $2}')
}

function dst_caves_stop()
{
     sudo kill -9 $(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Caves | awk '{print $2}')
}



function update_steamcmd()
{
    cd $steam_dir
    rm -rf ./*
    install_steamcmd
}



function update_dst()
{
    cd $steam_dir
    ./steamcmd.sh +force_install_dir "$dst_dir" +login anonymous +app_update 343050 validate +quit
}



function dst_config_init()
{
    cd $script_root_dir
    mv ./.klei/DoNotStarveTogether/MyDediServer/dedicated_server_mods_setup.lua $dst_dir/mods/
    mv ./.klei/ $HOME/
}



function dst_set()
{
    echo "temporary does not support!"
}



function loop()
{
    get_root
    while true
    do
        option=$(whiptail --title "command select" --checklist \
        "please select the action instruction" 15 40 8 \
        "dst config" "配置饥荒服务" off \
        "start master" "开启森林世界" off \
        "start caves" "开启洞穴世界" off \
        "stop master" "关闭森林世界" off \
        "stop caves" "关闭洞穴世界" off \
        "update dst" "更新饥荒服务" off \
        "update steam" "更新 steam" off \
        "uninstall all" "卸载清除" off 3>&1 1>&2 2>&3)

        if [[ "$option" =~ "dst config" ]]
        then
            dst_set
        fi

        if [[ "$option" =~ "start master" ]]
        then
            dst_master_start
        fi
        
        if [[ "$option" =~ "start caves" ]]
        then
            dst_caves_start
        fi
        
        if [[ "$option" =~ "stop master" ]]
        then
            dst_master_stop
        fi
        
        if [[ "$option" =~ "stop caves" ]]
        then
            dst_caves_stop
        fi
        
        if [[ "$option" =~ "update dst" ]]
        then
            update_dst
        fi
        
        if [[ "$option" =~ "update steam" ]]
        then
            update_steamcmd
        fi

        if [[ "$option" =~ "uninstall all" ]]
        then
            uninstall
        fi
        
        if [[ "$option" != "" ]]
        then
            {
            for ((i = 0 ; i <= 100 ; i+=10))
            do
                sleep 0.1
                echo $i
            done
            } | whiptail --gauge "Please wait while setting" 6 60 0
        fi
    done
}


function init_loop()
{
    get_root
    install_rely
    install_steamcmd
    install_dst
    dst_config_init

    loop
}




loop
exit 0



install_judge
if [ "$has_install" = "yes" ]
then
    loop
else
    init_loop
fi






exit 0

