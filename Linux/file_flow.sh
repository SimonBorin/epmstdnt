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
            echo "[INFO]Folder $1 perms are ok" >> $LOGFILENAME
        else
            echo "[ERROR]Not enough permissions at $1. Try to use sudo." >> $LOGFILENAME
            exit 1
        fi
    else 
        echo "[ERROR]Error in filepath! $1 doesn't exist or not a directory" >> $LOGFILENAME
        exit 1
    fi
}

#===  FUNCTION  ================================================================
#         NAME:  _read_config
#  DESCRIPTION:  Read config file to get vars 
#===============================================================================

function _read_config() {
    . file_flow.config
    LOGDIR=$(dirname "${LOGFILENAME}")
    _dir_chck "$SOURCEDIR"
    _dir_chck "$TARGETDIR"
    _dir_chck "$LOGDIR"
}

#===  FUNCTION  ================================================================
#         NAME:  _mv
#  DESCRIPTION:  moves and renames files from src to dst and log it
#===============================================================================

function _mv() {
    if [ ! -d "$1" ]; then
        CUR_DATE=$(date +"%Y-%m-%d %H:%M:%S")
        OBJ_NAME=$(awk 'BEGIN{FS="\t"} NR==1 {print $1}' "$1")
        OBJ_DATE=$(awk 'BEGIN{FS="\t"} NR==1 {print $2}' "$1")
        OBJ_UUID=$(awk 'END{if (/^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/) print $1}' "$1")
        OBJ_NEW_NAME="$OBJ_NAME"_"$OBJ_DATE"_"$CUR_DATE"
        
        if [ ! -z "$OBJ_UUID" ]; then
            cp $1 "$TARGETDIR"/"$OBJ_NEW_NAME"
            echo "[SUCCESS]FIle $1 moved to $TARGETDIR and renamed to $OBJ_NEW_NAME" >> $LOGFILENAME
        else
            echo "[FAIL]File $1 is not redy! UUID wasn't detected" >> $LOGFILENAME
        fi 
        unset OBJ_UUID
    else
        echo "[FAIL]File $1 is just a dir ooopsy =D" >> $LOGFILENAME
    fi
}

#===  FUNCTION  ================================================================
#         NAME:  main
#  DESCRIPTION:  main func
#===============================================================================

function main() {
    _read_config
    touch $LOGFILENAME 
    echo $(date) >> $LOGFILENAME
    # cur_date=$(date +"%Y-%m-%d %H:%M:%S")
    # declare $(awk 'BEGIN{OFS="\t"} NR==1 {print OBJ_NAME=$1, OBJ_DATE=$2}' second.txt)
    # OBJ_NAME=$(awk 'BEGIN{FS="\t"} NR==1 {print $1}' second.txt)
    # OBJ_DATE=$(awk 'BEGIN{FS="\t"} NR==1 {print $2}' second.txt)
    # OBJ_UUID=$(awk 'END{print $1}' second.txt)
    # OBJ_UUID=$(awk 'END{if (/^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/) print $1}' second.txt) better
    # OBJ_UUID=$(awk 'END{if (/([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}){1}/) print $1}' second.txt) wount work
    LockFile=~/file_flow.lock
    echo "$(tail -1000 $LOGFILENAME)" > $LOGFILENAME
    if [ -f ${LockFile} ]; then
        echo  "[ERROR]LockFile detected! FileFlow is already runing" >> $LOGFILENAME
        exit 1
    else
        touch ${LockFile}
        for file in "$SOURCEDIR"/*; do
            _mv "$file"
        done
        rm -rf ${LockFile}
    fi 
}

#===  END OF FUNCTIONS  ========================================================

if  [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    echo 'main run'
    main "$@"
else
    echo "lib"
fi