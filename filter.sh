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