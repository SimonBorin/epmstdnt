#!/usr/bin/env bash
#===============================================================================
#
#    DESCRIPTION: One of my first steps at bash scripting
#         AUTHOR: Semen Borin
#         E-MAIL: semen_borin@epam.com
#         GITHUB: https://github.com/SimonBorin/epmstdnt
#        CREATED: 14.01.2020
#
#===============================================================================


#===  FUNCTIONS  ===============================================================

#===  FUNCTION  ================================================================
#         NAME:  print_help
#  DESCRIPTION:  Display help information.
#===============================================================================

function _print_help() {
    echo "Just my try of keys"
    echo "Usecase of $MYFUNK with options"
    echo " -t or --template    for file of template"
    echo " -r or --result      for output file"
    echo " -h or --help        for this msg"
}

#===  FUNCTION  ================================================================
#         NAME:  _template_chck
#  DESCRIPTION:  check template 
#===============================================================================

function _template_chck() {
    if [[ -n $1 ]] ; then
        # PREP_TEMPLATE=$(echo $TEMPLATE | sed 's/ /\\ /g')
        if [[ -e "$1" ]]; then
            echo "File $1 exists"
            if [[ -a "$1" ]]; then
                echo "File $1 is readable"
            else
                _echoerr "Cannot read the file $1"
                exit 1
            fi
        else
            _echoerr "File $1 does not exist"
            exit 1
        fi
    else 
        _echoerr "Error in filepath of args! Run $MYFUNK with -h option"
        exit 1
    fi
}

#===  FUNCTION  ================================================================
#         NAME:  _result_create
#  DESCRIPTION:  create dirs and file for result
#===============================================================================

function _result_create() {
    if [[ -n $1 ]] ; then
        if install -Dv /dev/null "$1"; then
            echo "Result file $1 created"
        else
            _echoerr "Cannot create result file $1"
            exit 1
        fi
    else 
        _echoerr "Error in filepath of args! Run $MYFUNK with -h option"
        exit 1
    fi
}

#===  FUNCTION  ================================================================
#         NAME:  replace
#  DESCRIPTION:  replaces vars in custom patterns to its values
#===============================================================================

function replace(){
    BEGIN_PTRN="{{"
    END_PTRN="}}"
    _template_chck $1
    _result_create $2

    sed "s/$BEGIN_PTRN\([^$END_PTRN]*\)$END_PTRN/$\1/g" $1 > $2 
    eval "echo \"$(cat $2)\"" > $2
    # sed 's/{{\([^}}]*\)}}/$\1/g'
    # eval "echo \"$(cat $myFile)\""
}

#===  FUNCTION  ================================================================
#         NAME:  _echoerr
#  DESCRIPTION:  puts msg to STDERR and log file
#===============================================================================
function _echoerr() { 
    echo "$@" 1>&2
    }

#===  FUNCTION  ================================================================
#         NAME:  main
#  DESCRIPTION:  main func
#===============================================================================

#-----------------------------------------------------------------------
#  Handle command line arguments
#  With help of stackoverflow
#  https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#  I would prefer to use getopts however it could work only with one dash in case:  h|help )  print_help ;;
#-----------------------------------------------------------------------
function main(){
    MYFUNK="$0"
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -t|--template )
        TEMPLATE="$2"
        shift # past argument
        shift # past value
        ;;
        -r|--result )
        RESULT="$2"
        shift # past argument
        shift # past value
        ;;
        -h|--help)
        _print_help
        shift # past argument
        ;;
        *)    # unknown option
        _echoerr "Unknown option: $1"
        _echoerr "Run $0 with -h for help"
        # should add exit code
        shift # past argument
        exit 1
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    echo "TEMPLATE  = ${TEMPLATE}"
    echo "RESULT    = ${RESULT}"
    #echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
    if [[ -n $1 ]]; then
        echo "Last line of file specified as non-opt/last argument:"
        tail -1 "$1"
    fi

    replace $TEMPLATE $RESULT
}

#===  END OF FUNCTIONS  ========================================================

if  [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    echo 'main run'
    main "$@"
else
    echo "lib"
fi
