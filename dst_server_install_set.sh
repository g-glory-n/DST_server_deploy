#!/bin/bash -e

script_root_dir=$(pwd)

has_install="no"
install_dir="$HOME/steam_dst/"
steam_dir="$install_dir/steam/"
dst_dir="$install_dir/dst"
start_stop_script_dir="$dst_dir"
dst_config_dir="$HOME/.klei/DoNotStarveTogether/"
cluster_name="MyDediServer"
reset_cluster_name=""
select_archive_name=""



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
    whiptail --title "welcome" --msgbox "         description: deploy DST linux server\n\n               website: www.g-glory-n.top\n                   author: g-glory-n\n                   date: 2020.07.10" 12 60
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
                exit 1
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
            if ! sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 libsdl2-dev screen vim
            then
                whiptail --title "install rely failed!" --yesno "安装依赖失败，更新所有软件并重试（$ sudo apt-get upgrade -y）？" 10 60
                sudo apt-get upgrade -y
                if ! sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 libsdl2-dev screen vim
                then
                    whiptail --title "install rely failed!" --yesno "安装依赖失败，请联系邮箱：g-glory-n@qq.com！" 10 60
                    exit 1
                fi
            fi
        else
            sudo apt-get update
            if ! sudo apt-get install -y libstdc++6 libgcc1 libcurl4-gnutls-dev libsdl2-dev screen vim
            then
                whiptail --title "install rely failed!" --yesno "安装依赖失败，更新所有软件并重试（$ sudo apt-get upgrade -y）？" 10 60
                sudo apt-get upgrade -y
                if ! sudo apt-get install -y libstdc++6 libgcc1 libcurl4-gnutls-dev libsdl2-dev screen vim
                then
                    whiptail --title "install rely failed!" --yesno "安装依赖失败，请联系邮箱：g-glory-n@qq.com！" 10 60
                    exit 1
                fi
            fi
        fi

    fi

    if type yum &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            if ! sudo yum install -y glibc.i686 libstdc++.i686 libcurl.i686 screen vim
            then
                whiptail --title "install rely failed!" --yesno "安装依赖失败，更新所有软件并重试（$ sudo yum update -y）？" 10 60
                sudo yum update -y
                if ! sudo yum install -y glibc.i686 libstdc++.i686 libcurl.i686 screen vim
                then
                    whiptail --title "install rely failed!" --yesno "安装依赖失败，请联系邮箱：g-glory-n@qq.com！" 10 60
                    exit 1
                fi
            fi
        else
            if ! sudo yum install -y glibc libstdc++ libcurl screen vim
            then
                whiptail --title "install rely failed!" --yesno "安装依赖失败，更新所有软件并重试（$ sudo yum update -y）？" 10 60
                sudo yum update -y && sudo yum install -y glibc libstdc++ libcurl screen vim
                if ! sudo yum install -y glibc libstdc++ libcurl screen vim
                then
                    whiptail --title "install rely failed!" --yesno "安装依赖失败，请联系邮箱：g-glory-n@qq.com！" 10 60
                    exit 1
                fi
            fi
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
            whiptail --title "下列软件将被卸载清除！" --yesno "libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 libsdl2-dev screen vim" 10 60
            sudo apt-get remove -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 screen vim
            sudo apt-get clean
            sudo apt-get autoclean
        else
            whiptail --title "下列软件将被卸载清除！" --yesno "libgcc1 libcurl4-gnutls-dev screen vim" 10 60
            sudo apt-get remove -y libstdc++6 libgcc1 libcurl4-gnutls-dev screen vim
            sudo apt-get clean
            sudo apt-get autoclean
        fi

    fi

    if type yum &> /dev/null
    then
        # 分辨位数。
        if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]
        then
            whiptail --title "下列软件将被卸载清除！" --yesno "glibc.i686 libstdc++.i686 libcurl.i686 screen vim" 10 60
            sudo yum remove -y glibc.i686 libstdc++.i686 libcurl.i686 screen vim
            sudo yum clean
        else
            whiptail --title "下列软件将被卸载清除！" --yesno "glibc libstdc++ libcurl screen vim" 10 60
            sudo yum remove -y glibc libstdc++ libcurl screen vim
            sudo yum clean
        fi

    fi

    cd $HOME
    whiptail --title "清除游戏数据！" --yesno "" 5 60
    rm -rf ./Steam/ ./.klei/ ./steam_dst/ ./.steam/
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
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Master | grep -v dmS | grep $cluster_name | awk '{print $2}')" == "" ]]
    then
        screen -dmS dst_master ./dontstarve_dedicated_server_nullrenderer -console -cluster "$cluster_name" -shard Master &
    fi
}

function dst_caves_start()
{
    cd $dst_dir/bin/
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Caves | grep -v dmS | grep $cluster_name | awk '{print $2}')" == "" ]]
    then
        screen -dmS dst_caves ./dontstarve_dedicated_server_nullrenderer -console -cluster "$cluster_name" -shard Caves &
    fi
}



function dst_master_stop()
{
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Master | grep -v dmS | grep $cluster_name | awk '{print $2}')" != "" ]]
    then
        sudo kill -9 $(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Master | grep -v dmS | grep $cluster_name | awk '{print $2}')
    fi
}

function dst_caves_stop()
{
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Caves | grep -v dmS | grep $cluster_name | awk '{print $2}')" != "" ]]
    then
        sudo kill -9 $(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep Caves | grep -v dmS | grep $cluster_name | awk '{print $2}')
    fi
}

function dst_stop_all()
{
    if [[ "$(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep -v dmS | grep -v grep | awk '{print $2}')" != "" ]]
    then
        sudo kill -9 $(ps -ef | grep ./dontstarve_dedicated_server_nullrenderer | grep -v dmS | grep -v grep | awk '{print $2}')
    fi
}



function backup_archive()
{
    if [ ! -d $HOME/.klei/backup/ ]
    then
        mkdir -p $HOME/.klei/backup/
    fi
    cd $HOME/.klei/DoNotStarveTogether/$cluster_name/ && tar -cvf $HOME/.klei/backup/${cluster_name}---$(date +%Y_%m_%d---%H_%M_%S).tar ./
}



function restore_archive()
{
    if [ ! -d $HOME/.klei/DoNotStarveTogether/$reset_cluster_name/ ]
    then
        mkdir -p $HOME/.klei/DoNotStarveTogether/$reset_cluster_name/
    else
        rm -rf $HOME/.klei/DoNotStarveTogether/$reset_cluster_name/
        mkdir -p $HOME/.klei/DoNotStarveTogether/$reset_cluster_name/
    fi
    cd $HOME/.klei/backup/ && tar -xvf ./$select_archive_name -C $HOME/.klei/DoNotStarveTogether/$reset_cluster_name/
}



function clean_archive()
{
    echo ""
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
    rm -rf $HOME/.klei/DoNotStarveTogether/$cluster_name/dedicated_server_mods_setup.lua
}



function whiptail_progress_bar()
{
    {
    for ((i = 0 ; i <= 100 ; i+=10))
    do
        sleep 0.1
        echo $i
    done
    } | whiptail --gauge "Please wait while setting" 6 60 0
}



function dst_set()
{
    while true
    do
        dst_set_option=$(whiptail --title "command select" --checklist "请注意：编辑器使用的是 vim，按 i 进入编辑修改模式，修改完按 ESC，再按 :wq 保存退出！\n\n当前存档指向：$cluster_name" 25 40 12 \
        "init conf" "初始化配置" off \
        "cre_new_wor" "创建新世界" off \
        "set token" "配置 token" off \
        "set master" "配置地上世界" off \
        "set caves" "配置地下世界" off \
        "set block" "配置黑名单" off \
        "set white" "配置白名单" off \
        "set admin" "配置管理员" off \
        "download mod" "编辑下载模组" off \
        "on_of_s mod" "启关配置模组" off \
        "update mod" "更新所有模组" off \
        "return" "返回上一层" off 3>&1 1>&2 2>&3)

        if [[ "$dst_set_option" =~ "init conf" ]]
        then
            whiptail --title "message" --yesno "    你将停止地上和地下服务并删除现有配置文件，创建初始配置文件。" 10 60
            sleep 3
            rm -rf $HOME/.klei/DoNotStarveTogether/$cluster_name/
            mkdir -p $HOME/.klei/DoNotStarveTogether/$cluster_name/
            cd $script_root_dir
            cp -r ./.klei/DoNotStarveTogether/MyDediServer/* $HOME/.klei/DoNotStarveTogether/$cluster_name/
            rm -rf $HOME/.klei/DoNotStarveTogether/$cluster_name/dedicated_server_mods_setup.lua
        fi

        if [[ "$dst_set_option" =~ "cre_new_wor" ]]
        then
            whiptail --title "message" --msgbox "                       创建新档。" 10 60
            new_cluster_name=$(whiptail --title "新档名（小于等于 6 个汉字字符或 12 个英文字符）" --inputbox "请务必保证，输入存档名不包含于已有存档名集合！\n\n列出所有已有存档：$ ls \$HOME/.klei/DoNotStarveTogether/\n部分已有存档预览：\n$(ls $HOME/.klei/DoNotStarveTogether/)" 20 60 3>&1 1>&2 2>&3)
            mkdir -p $HOME/.klei/DoNotStarveTogether/$new_cluster_name
            cd $script_root_dir
            cp -r ./.klei/DoNotStarveTogether/MyDediServer/* $HOME/.klei/DoNotStarveTogether/$new_cluster_name/
            rm -rf $HOME/.klei/DoNotStarveTogether/$new_cluster_name/dedicated_server_mods_setup.lua
        fi

        if [[ "$dst_set_option" =~ "set token" ]]
        then
            whiptail --title "message" --yesno "                  你将配置 token 文件。" 10 60
            echo $(whiptail --title "token config" --inputbox "\n                   请输入你的 token。" 10 60 3>&1 1>&2 2>&3) > $HOME/.klei/DoNotStarveTogether/$cluster_name/cluster_token.txt
        fi

        if [[ "$dst_set_option" =~ "set master" ]]
        then
            whiptail --title "message" --yesno "               你将编辑地上资源配置文件。" 10 60
            vim $HOME/.klei/DoNotStarveTogether/$cluster_name/Master/worldgenoverride.lua
        fi

        if [[ "$dst_set_option" =~ "set caves" ]]
        then
            whiptail --title "message" --yesno "               你将编辑地下资源配置文件。" 10 60
            vim $HOME/.klei/DoNotStarveTogether/$cluster_name/Caves/worldgenoverride.lua
        fi

        if [[ "$dst_set_option" =~ "set block" ]]
        then
            whiptail --title "message" --yesno "你将编辑黑名单，日志（server_log.txt）中找对应的 SteamID64，添加到文件。" 10 60
            vim $HOME/.klei/DoNotStarveTogether/$cluster_name/blocklist.txt
        fi

        if [[ "$dst_set_option" =~ "set white" ]]
        then
            whiptail --title "message" --yesno "你将编辑白名单（服务器为白名单玩家保留席位）。\n例如：\nKU_3N5KE2Zp\nKU_BJY3CxYT\nKU_vvbUjgIX\n..." 15 60
            vim $HOME/.klei/DoNotStarveTogether/$cluster_name/whitelist.txt
        fi

        if [[ "$dst_set_option" =~ "set admin" ]]
        then
            whiptail --title "message" --yesno "你将编辑管理员（user_id）名单。\n例如：\nKU_3N5KE2Zp\nKU_BJY3CxYT\nKU_vvbUjgIX\n..." 15 60
            vim $HOME/.klei/DoNotStarveTogether/$cluster_name/adminlist.txt
        fi

        if [[ "$dst_set_option" =~ "download mod" ]]
        then
            whiptail --title "message" --yesno "                你将编辑需要下载的 mod。" 10 60
            vim $HOME/steam_dst/dst/mods/dedicated_server_mods_setup.lua
        fi

        if [[ "$dst_set_option" =~ "on_of_s mod" ]]
        then
            whiptail --title "message" --msgbox "配置 mod 比较繁杂，推荐方法：\n用饥荒客户端配置创建新世界，\n然后拷贝用户配置文件夹中的 modoverrides.lua 到 \n\n$HOME/.klei/DoNotStarveTogether/世界配置文件夹(默认：MyDediServer)/Master(or Caves)/modoverrides.lua" 12 60
        fi

        if [[ "$dst_set_option" =~ "update mod" ]]
        then
            whiptail --title "message" --yesno "                   你将更新所有 mod。" 10 60
            whiptail --title "message" --msgbox "                   重启游戏服务即可。" 10 60
        fi

        if [[ "$dst_set_option" =~ "return" ]]
        then
            return
        fi

        if [[ "$dst_set_option" != "" ]]
        then
            whiptail_progress_bar
        fi

    done
}



function loop()
{
    get_root

    if [ ! -d $HOME/.klei/DoNotStarveTogether/MyDediServer/ ]
    then
        while true
        do
            cluster_name=$(whiptail --title "set cluster name" --inputbox "启动服务和配置模组等操作都是针对不同存档的，所以你要对需要进行操作的存档（默认档：MyDediServer）进行路径配置。\n\n请务必保证输入的正确性！\n列出所有存档：$ ls \$HOME/.klei/DoNotStarveTogether/\n当前指向存档：$cluster_name\n部分存档预览：\n$(ls $HOME/.klei/DoNotStarveTogether/)" 20 60 "MyDediServer" 3>&1 1>&2 2>&3)
            if [ -d $HOME/.klei/DoNotStarveTogether/$cluster_name/ ]
            then
                break
            else
                whiptail --title "存档不存在，请重更新输入！" --yesno "" 5 60
            fi
        done
    fi

    while true
    do
        option=$(whiptail --title "当前存档指向：$cluster_name" --checklist \
        "" 22 43 15 \
        "cluster name" "设置目标存档" off \
        "dst config" "配置饥荒服务" off \
        "start master" "开启地上世界" off \
        "start caves" "开启地下世界" off \
        "stop master" "关闭地上世界" off \
        "stop caves" "关闭地下世界" off \
        "stop all" "关闭所有世界" off \
        "backup" "创建存档备份" off \
        "restore" "恢复存档备份" off \
        "clean archive" "清除存档备份" off \
        "update dst" "更新饥荒服务" off \
        "update steamcmd" "更新服务平台" off \
        "help" "脚本帮助文档" off \
        "uninstall clean" "卸载清除依赖" off \
        "exit" "退出脚本页面" off 3>&1 1>&2 2>&3)


        if [[ "$option" =~ "cluster name" ]]
        then
            while true
            do
                cluster_name=$(whiptail --title "set cluster name" --inputbox "启动服务和配置模组等操作都是针对不同存档的，所以你要对需要进行操作的存档（默认档：MyDediServer）进行路径配置。\n\n请务必保证输入的正确性！\n列出所有存档：$ ls \$HOME/.klei/DoNotStarveTogether/\n当前指向存档：$cluster_name\n部分存档预览：\n$(ls $HOME/.klei/DoNotStarveTogether/)" 20 60 "MyDediServer" 3>&1 1>&2 2>&3)
                if [ -d $HOME/.klei/DoNotStarveTogether/$cluster_name/ ]
                then
                    break
                else
                    whiptail --title "存档不存在，请重更新输入！" --yesno "" 5 60
                fi
            done
        fi

        if [[ "$option" =~ "dst config" ]]
        then
            whiptail --title "message" --yesno "       配置过程将停止地上和地下服务，需要手动启动。" 10 60
            dst_stop_all
            whiptail_progress_bar
            dst_set
        fi

        if [[ "$option" =~ "start master" ]]
        then
            whiptail --title "存档指向：$cluster_name" --yesno "                 开启存档指向的地上服务。" 10 60
            dst_master_start
            whiptail --title "message" --yesno "开启世界需要时间（大概：2 min），请内心等待。\n\n查看会话序号：screen -ls\n\n查看启动日志：screen -r session_id/session_name" 12 60
        fi

        if [[ "$option" =~ "start caves" ]]
        then
            whiptail --title "存档指向：$cluster_name" --yesno "                 开启存档指向的地下服务。" 10 60
            dst_caves_start
        fi

        if [[ "$option" =~ "stop master" ]]
        then
            whiptail --title "存档指向：$cluster_name" --yesno "                 关闭存档指向的地上服务。" 10 60
            dst_master_stop
        fi

        if [[ "$option" =~ "stop caves" ]]
        then
            whiptail --title "存档指向：$cluster_name" --yesno "                 关闭存档指向的地下服务。" 10 60
            dst_caves_stop
        fi

        if [[ "$option" =~ "stop all" ]]
        then
            whiptail --title "stop all server" --yesno "             你将关闭本机所有地上和地下服务。" 10 60
            dst_stop_all
        fi

        if [[ "$option" =~ "backup" ]]
        then
            whiptail --title "存档指向：$cluster_name" --yesno "                      备份指向存档。" 10 60
            backup_archive
            whiptail --title "存档名：${cluster_name}---$(date +%Y_%m_%d---%H_%M_%S).tar" --yesno "              存档位置：$HOME/./klei/backup/" 10 60
        fi

        if [[ "$option" =~ "restore" ]]
        then
            # echo $option
            archive_list=
            for list in $(ls $HOME/.klei/backup/)
            do
                temp_list=${list%.*}
                temp_list=${temp_list%---*}
                temp_list=${temp_list%---*}
                archive_list="$archive_list $list $temp_list off"
            done
            # echo -e "$archive_list"
            select_archive_name=$(whiptail --title "恢复存档" --checklist \
            "" 20 68 14 \
            $archive_list 3>&1 1>&2 2>&3)
            # echo "$select_archive_name"
            select_archive_name=$(echo "${select_archive_name##\"}")
            # echo "$select_archive_name"
            select_archive_name=$(echo "${select_archive_name%\"}")
            # echo "$select_archive_name"

            if [ ! -z $select_archive_name ]
            then
                reset_cluster_name=${select_archive_name%.*}
                reset_cluster_name=${reset_cluster_name%---*}
                reset_cluster_name=${reset_cluster_name%---*}
                # echo "$reset_cluster_name"
                reset_cluster_name=$(whiptail --title "是否重设存档名？" --inputbox "" 10 60 $reset_cluster_name 3>&1 1>&2 2>&3)
                restore_archive
            fi
        fi

        if [[ "$option" =~ "clean archive" ]]
        then
            whiptail --title "" --yesno "待开发 ..." 10 60

        fi

        if [[ "$option" =~ "update dst" ]]
        then
            whiptail --title "message" --yesno "       更新过程将停止地上和地下服务，需要手动启动。" 10 60
            dst_stop_all
            update_dst
        fi

        if [[ "$option" =~ "update steamcmd" ]]
        then
            whiptail --title "message" --yesno "       更新过程将停止地上和地下服务，需要手动启动。" 10 60
            dst_stop_all
            update_steamcmd
        fi

        if [[ "$option" =~ "help" ]]
        then
            whiptail --title "help document" --msgbox "1：快速开服：配置（token，世界资源，等其他配置项），开启地上世界，开启地下世界（可选），退出脚本。\n\n2：一段时间（若干天）后客户端可能搜索不到世界，需要更新 DST（会同时更新模组），一般不需要更新 steamcmd。\n\n3：请在生成 DST 世界前，配置世界资源，否则无效。\n\n4：更新或配置选项将会关闭所有饥荒服务（地上和地下）。\n\n5：脚本可以创建多个存档，针对不同存档可分别进行配置。\n\n6：配置错误不用重装软件，可以选择配置初始化选项，重新配置。\n\n7：BUG 提交，疑难解答，请联系邮箱: g-glory-n@qq.com。" 27 60
            # continue # 可能导致 exit 无效。
        fi

        if [[ "$option" =~ "uninstall clean" ]]
        then
            whiptail --title "uninstall ?" --yesno "" 5 60
            uninstall
	    exit 0
        fi

        if [[ "$option" =~ "exit" ]]
        then
            exit 0
        fi

        if [[ "$option" != "" ]] && [[ "$option" != "\"help\"" ]] && [[ "$option" != "\"cluster name\"" ]]
        then
            whiptail_progress_bar
        fi
    done
}



function init_loop()
{
    if whiptail --title "whether to install?" --yes-button "install" --no-button "exit"  --yesno "             install location: ~/steam_dst/\n\n          DST setting files location: ~/.klei/\n\n          steam rely files location: ~/Steam/\n\n       tested environment: Debian 8/9 CentOS 6/7" 14 60
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

