#!/bin/bash
REVISION=""
SPRINT=""
MINOR=`expr $(expr $(date "+%V") % 2) + $(expr $(date "+%V") / 2) + 8`
MESSAGE='Sprint-%s: Release created @ '`date`
RELEASE_PREFIX=release
[[ $2 =~ [0-9]+ ]] && PATCH_LEVEL=$2 || PATCH_LEVEL=0 ;

function show_usage {
    echo -e "create_release <last revision> <optional patch level>"
    exit 1
}

function get_sprint_number {
    MAJOR='1'
    #PATCH_LEVEL=0
    PATCH=`git log -1 --pretty=format:%h`
    echo "Version = "$MAJOR'.'$MINOR'.'$PATCH_LEVEL'-'$PATCH
    export SPRINT=$MAJOR'.'$MINOR'.'$PATCH_LEVEL
}

function do_the_tag {
    get_sprint_number
    export TAGNAME=r-$SPRINT
    git tag -a $TAGNAME -m `printf ${MESSAGE} ${MINOR}` $REVISION
}

function do_create_release_branch_and_push {
    RELEASE_BRANCH=$RELEASE_PREFIX-$SPRINT
    git checkout -b $RELEASE_BRANCH r-$SPRINT
    git push origin $RELEASE_BRANCH
}

function main {
    export REVISION=$1

    git add .
    git stash
    git checkout master
    git add .
    git stash
    git pull --rebase

    do_the_tag

    git push origin $TAGNAME

    do_create_release_branch_and_push
}

[ "x"$1 == "x" ] && show_usage

main $1 
