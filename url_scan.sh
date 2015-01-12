#!/bin/bash

TARGET=
TIME=
PZ=
PZ_NAME=

function usage()
{
cat << EOF
--------------------------------
usage: $0 options

OPTIONS:

   -h      Show this message
   -t      Target
   -s      Time Sleep 
   -p      Set Scan 
           1 (default scan)
           2 (Ghost scan)
           3 (Uber scan)
--------------------------------
EOF
}
check_PZ() {
	if [ -z "$PZ" ]; then
		PZ=$(echo 0 10 20 30 40 50)
    	PZ_NAME="default"
    	print_good "set Sleep on $PZ_NAME"
    else
    	case $PZ in
    		     1)
                    PZ="0 10 20 30 40 50"
    	            PZ_NAME="Default scan"
    	            print_good "set Sleep on $PZ_NAME"
                    ;;
                 2)
                    PZ="0 10 20 30 40 50 60 70 80 90"
    	            PZ_NAME="Ghost scan"
    	            print_good "set Sleep on $PZ_NAME"
                    ;;  
                 3)
                    PZ="0 10 20 30 40 50 60 70 80 90 100 110 120 130 140"
    	            PZ_NAME="Uber scan"
    	            print_good "set Sleep on $PZ_NAME"
                    ;;
                 ?)
                    usage
                    exit
                    ;;     
                 esac           
    fi	
}
function print_good ()
{
    echo -e "\x1B[01;32m[*]\x1B[0m $1"
}

function print_error ()
{
    echo -e "\x1B[01;31m[*]\x1B[0m $1"
}

function print_status ()
{
    echo -e "\x1B[01;34m[*]\x1B[0m $1"
}

check_os() {

    if [ $(uname -s) == 'Darwin' ]; then
		command="ggrep"
    elif [ $(uname -s) == 'Linux' ]; then
        command="grep"
    fi
}

check_TARGET() {

	if [ -z "$TARGET" ];then
		usage
        exit 1
    else

	    if [ $TARGET != "http://*" ];then
		     URL=${TARGET#http://}
	    else
		    URL=${TARGET}		
	    fi
    fi
}

run () {

	_x_="site:"
	query="$_x_$URL"
	print_good "set domain $URL"
	for paginazione in 0 10 20 30 40 50 60 70 80 90 
	do
	if [ -z "$TIME" ]; then
		TIME="2"
    	print_good "Auto set Sleep on 2"
    else
    	print_good "set Sleep on $TIME"
    fi	
	sleep $TIME
	echo "--------------------- Please Wait ---------------------"
	stream=$(curl -A "Mozilla/4.0" -skLm 10 \
	"http://google.it/search?q=\"$query\"&start=$paginazione" |\
	$command -oP '\/url\?q=.+?&amp' | sed 's/\/url?q=//;s/&amp//');
    if [ -z "$stream" ]; then
		print_error "the string is empty"
    	print_error "check that the correct domain"
    	print_error "ip changes and increases the time to sleep"
    	exit 1
    else
    	print_good "$stream"
    fi
	echo -e "${stream//\%/\x}" >> /tmp/temp.txt
	done
	sort /tmp/temp.txt | uniq > 'url.txt'
	print_good "number lines : $(wc -l 'url.txt')"
	
}

while getopts “ht:s:p:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         t)
             TARGET=$OPTARG
             ;;
         s)
             TIME=$OPTARG
             ;;
         p)  
             PZ=$OPTARG 
             ;;   
         ?)
             usage
             exit
             ;;
     esac
done
check_os
check_TARGET
check_PZ
run