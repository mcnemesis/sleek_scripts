#!/usr/bin/sh
#---- This script's intent is to delete a LARGE (in Gigs) and possibly MANY collection of files
#---- from a given directory, that are older than a specified timestamp
#----
#---- Version 1.0, Nemesis Fixx : 12th June, 2013
#----   Exploits rsync in for its optimal performance 
#----   (see http://linuxnote.net/jianingy/en/linux/a-fast-way-to-remove-huge-number-of-files.html)

USAGE="$0 TARGET_DIR OLDEST_TIMESTAMP"

if [ -z $1 ]
then
    echo $USAGE
    exit 1
fi

if [ -z $2 ]
then
    echo $USAGE
    exit 1
fi

TARGET_DIR=$1
OLDEST_TIMESTAMP=$2
TMP_DIR=`mktemp -d`
TMP_REFERENCE=`mktemp -d`
TMP_EMPTY=`mktemp -d`

echo "Using the timestamp $OLDEST_TIMESTAMP as threshold"

#first, we assume it's the old files that make the largest size, 
#so we instead deal with the desired newer files first...
echo "Caching Newer files in $TMP_DIR"
#create a reference point...
touch -t $OLDEST_TIMESTAMP $TMP_REFERENCE/new
#copy only newer files using our reference point
find $TARGET_DIR/* -newer $TMP_REFERENCE/new -exec cp -p {} $TARGET_DIR $TMP_DIR \;
#efficiently delete using the rsync trick, to keep only our newer files in the target dir
rsync -a -r --delete $TMP_DIR/ $TARGET_DIR

#clean up
echo "Deleting tmp files : $TMP_DIR $TMP_REFERENCE $TMP_EMPTY"
rsync -a -r -delete $TMP_EMPTY/ $TMP_DIR
rm -r $TMP_DIR $TMP_REFERENCE $TMP_EMPTY
