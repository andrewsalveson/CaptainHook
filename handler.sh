#!/bin/sh
url=${1%$'\r'}
file=$2
filetype=`echo "$file" | cut -d'.' -f2`
# echo "$file is a $filetype"
# echo "sending to $url"

git show HEAD~1:$file > .git/caphook/temp/old.$filetype

case $filetype in
  gh)
    url="$url/gh"
    ;;
  osm) 
    url="$url/osm"
    ;;
  \?)
    ;; # Handle error: unknown option or missing required argument.
esac

# echo $url

# cat examples/test.osm

curl \
  -F "model=@.git/caphook/temp/old.$filetype" \
  -F "compare=@$file" \
  "$url" > output.html
  
# bash "$scriptPath" {git/caphook/temp/old.$filetype} $file