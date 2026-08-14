# 1. Цвет подсказок
set -g fish_color_autosuggestion 8e9099

function fish_prompt
    set_color a7c5fc; echo -n "["
    set_color e2e2e9; echo -n "$USER"
    set_color a7c5fc; echo -n "@"
    set_color e2e2e9; echo -n "doom"
    set_color a7c5fc; echo -n "] "
    set_color 8fc9fc; echo -n (prompt_pwd)
    set_color a7c5fc; echo -n " » "
    set_color normal
end

# 3. правый промпт
function fish_right_prompt
    if test "$CMD_DURATION" -gt 0
        set -g _last_duration "$CMD_DURATION"
    end
    if not set -q _last_duration
        set -g _last_duration 0
    end
    set -l dur "$_last_duration"
    set -l dur_str ""
    if test "$dur" -ge 60000
        set -l m (math -s0 "$dur / 60000")
        set -l s (math -s0 "($dur % 60000) / 1000")
        set dur_str "$m"m"$s"s" "
    else if test "$dur" -ge 1000
        set -l s (math -s0 "$dur / 1000")
        set dur_str "$s"s" "
    else if test "$dur" -gt 0
        set dur_str "$dur"ms" "
    end
    set_color a7c5fc; echo -n "$dur_str"
    set_color 8fc9fc; echo -n "["
    set_color e2e2e9; echo -n (date "+%H:%M:%S")
    set_color a7c5fc; echo -n "]"
    set_color normal
end
