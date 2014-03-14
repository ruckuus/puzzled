#!/bin/bash 
# @author: Dwi Sasongko S <ruckuus@gmail.com>

TEMPLATE_NAME=templates.lst
TEMP_TEMPLATE_NAME=/tmp/$(mktemp template-XXXXX).lst
YUI=`pwd`'/home/dwi/yuicompressor-2.2.5.jar'

cleanup () {
    rm -rf $REVISION template-*
    git checkout master
    git branch -D $WS
    exit -99
}

show_usage () {
    echo -ne "./build_thing <hash commit>\n"
    echo -ne "./build_thing <hash commit>..<hash_commit>\n"
    cleanup
}

function get_from_repo {
    file=$(basename $1)
    file_from=$1
    file_to=$1
    mkdir -p $REVISION/changes
    mkdir -p $REVISION/changes/`dirname $file_to`
    cp -av $file_from $REVISION/changes/$file_to
    echo $file_to >> $REVISION/$TEMPLATE_NAME
}


# git branch <hash> ## or the argument of last revision
# git checkout <hash>
# get the files from here
switch_workspace() {
    export WS=${REVISION##*..}
    git branch $WS
    echo git branch $WS
    git checkout $WS && git reset --hard $WS
    echo git checkout $WS
}

build_package () {
    switch_workspace

    if [[ $REVISION == *..* ]]
    then
        git diff $REVISION --name-only > $TEMP_TEMPLATE_NAME
    else
        git diff $REVISION^! --name-only > $TEMP_TEMPLATE_NAME 
    fi

    while read line
    do
        echo -e "\nProcessing: $line"
        get_from_repo $line
    done < $TEMP_TEMPLATE_NAME 
            
    find $REVISION -type f -name "*.js" -exec java -jar $YUI --charset utf-8 {} -o {} \;
    find $REVISION -type f -name "*.css" -exec java -jar $YUI --charset utf-8 {} -o {} \;

    echo "$MESSAGE" > $REVISION/revision
    tar cfvz $REVISION.tar.gz $REVISION

    echo "Cleanup"
    rm -rf $REVISION template-*
    echo "Package available: $REVISION.tar.gz"
}

# $1 is the commit
[ "$1" == "" ] && show_usage && exit

# make sure you're in master
git checkout master
git pull --rebase

export REVISION=$1
export MESSAGE=`git log --format=%B -n 1 --oneline $REVISION`
build_package

