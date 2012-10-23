#!/bin/sh


usage()
{
    {
        echo "$(basename -- $0 ) -o \$ORIGINAL -n \$NEW"
        echo "  o: ORIGINAL-DIR /path/to/templates/ -> default == templates"
        echo "  n: NEW-DIR /path/to/templatesSmarty3/ -> will be create if not exists"

    } 2>&1

}


ORGDIR="templates"
NEWDIR=

#handel incomming vars
while getopts ho:n: OPT; do
    case "$OPT" in
        h) usage; exit 0;;
        o) ORGDIR=$OPTARG;;
        n) NEWDIR=$OPTARG;;
    esac
done
shift $(( $OPTIND - 1 ))


#check vars
if [ -z "$ORGDIR" ] || [ ! -d "$ORGDIR" ]; then
    echo "ORIGINALGDIR can not be empty or is no Directory";
    usage; exit 1;
elif [ -z "$NEWDIR" ]; then
    echo "NEWDIR can not be empty";
    usage; exit 1;
fi
 
# create new dir if not exists
if [ ! -d "$NEWDIR" ]; then 
    mkdir -p $NEWDIR;
fi



for i in $(find $ORGDIR -name "*.tpl"); do 
    NEWFILE=$(echo $i |sed -e "s/${ORGDIR}/${NEWDIR}/g"); 
    DIRS=$(dirname $NEWFILE);
    
    if  [ ! -d $DIRS ]; then
        mkdir -p $DIRS;
    fi
    
    ruby tplsmarty2to3.rb $i >$NEWFILE;

done
