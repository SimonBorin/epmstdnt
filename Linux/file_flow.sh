#!/usr/bin/env bash

#===============================================================================
#
#    DESCRIPTION: File_flow is a file copying script
#         AUTHOR: Semen Borin
#         E-MAIL: semen_borin@epam.com
#         GITHUB: https://github.com/SimonBorin/epmstdnt
#        CREATED: 03.02.2020
#
#===============================================================================

#===  FUNCTION  ================================================================
#         NAME:  _dir_chck
#  DESCRIPTION:  check folder perms
#===============================================================================

function _dir_chck() { # to mv you need write and exec to folders src dst
    if [ -e "$1" ]&&[ -d "$1" ] ; then
        if [ -w "$1" ]&&[ -x "$1" ]; then
            echo "[INFO]Folder $1 perms are ok" 
        else
            _echoerr "[ERROR]Not enough permissions at $1. Try to use sudo." 
            exit 1
        fi
    else 
        _echoerr "[ERROR]Error in filepath! $1 doesn't exist or not a directory" 
        exit 1
    fi
}

#===  FUNCTION  ================================================================
#         NAME:  _read_config
#  DESCRIPTION:  Read config file to get vars 
#===============================================================================

function _read_config() {
    CONFDIR=$(dirname "${SCRIPT_PASH}")
    . "$CONFDIR"/file_flow.config
    LOGDIR=$(dirname "${LOGFILENAME}")
    _dir_chck "$LOGDIR"
    touch $LOGFILENAME
    _dir_chck "$SOURCEDIR"
    _dir_chck "$TARGETDIR"
}

#===  FUNCTION  ================================================================
#         NAME:  _mv
#  DESCRIPTION:  moves and renames files from src to dst and log it
#===============================================================================

function _mv() {
    if [ -f "$1" ]; then
        CUR_DATE=$(date +"%Y-%m-%d %H:%M:%S")
        OBJ_NAME=$(awk 'BEGIN{FS="\t"} NR==1 {print $1}' "$1")
        OBJ_DATE=$(awk 'BEGIN{FS="\t"} NR==1 {print $2}' "$1")
        OBJ_UUID=$(awk 'END{if (/^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/) print $1}' "$1")
        OBJ_NEW_NAME="$OBJ_NAME $OBJ_DATE $CUR_DATE"
        
        if [ ! -z "$OBJ_UUID" ]; then
            touch "$1".lock
            mv $1 "$TARGETDIR"/"$OBJ_NEW_NAME"
            echo "[SUCCESS]FIle $1 moved to $TARGETDIR and renamed to $OBJ_NEW_NAME" >> $LOGFILENAME
            rm -rf "$1".lock
        else
            echo "[FAIL]File $1 is not redy! UUID wasn't detected" >> $LOGFILENAME
        fi 
        unset OBJ_UUID
    else
        echo "[FAIL]File $1 is not a common file" >> $LOGFILENAME
    fi
}

#===  FUNCTION  ================================================================
#         NAME:  main
#  DESCRIPTION:  main func
#===============================================================================

function main() {
    SCRIPT_PASH="${0}"
    _read_config
    echo "Started at $(date +'%d.%m.%Y %H:%M:%S %Z')" >> $LOGFILENAME
    echo "$(tail -1000 $LOGFILENAME)" > $LOGFILENAME
    for file in "$SOURCEDIR"/*; do
        if [ -f "$TARGETDIR"/"$file".lock ]; then
        continue
        fi
        _mv "$file"
    done
    echo "Ended at $(date +'%d.%m.%Y %H:%M:%S %Z')" >> $LOGFILENAME
}

#===  FUNCTION  ================================================================
#         NAME:  _echoerr
#  DESCRIPTION:  puts msg to STDERR and log file
#===============================================================================
function _echoerr() { 
    echo "$@" 1>&2
    }

#===  END OF FUNCTIONS  ========================================================

if  [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    echo 'main run'
    main "$@"
else
    echo "lib"
fi