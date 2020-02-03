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
#         NAME:  main
#  DESCRIPTION:  main func
#===============================================================================

function main() {
    _read_config
}

#===  END OF FUNCTIONS  ========================================================

if  [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    echo 'main run'
    main "$@"
else
    echo "lib"
fi