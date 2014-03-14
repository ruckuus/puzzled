#!/bin/bash -x
# Watermark image using imagemagick
#
#[ "x$1" == "x" ] && echo "Please specify image file" && exit 1

SRC=`pwd`/src
DST=`pwd`/src
CONVERT=`which convert`
IDENTIFY=`which identify`
WATERMARK=watermark.png

function get_image_size {
  IMG=$1
  SIZ=`$IDENTIFY $1 | awk '{ print $3 }'`
  echo $SIZ
}

function create_watermark_image {
  SIZE=$(get_image_size src/$1)

  # A little bit hacky calc
  # 799x600
  # total char = x
  # point size = p
  # total char siz = x * p
  # x position = 799 - total char siz ~600 
  # y position = 95% * 600 ~ 570
  PADDING=30
  WIDTH=`echo $SIZE | awk -F x '{print $1}'`
  HEIGHT=`echo $SIZE | awk -F x '{print $2}'`
  TPOSX=30
  TPOSY=`expr ${HEIGHT} - ${PADDING}`
  
  $CONVERT -size ${SIZE} xc:transparent -font UbuntuBI -pointsize 25 -fill White -draw "text ${TPOSX},${TPOSY} '© BOSF & RHOI 2013'" $WATERMARK

}

# Watermarking image
function do_composite {
  SRC=$1
  OUTPUT=$2
  composite -dissolve 50% -quality 100 $SRC $WATERMARK $OUTPUT
}

function cleanup_filename {
  find ${SRC} -type f | rename 's/[\ !@#$%^&+=,{}]./_/g'
}

function do_work {
  # Create watermark only once
  #[ ! -e $WATERMARK ] && 
  create_watermark_image $1

  # Preparing output
  echo "Output will be located at dst directory with the same name as original"
  mkdir -p `pwd`/dst
  INPUT=`pwd`/src/$1
  OUTPUT=`pwd`/dst/$1
  do_composite $INPUT $OUTPUT
}

cleanup_filename

for f in `ls ${SRC}`
do
  do_work $f
done

zip -r dst.zip dst
