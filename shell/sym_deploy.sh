#!/usr/bin/env bash
# Symlink Deploy:
# Parameters:
#   APPNAME   : Application name, corresponding to document root
#   VERSION   : The version of the application
#   ARTIFACT(optional)  : 
#        - The path to the artifact, in target machine.
#        - Default to production shared directory.
#
APPNAME=$1
VERSION=$2
TRIPLEDOUBLEYOU=/var/www
APPVERSION=${APPNAME}_${VERSION}
DEPLOY_DIR=$TRIPLEDOUBLEYOU/$APPVERSION
PKG=${3-$(ls /root/packages/${APPNAME}.*)} ## Optional 3rd parameter

[ ! $PKG ] && echo "Could not find artifact! in ${PKG}" && exit -9

export APPNAME
export VERSION
export APPVERSION
export DEPLOY_DIR
export PKG

check_rv() {
  local __rv=$1
  [ "$__rv" != "0" ] && echo "NOK. Aborting the deployment." && exit $__rv || echo "OK"
}

get_extract_command() {
  local __file=$1 # Artifact
  local __dest=$2 # Destination folder

  EXT=$(echo $(basename $__file) | sed "s/${APPNAME}//g")

  case $EXT in
    ".zip")
      export EXTRACT_COMMAND=$(printf "unzip -qo %s -d %s" $__file $__dest)
      ;;
    ".tar.gz")
      export EXTRACT_COMMAND=$(printf "tar xfz %s -C %s" $__file $__dest)
      ;;
  esac

  echo $EXTRACT_COMMAND
}

additional_deploy_command() {
  # I am looking for additional_deploy_command.sh then execute it
  if [ -f ./additional_deploy_command.sh ]; then
    bash -e ./additional_deploy_command.sh
    check_rv $?
  else
    echo "Skipping additional deploy command"
  fi
}

# Go to /var/www
cd $TRIPLEDOUBLEYOU

# Check version
[ -d $APPVERSION ] && echo "Application: ${APPNAME}, version ${VERSION} is already deployed" && exit

# Get Previous version
PREVIOUS_VERSION=$(readlink ${APPNAME})
PREVIOUS_PREVIOUS_VERSION=$(readlink previous-${APPNAME})

# Create directory for current version deployment
echo "Creating deployment target @ ${DEPLOY_DIR}"
mkdir -p $DEPLOY_DIR
check_rv $?

# Extract to that directory
echo "Extracting artifact @ ${PKG} to: ${DEPLOY_DIR}"
INFLATE=$(get_extract_command $PKG $DEPLOY_DIR)
$INFLATE
check_rv $?

additional_deploy_command

# Update symlink to current version
if [ -d $APPVERSION ]; then
  if [ -L $APPNAME ]; then
    echo "Removing old link"
    unlink $APPNAME
    check_rv $?
  fi

  echo "Updating link"
  ln -sf $APPVERSION $APPNAME
  check_rv $?
else
  echo "Something went wrong during deployment"
fi

# Check old files and delete when it's more than 2
INSTALLED_APPS=$(find ${TRIPLEDOUBLEYOU} -type d -name "${APPNAME}_*" -maxdepth 1)
TOKEEP=2
NUM=$(echo ${INSTALLED_APPS} | wc -w)
if [ $NUM -gt $TOKEEP ];then
  TODELETE=$(expr $NUM - $TOKEEP)
  echo "Deleting old files:"
  VERSION_TODELETE=$(find ${TRIPLEDOUBLEYOU} -type d -name "${APPNAME}_*" -maxdepth 1 -print | cut -d _ -f2 | sort -g | head -n $TODELETE)
  for ver in $VERSION_TODELETE; 
  do
    DIR=${APPNAME}_${ver}
    echo "Deleting ${DIR} :"
    rm -rf ${DIR}
    check_rv $?
  done
fi

[ "$?" == "0" ] && echo "KTHXBYE!"
