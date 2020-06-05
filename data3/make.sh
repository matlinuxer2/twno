#!/usr/bin/env bash

SRC_URL="https://www.moi.gov.tw/files/site_stuff/321/1/month/m1-11.xls"

function get_file(){
    local url="$1"
    local fpath="$2"
    local expire="${3:-3600}"

    if [ -e "$fpath" ] ; then
        ftime=$( stat -c "%Y" "$fpath" )
        curtime=$( date "+%s" )
        calc=$( expr $curtime - $ftime - $expire )

        if [ $calc -le 0 ] ; then
            printf "[SKIP] current: $curtime , mtime: $ftime , expire: $expire \n"
            return 0
        fi
    fi

    printf "[Download] %s => %s \n" "$url" "$fpath"
    curl -skL -o "$fpath" "$url"
}

function parse_file_to_json(){
    local src_data="$1"
    local dst_data="$2"

    python parse.py "$src_data" "$dst_data"
}

get_file "$SRC_URL" "data.xls"
parse_file_to_json "data.xls" "data.json"
