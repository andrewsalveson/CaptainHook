# CaptainHook

Captain Hook provides a system for handling files pre-push.

## usage

### installation

run `./caphook.sh install` in git repository root. The installation script creates or adds to the `.git/hooks/pre-push` script file, and creates and populates the `.git/caphook` folder.  

### removal

remove Captain Hook with the command `./caphook.sh remove`

Once installed, add a handler to your git hook with the `add` command:

`$ caphook.sh add [extension] [http://domain.com:port/route]`  

Remove a handler using the `rem` command:

`$ caphook.sh rem [extension]`  

Before executing a push, Captain Hook will check each modified file in the commit against the contents of `.git/caphook/map` to see if its extension matches. If it does, Captain Hook sends the previous version of the file and the current version of the file to the remote service to be diffed. The response is written to `.git/caphook/diff.html`.

### map

Captain Hook stores a map of extensions and handlers in `.git/caphook/map`. Use the command `./caphook.sh map` to see which extensions are mapped to which URLs. An example `map` file might look like this:
```
gh ---> http://pwc01gisdata/VVD
osm ---> http://13.93.214.149:8080/file
dyn ---> http://pwc01gisdata/VVD
```

## example

### OpenStudio Measures File

the command `./caphook.sh install`  
produces:
```
./.git/hooks/pre-push does not exist, creating
made the ./.git/caphook folder
made the ./.git/caphook/temp folder
made the ./.git/caphook/files folder
made the map file
```

the command `./caphook.sh add osm http://13.93.214.149:8080/file`  
produces:
```
.osm files will now be processed through http://13.93.214.149:8080/file on each push
``` 
the git push command `git push`  
produces:
```
Scanning diff for modified files . . .
check osm against osm
examples/test.osm is a osm ---> http://13.93.214.149:8080/file
http://13.93.214.149:8080/file
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 1383k  100  2284  100 1381k    310   187k  0:00:07  0:00:07 --:--:--     0
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 419 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://github.com/andrewsalveson/CaptainHook
   dddcbcf..d6d26c7  master -> master
```