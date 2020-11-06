#!/bin/bash -e



progress_bar_i=0
progress_bar_index_color=4 # 0(黑), 1(红), 2(绿), 3(黄), 4(蓝), 5(洋红), 6(青), 7(白)
progress_bar_color=$((30+progress_bar_index_color))
progress_bar_window_width=$(stty size|awk '{print $2}')
((progress_bar_window_width=progress_bar_window_width-13))
progress_bar_str_sharp=""
progress_bar_j=$(echo "scale=2; 100/${progress_bar_window_width}" | bc)
progress_bar_k=$(echo "scale=2; 100/${progress_bar_window_width}" | bc)
progress_bar_arr=("|" "/" "-" "\\")

echo -e "\033[36m\ntask progress: \n\033[0m" # 36 青色前景
while [ $progress_bar_i -le 100 ]
do
    progress_bar_index=$((progress_bar_i%4))

    if [ ${progress_bar_window_width} -le 100 ]
    then
        printf "\e[0;$progress_bar_color;1m[%-${progress_bar_window_width}s][%.2f%%] %c\r" "$progress_bar_str_sharp" "$progress_bar_i" "${progress_bar_arr[$progress_bar_index]}"

        if [ "$(echo "${progress_bar_i}>=${progress_bar_k}" | bc)" == "1" ]
        then
            progress_bar_str_sharp+='#'
            progress_bar_k=$(echo "scale=2; ${progress_bar_k}+${progress_bar_j}" | bc)
        fi

        if [ ${progress_bar_i} -eq 100 ]
        then
            printf "\e[0;$progress_bar_color;1m[%-${progress_bar_window_width}s][%.2f%%] %c\r" "$progress_bar_str_sharp" "$progress_bar_i" " "
            printf "\n"
        fi
    else
        if [ "$(echo "${progress_bar_i}>=${progress_bar_k}" | bc)" == "1" ]
        then
            while [ 1 ]
            do
                if [ "$(echo "${progress_bar_i}<=${progress_bar_k}" | bc)" == "1" ]
                then
                    break
                fi

                printf "\e[0;$progress_bar_color;1m[%-${progress_bar_window_width}s][%.2f%%] %c\r" "$progress_bar_str_sharp" "$progress_bar_i" "${progress_bar_arr[$progress_bar_index]}"

                progress_bar_str_sharp+='#'
                progress_bar_k=$(echo "scale=2; ${progress_bar_k}+${progress_bar_j}" | bc)
            done

            if [ ${progress_bar_i} -eq 100 ]
            then
                printf "\e[0;$progress_bar_color;1m[%-${progress_bar_window_width}s][%.2f%%] %c\r" "$progress_bar_str_sharp" "$progress_bar_i" " "
            fi
        fi
    fi
    progress_bar_i=$((progress_bar_i+1))

    sleep 0.01
done
echo -e "\033[0m" # 用于设置默认前景色背景色
