#!/bin/sh

mapFile="./map"
command=$1
fileType=$2
handlerScript=$3

  echo "command: $command"
  echo "file type: $fileType"
  echo "handler script: $handlerScript"

add() {
  newLine="$fileType,$handlerScript&\n"
  sed -i "1s/^/$newLine/" $mapFile
  echo ".$fileType files will now be processed through $handlerScript on each commit";
}

rem() {
declare -i lineCount=0

# Set "," as the field separator using $IFS and read line by line using while read combo
while IFS=',' read f1 f2 
do 
  lineCount=$lineCount+1
  if [ "$fileType" = "$f1" ]
  then
	echo "$fileType found on line $lineCount"
	sed -i "$lineCount d" $mapFile
  fi  
done < $mapFile

echo ".$fileType files will no longer be processed on each commit";
}

$@ # call arguments verbatim
read -n1 -p "Press any key to exit..." key