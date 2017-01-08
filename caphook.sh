#!/bin/sh

caphookPath="./.git/caphook"
filesPath="./.git/caphook/files"
mapFile="./.git/caphook/map"
prepush="./.git/hooks/pre-push"

command=$1
fileType=$2
handlerScript=$3

echo "command: $command"
echo "file type: $fileType"
echo "handler script: $handlerScript"

install() {
  # payload=$(<filter.sh)
  payload=$(cat<<-'FILTER'
#BEGIN caphook
cat <<\CAPHOOK
Scanning diff for modified files . . .
CAPHOOK

commit=$(git rev-parse HEAD)

echo "commit $commit"

git diff "$commit^" "$commit" --name-status | while read -r flag file ; do
  if [ "$flag" == "M" ]
  then
    filetype=`echo "$file" | cut -d'.' -f2`
    oldIFS=${IFS}
    declare -A assoc
    while IFS=, read -r -a array
    do 
      ((${#array[@]} >= 2 )) || continue
      assoc["${array[0]}"]="${array[@]:1}"
    done < .git/caphook/map
    for key in "${!assoc[@]}"
    do
      echo "check $filetype against ${key}"
      if [ "$filetype" == "${key}"   ]
      then
        echo "$file is a ${key} ---> ${assoc[${key}]}"
        echo ${assoc[$key]}
        .git/caphook/handler.sh "${assoc[$key]}" $file
      fi
    done
    IFS=${oldIFS}
  fi;
done

  # git diff --cached --name-status | awk '$1 == "M" { print "$2 was modified" }'

#END caphook
FILTER
)
  if [ -f "$prepush" ]
  then
	echo "$prepush already exists"
	if fgrep '#BEGIN caphook' "$prepush"
	then
	  echo "captain hook already added to $prepush"
	else
      echo "appending caphook to $prepush"
      echo "$payload" >> "$prepush"
    fi
  else
    echo "$prepush does not exist, creating"
    printf "%s\n" "#!/bin/sh" "$payload" > "$prepush"
  fi
  if ! [ -d "$caphookPath" ]; then
	mkdir $caphookPath
	echo "made the $caphookPath folder"
  fi
  if ! [ -d "caphookPath/temp" ]; then
  mkdir "$caphookPath/temp"
  echo "made the $caphookPath/temp folder"
  fi
  cat <<-'HANDLER' > "$caphookPath/handler.sh"
#!/bin/sh
url=${1%$'\r'}
file=$2
filetype=`echo "$file" | cut -d'.' -f2`
git show HEAD~1:$file > .git/caphook/temp/old.$filetype
case $filetype in
  gh)
    url="$url/gh" ;;
  osm) 
    url="$url/osm" ;;
  \?)
    ;;
esac
curl \
  -F "model=@.git/caphook/temp/old.$filetype" \
  -F "compare=@$file" \
  "$url" > output.html
HANDLER
  # cp handler.sh "$caphookPath/"
  if ! [ -d "$filesPath" ]; then
	mkdir $filesPath
	echo "made the $filesPath folder"
  fi
  if ! [ -f "$mapFile" ]; then
	echo "\n" > $mapFile
	echo "made the map file"
  fi
}
  
add() {
  newLine="$fileType,$handlerScript&\n"
  sed -i "1s#^#$newLine#" $mapFile
  echo ".$fileType files will now be processed through $handlerScript on each push";
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

echo ".$fileType files will no longer be processed on each push";
}

$@ # call arguments verbatim