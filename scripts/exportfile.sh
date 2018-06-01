#!/bin/sh

SOURCE_PATH=`pwd`
OUTPUTFILE_NAME="exportfile.txt"
OUTPUT_PATH=$SOURCE_PATH
FILEEXTENSION=""
FILES=""
OUTPUTFILE_PATH="$OUTPUT_PATH/$OUTPUTFILE_NAME"

function Usage(){
echo """
    Usage:
		-s source path: example /etc/
		-x file extend: example sh,txt
		-o target path: /Users/user/Desktop
		-h help
    Example:
          sh exportfile.sh -s ./ -x sh,less 
"""

}

while getopts "s:x:o:h" arg 
do 
	case $arg in
		s)
			if [ -d "$OPTARG" ];then
				SOURCE_PATH=$OPTARG
			else
				echo "$OPTARG is node a directory"
			fi
			;;
		x)
			FILEEXTENSION="$OPTARG"
			;; 
		o)
			if [ ! -d "$OPTARG" ]
			then
 				 mkdir -p "$OPTARG"
			fi

			OUTPUT_PATH="$OPTARG"
			OUTPUTFILE_PATH="$OUTPUT_PATH/$OUTPUTFILE_NAME"
			;;
		h)
			 Usage
			exit 0
			;;
		*)
			echo "unknown option $arg"
			Usage
			;;
	esac
done

echo "source path:$SOURCE_PATH"
echo "extend: $FILEEXTENSION \n"

function exportFile() {
	# find $SOURCE_PATH -type f > /tmp/file.txt
	touch /tmp/filecontent.txt 
	if [ -f $OUTPUTFILE_PATH ]
	then
		rm $OUTPUTFILE_PATH
	fi
	for i in $(find $SOURCE_PATH -type f)
	do

		FILETYPE=`echo "$i" | awk -F '[.]' '{print $NF}'`
		FILTER=`echo "$FILEEXTENSION" | grep "$FILETYPE"`
		if [ ! -n  "$FILEEXTENSION" ]
		then
			cat $i >> /tmp/filecontent.txt
			echo $i
			echo `cat $i |wc -l`
		elif [ -n "$FILTER" ]
		then
			cat $i >> /tmp/filecontent.txt
			echo $i
			echo `cat $i |wc -l`
		fi
	done
	cp /tmp/filecontent.txt $OUTPUTFILE_PATH
	echo "\033[1;32m \tdone: $OUTPUTFILE_PATH"
	echo "\033[1;32m \ttotal: $(cat $OUTPUTFILE_PATH | wc -l)"
	rm -rf /tmp/file.txt /tmp/filecontent.txt
	exit 0
}
exportFile


