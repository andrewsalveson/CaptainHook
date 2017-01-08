#BEGIN caphook
cat <<\CAPHOOK
Scanning diff for modified files . . .
CAPHOOK
oldIFS=${IFS}
declare -A assoc
while IFS=, read -r -a array
do 
  ((${#array[@]} >= 2 )) || continue
  assoc["${array[0]}"]="${array[@]:1}"
done < ./map
for key in "${!assoc[@]}"
do
  echo "${key} ---> ${assoc[${key}]}"
done
IFS=${oldIFS}

for blah in $(git diff --cached --name-status); do
  echo "checking $blah"
done

  git diff --cached --name-status | awk '$1 == "M" { print "$2 was modified" }'



#END caphook