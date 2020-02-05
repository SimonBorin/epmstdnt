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
            echo "Folder $1 perms are ok"
        else
            echo "Not enough permissions at $1. Try to use sudo."
            exit 1
        fi
    else 
        echo "Error in filepath! $1 doesn't exist or not a directory"
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
    echo $1
    CUR_DATE=$(date +"%Y-%m-%d %H:%M:%S")
    OBJ_NAME=$(awk 'BEGIN{FS="\t"} NR==1 {print $1}' "$1")
    OBJ_DATE=$(awk 'BEGIN{FS="\t"} NR==1 {print $2}' "$1")
    OBJ_UUID=$(awk 'END{if (/^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/) print $1}' second.txt)
    OBJ_NEW_NAME="$OBJ_NAME"_"$OBJ_DATE"_"$CUR_DATE"
    if [ ! -z "$OBJ_UUID" ]&&[ ! -d "$1" ]; then
        mv $1 "$TARGETDIR"/"$OBJ_NEW_NAME"
        echo "$1 moved to $TARGETDIR and renamed to $OBJ_NEW_NAME" >> $LOGFILENAME
    else
        echo "File $1 is not redy! UUID wasn't detected ( or it's just a dir ooopsy =D )" >> $LOGFILENAME
    fi 
    unset OBJ_UUID
}

#===  FUNCTION  ================================================================
#         NAME:  main
#  DESCRIPTION:  main func
#===============================================================================

function main() {
    _read_config
    touch $LOGFILENAME 
    echo date >> $LOGFILENAME
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
        echo  "LockFile detected! FileFlow is already runing" >> $LOGFILENAME
        exit 1
    else
        touch ${LockFile}
        for file in "$SOURCEDIR"/*; do
            echo "this is my file ==== $file"
            # FILEFLOWPATH="$SOURCEDIR"/"$file"
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