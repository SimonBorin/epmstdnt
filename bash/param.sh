#!/bin/bash
#===============================================================================
#
#    DESCRIPTION: One of my first steps at bash scripting
#         AUTHOR: Semen Borin
#         E-MAIL: semen_borin@epam.com
#         GITHUB: https://github.com/SimonBorin/epmstdnt
#        CREATED: 14.01.2020
#
#===============================================================================


#===  CONSTANTS  ===============================================================

MYFUNK="$0"


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
                echo "Cannot read the file $1"
                exit 1
            fi
        else
            echo "File $1 does not exist"
            exit 1
        fi
    else 
        echo "Error in filepath of args! Run $MYFUNK with -h option"
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
            echo "Cannot create result file $1"
            exit 1
        fi
    else 
        echo "Error in filepath of args! Run $MYFUNK with -h option"
        exit 1
    fi
}

#===  FUNCTION  ================================================================
#         NAME:  main_replace
#  DESCRIPTION:  main func: replaces vars in custom patterns to its values
#===============================================================================

function main_replace(){
    BEGIN_PTRN="{{"
    END_PTRN="}}"
    _template_chck $1
    _result_create $2
    # declare -A vars
    # while read -r line; do
    #     val=$(echo $line | sed "s/$BEGIN_PTRN\([^$END_PTRN]*\)$END_PTRN/$\1/g")
    #     echo $val
    #     # vars[$line]=$line
    #     vars[$line]=$val
    #     done < <(cat test.txt | grep -o '{{[^}}]*}}')    
    # for i in ${vars[@]}; do 
    #     echo  "$i : ${vars[$i]}"
    # done
    # cat test.txt | grep -o '{{[^}}]*}}' > vars.txt

    sed "s/$BEGIN_PTRN\([^$END_PTRN]*\)$END_PTRN/-=$\1==-/g" $TEMPLATE | envsubst > $RESULT

    # sed "s/{{\([^}}]*\)}}/$\1/g" $TEMPLATE >> $RESULT
}

#===  END OF FUNCTIONS  ========================================================

#-----------------------------------------------------------------------
#  Handle command line arguments
#  With help of stackoverflow
#  https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#  I would prefer to use getopts however it could work only with one dash in case:  h|help )  print_help ;;
#-----------------------------------------------------------------------

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
    #shift # past argument
    ;;
    *)    # unknown option
    echo "Unknown option: $1"
    echo "Run $0 with -h for help"
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

main_replace $TEMPLATE $RESULT