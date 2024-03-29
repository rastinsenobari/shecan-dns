#!/bin/bash 

status() {
    declare -i count=0

    # Check if $resolv file exists
    if [ ! -f "$resolv" ]; then
        echo ""$resolv" file not found." >&2
        exit 1
    fi

    # Check nameservers are present in the file
    for dns in "${dns_ip[@]}"; do
        if grep -q "^nameserver "${dns}"" "$resolv"; then 
            count+=1
        fi 
    done
    shecan_count=$count
}

set() {
    status
    if [ $shecan_count -eq 0 ]; then 
        sed -i 's/^nameserver/#&/' "$resolv" &&
        add(){
            for dns in "${dns_ip[@]}"; do
                echo "nameserver $dns" >>"$resolv" 
            done
        } && add &&
        echo "shecan nameservers are appended" &&
        return 0
    else
        return 1
    fi
}

unset() {
    status
    if [ $shecan_count -eq 0 ]; then 
        return 1
    else
        del(){
            for dns in "${dns_ip[@]}"; do
                sed -i "/nameserver "${dns}"/d" "$resolv"
            done
        } && del &&
        sed -i 's/#nameserver/nameserver/g' "$resolv" &&
        echo "shecan nameservers are deleted" &&
        return 0
    fi
}

check_option(){
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -s|--status)
                status
                if [ $shecan_count -eq 0 ]; then 
                    echo "You don't have any shecan DNS"
                else
                    echo "You have $shecan_count shecan DNS"  
                fi
                exit 0
                ;;
            *)
                echo "Error: Unknown option $1">&2
                #help
                exit 1
                ;;
        esac
    done
}

resolv="/etc/resolv.conf"
dns_ip=( "178.22.122.100" "185.51.200.2")
shecan_count=0
status
check_option "$@"

set || unset || (echo "unexpected error">&2 && exit 1)