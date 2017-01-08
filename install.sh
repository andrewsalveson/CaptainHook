#!/bin/sh
prepush="./.git/hooks/pre-push"
payload=$(<filter.sh)
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