#!/usr/bin/sh
# for simplicity, we'll only create 2 files with timestamps in 2 different yrs
# the requirement is to see our special rm script rm the older file from the test
# dir and leave only the newer one, based on our specified threshold parameter...

#clean
TEST_DIR='test'
CONTROL_DIR='all'
rm -r $TEST_DIR $CONTROL_DIR
mkdir $TEST_DIR $CONTROL_DIR

#our sample file timestamps
TIMESTAMPS=( 201306010600 201206010600 201106010600 )
#our sample files...
for t in "${TIMESTAMPS[@]}"
do
    touch -t $t $TEST_DIR/$t.txt
    touch -t $t $CONTROL_DIR/$t.txt
done

#our threshold timestamp
THRESHOLD_TIMESTAMP=201301010000

echo "Shall keep all generated files in $CONTROL_DIR"
echo "Shall keep ONLY required files in $TEST_DIR"

#the special rm script
SCRIPT='./rm_older_than.sh'

#test...
$SCRIPT $TEST_DIR $THRESHOLD_TIMESTAMP
