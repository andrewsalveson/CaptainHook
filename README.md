# CaptainHook

Captain Hook provides a system for handling files pre-push.


## installation

run `./caphook.sh install` in git repository root. The installation script creates or adds to the `.git/hooks/pre-push` script file, and creates and populates the `.git/caphook` folder.  


## usage

Once installed, add a handler to your git hook with the `add` command:

`$ caphook.sh add [extension] [http://domain.com:port/route]`  

Remove a handler using the `rem` command:

`$ caphook.sh rem [extension]`  

Before executing a push, Captain Hook will check each modified file in the commit against the contents of `.git/caphook/map` to see if its extension matches. If it does, Captain Hook sends the previous version of the file and the current version of the file to the remote service to be diffed. The response is written to `.git/caphook/diff.html`.


## map

Captain Hook stores a map of extensions and handlers in `.git/caphook/map`. An example `map` file might look like this:
```
gh,http://pwc01gisdata/VVD
osm,http://13.93.214.149:8080/file
dyn,http://pwc01gisdata/VVD
```

## example

### Grasshopper file

`~/repo $ ./caphook.sh install`  
```
./.git/hooks/pre-push does not exist, creating
made the ./.git/caphook folder
made the ./.git/caphook/temp folder
made the ./.git/caphook/files folder
made the map file

```
`~/repo $ ./caphook.sh add osm http://13.93.214.149:8080/file`  
```
.osm files will now be processed through http://13.93.214.149:8080/file on each push
``` 
(edit .gh file)  
`~/repo $ git add --all :/`  
`~/repo $ git commit -m "I edited a file"`  
`~/repo $ git push origin master`  
```
 > caphook says: a gh file was sent to 13.93.214.149
 > -- 13.93.214.149 says: diff generated and returned
 > -- diff image received
```