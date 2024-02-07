#!/bin/bash  

status() {
    declare -i count=0
    another_dns=false

    # Check if $resolv file exists
    if [ ! -f "$resolv" ]; then
        log ""$resolv" file not found." "Error"
    fi

    # Check nameservers are present in the file
    if grep -q "^nameserver ${shecan_ip[0]}" "$resolv"; then 
        count+=1
    fi 
    if grep -q "^nameserver ${shecan_ip[1]}" "$resolv"; then
        count+=1
    fi
    shecan_count=$count
    # Check another DNS
    if [ $(grep -c "^nameserver" "$resolv") -gt $count ]; then
        another_dns=true
    fi
}

reload_dns(){
    # nmcli general reload dns-rc
    # nmcli con reload
    # NetworkManager SIGUSR1
    # NetworkManager SIGHUP
    log "we dont have this yet" "Error"
}

log(){
    case $2 in 
        "Error")
            echo "["$2"]: "$1"" >&2
            exit 1
        ;;
        *)
            #Warning || Info || *
            echo "["$2"]: "$1""
        ;;
    esac
}


resolv="/etc/resolv.conf"
shecan_ip=( "178.22.122.100" "185.51.200.2")
actions=( "Status" "Set" "Unset" "Reload" "Quit")
shecan_count=0
status

#info message
echo "With this command, you can change your default dns to shecan dns"
echo "Note that this command is not permanent and is rewritten by system settings"

PS3="what do you want to do? "
select action in ${actions[@]}
    do 
        case $action in 
            "Status")
                status
                if [ $shecan_count -eq 0 ]; then 
                    log "You dont have any shecan nameserver" "Info"
                else
                    log "You have "$shecan_count" shecan nameserver" "Info"
                    if $another_dns; then
                        log "But you have another nameserver and this makes a conflict" "Warning"
                    fi
                fi
            ;;
            "Set")
                status
                if [ $shecan_count -eq 0 ]; then 
                    sed -i 's/^nameserver/#&/' "$resolv" &&
                    echo "nameserver ${shecan_ip[0]}" >>"$resolv" &&
                    echo "nameserver ${shecan_ip[1]}" >>"$resolv" &&
                    log "shecan nameservers are appended" "Info"
                else
                    log "You already have "$shecan_count" shecan nameserver" "Notice"
                    if $another_dns; then
                        log "But you have another nameserver and this makes a conflict" "Warning"
                    fi
                fi
            ;;
            "Unset")
                status
                if [ $shecan_count -eq 0 ]; then 
                    log "You dont have any Shecan nameserver" "Notice"
                else
                    sed -i "/nameserver "${shecan_ip[0]}"/d" "$resolv" && 
                    sed -i "/nameserver "${shecan_ip[1]}"/d" "$resolv" && 
                    sed -i 's/#nameserver/nameserver/g' "$resolv" &&
                    log "shecan nameservers are deleted" "Info"
                fi
            ;;
            "Reload")
                reload_dns
                log "The configuration was reloaded" "Info"
            ;;
            "Quit")
                break
            ;;
            *)
                log "invalid choice" "Warning"
        esac
    done
    