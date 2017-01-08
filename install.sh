#!/bin/sh
precommit="./.git/hooks/pre-commit"
payload=$(<filter.sh)
if [ -f "$precommit" ]
then
  echo "$precommit already exists"
  if fgrep '#BEGIN caphook' "$precommit"
  then
    echo "captain hook already added to $precommit"
  else
    echo "appending caphook to $precommit"
    echo "$payload" >> "$precommit"
  fi
else
  echo "$precommit does not exist, creating"
  printf "%s\n" "#!/bin/sh" "$payload" > "$precommit"
fi