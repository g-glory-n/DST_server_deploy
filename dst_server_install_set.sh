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
    exe_file_name="dst_server_install_set.sh"
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
            sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 libsdl2-dev screen
        else
            sudo apt-get update
            sudo apt-get install -y libstdc++6 libgcc1 libcurl4-gnutls-dev libsdl2-dev screen
        fi
    
    fi
    
    if type yum &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            sudo yum install -y glibc.i686 libstdc++.i686 libcurl.i686 screen
        else                     
            sudo yum install -y glibc libstdc++ libcurl screen
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
            sudo apt-get remove -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 libsdl2-dev screen
	    sudo apt-get clean
            sudo apt-get autoclean
        else
            sudo apt-get remove -y libstdc++6 libgcc1 libcurl4-gnutls-dev libsdl2-dev screen
	    sudo apt-get clean
            sudo apt-get autoclean
        fi
    
    fi
    
    if type yum &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            sudo yum remove -y glibc.i686 libstdc++.i686 libcurl.i686 screen
            sudo yum clean
        else
            sudo yum remove -y glibc libstdc++ libcurl screen
            sudo yum clean
        fi
    
    fi

    cd $HOME
    rm -rf ./Steam/ ./.klei/ ./steam_dst/
    sync && sync && sync
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
    cd $dst_dir/bin/
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Master | grep -v dmS | awk '{print $2}')" == "" ]]
    then
        screen -dmS dst_master ./dontstarve_dedicated_server_nullrenderer -console -cluster "$cluster_name" -shard Master &
    fi
}

function dst_caves_start()
{
    cd $dst_dir/bin/
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Caves | grep -v dmS | awk '{print $2}')" == "" ]]
    then
        screen -dmS dst_caves ./dontstarve_dedicated_server_nullrenderer -console -cluster "$cluster_name" -shard Caves &
    fi
}



function dst_master_stop()
{
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Master | grep -v dmS | awk '{print $2}')" != "" ]]
    then
        sudo kill -9 $(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Master | grep -v dmS | awk '{print $2}')
    fi
}

function dst_caves_stop()
{
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Caves | grep -v dmS | awk '{print $2}')" != "" ]]
    then
        sudo kill -9 $(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Caves | grep -v dmS | awk '{print $2}')
    fi
}



function update_steamcmd()
{
    cd $steam_dir && rm -rf ./*
    cd $HOME && rm -rf ./Steam/
    install_steamcmd && cd $steam_dir && ./steamcmd.sh +exit
}



function update_dst()
{
    cd $steam_dir
    ./steamcmd.sh +force_install_dir "$dst_dir" +login anonymous +app_update 343050 validate +quit
}



function dst_config_init()
{
    cd $script_root_dir
    cp ./.klei/DoNotStarveTogether/MyDediServer/dedicated_server_mods_setup.lua $dst_dir/mods/
    cp -r ./.klei/ $HOME/
    rm -rf $HOME/.klei/DoNotStarveTogether/MyDediServer/dedicated_server_mods_setup.lua
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
        "" 17 43 11 \
        "start master" "开启森林世界" off \
        "start caves" "开启洞穴世界" off \
        "stop master" "关闭森林世界" off \
        "stop caves" "关闭洞穴世界" off \
        "dynamic update" "关闭更新重启" off \
        "DST configure" "配置 DST" off \
        "update DST" "更新 DST" off \
        "update steamcmd" "更新 steam" off \
        "help" "帮助文档" off \
        "uninstall clean" "卸载清除" off \
        "exit" "退出脚本" off 3>&1 1>&2 2>&3)


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
        
        if [[ "$option" =~ "dynamic update" ]]
        then
            dst_master_stop
            dst_caves_stop
            update_dst
            dst_master_start
            dst_caves_start
        fi

        if [[ "$option" =~ "DST config" ]]
        then
            dst_master_stop
            dst_caves_stop
            dst_set
        fi

        if [[ "$option" =~ "update DST" ]]
        then
            dst_master_stop
            dst_caves_stop
            update_dst
        fi
        
        if [[ "$option" =~ "update steamcmd" ]]
        then
            dst_master_stop
            dst_caves_stop
            update_steamcmd
        fi

        if [[ "$option" =~ "help" ]]
        then
		whiptail --title "help document" --msgbox "1：快速开服：配置（token，世界资源，等其他配置项），开启森林，开启洞穴，退出。\n\n2：一段时间（若干天）后客户端可能搜索不到世界，需要更新 DST（会同时更新 mod），一般不需要更新 steamcmd。\n\n3：请在生成 DST 世界前，配置世界资源，否则无效。\n\n4：更新或配置选项将会关闭饥荒服务器（森林和洞穴）。\n\n5：脚本只会开启单个森林和洞穴服务器，如需开启多个森林或洞穴请自行配置。\n\n6：BUG 提交，疑难解答，请联系邮箱: g-glory-n@qq.com。" 20 60
            # continue
        fi

        if [[ "$option" =~ "uninstall clean" ]]
        then
            uninstall
	    exit 0
        fi

        if [[ "$option" =~ "exit" ]]
        then
            exit 0
        fi

        if [[ "$option" != "" ]] && [[ "$option" != "\"help\"" ]]
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
    if whiptail --title "whether to install?" --yes-button "install" --no-button "exit"  --yesno "             install location: ~/steam_dst/\n\n          DST setting files location: ~/.klei/\n\n          steam rely files location: ~/Steam/" 12 60
    then
        get_root
        install_rely
        install_steamcmd
        install_dst
        dst_config_init

        loop
    else
        exit 0
    fi
}



welcome
install_judge
if [ "$has_install" = "yes" ]
then
    loop
else
    init_loop
fi



exit 0

