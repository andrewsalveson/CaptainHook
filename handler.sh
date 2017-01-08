#!/bin/sh
filetype=$1
url="13.93.214.149:8080/file"
case $1 in
  gh)
    url="$url/gh"
    ;;
  osm) 
    url="$url/osm"
    ;;
  \?)
    ;; # Handle error: unknown option or missing required argument.
esac

echo $url

cat examples/test.osm

curl \
  -F "model=@examples/test.osm" \
  -F "compare=@examples/test2.osm" \
  $url > output.html