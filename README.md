# CaptainHook

Captain Hook provides a system for handling files pre-push. You can specify file extensions that should be handled pre-push, and pipe them to a remote service or a local program or script.  

Meaningful responses from services or local programs will get added to an HTML diff report that is stored within the git folder under the commit hash at `.git/caphook/diffs/[diff hash].html`

## usage

### installation

run `./caphook.sh install` in git repository root. The installation script creates or adds to the `.git/hooks/pre-push` script file, and creates and populates the `.git/caphook` folder.  

Captain Hook creates these files:

```
.git
  +-- hooks
  | `-- pre-push   // adds a hook to this file or creates it
  `-- caphook      // root folder
    +-- diffs      // diff reports go here
    +-- temp       // for temporary storage
    +-- handler.sh // file handler script
    +-- map        // extension -> handler mappings
    `-- state      // on/off state of the Captain
```

### enable/disable

Turn Captain Hook on or off with the commands `./caphook.sh on` and `./caphook.sh off` 

### removal

remove Captain Hook with the command `./caphook.sh remove` - this will delete ALL mappings.

### handlers

Once installed, add a file extension handler to your git hook with the `add` command:

`$ caphook.sh add [extension] [http://domain.com:port/route|/path/to/script]`  

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

### Grasshopper and OpenStudio Measures File

first I'll install Captain Hook: `./caphook.sh install`  
returns:
```
./.git/hooks/pre-push does not exist, creating
made the ./.git/caphook folder
made the ./.git/caphook/temp folder
made the ./.git/caphook/files folder
made the map file
```

I'm going to add an OSM handler: `./caphook.sh add osm http://13.93.214.149:8080/file` returns:
```
.osm files will now be processed through http://13.93.214.149:8080/file on each push
``` 

I will also add a Grasshopper(.gh) handler, which is a local script on my system: `./caphook.sh add gh /c/projects/hackathon/VVD-server/VVD/diffgraphgh.cmd`  
returns:
```
.gh files will now be processed through /c/projects/hackathon/VVD-server/VVD/diffgraphgh.cmd on each push
```
I have made some edits to a grasshopper file as well as an OSM file, so both will be seen when the Captain sifts through the commit.  

The git push command `git push` starts the Captain:
```
$ git push origin master
Scanning diff for modified files . . .
```
then Captain Hook handles the specific file type
```
examples/example.gh is a gh ---> /c/projects/hackathon/VVD-server/VVD/diffgraphgh.cmd

-- Captain Hook is handling a file -----------

sending file to local executable for handling
The system cannot find the path specified.
The system cannot find the path specified.
python: can't open file 'diffgraph.py': [Errno 2] No such file or directory

----------------------------------------------
```
Here the target script threw a bunch of errors. No worries, the Captain is on to the next file:
```
examples/test.osm is a osm ---> http://13.93.214.149:8080/file

-- Captain Hook is handling a file -----------

sending file to remote service for handling
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 1384k  100  3329  100 1381k    459   190k  0:00:07  0:00:07 --:--:--     0

----------------------------------------------

see diff results at .git/caphook/diffs/2cbacafa54cf3d1c4d04780c751ffcc2956a83d7.html
```
This one got some meaningful results, which have been placed in [the file shown above](https://raw.githubusercontent.com/andrewsalveson/CaptainHook/master/examples/2cbacafa54cf3d1c4d04780c751ffcc2956a83d7.html). Git then continued with the push:
```
Counting objects: 5, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 2.39 KiB | 0 bytes/s, done.
Total 5 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://github.com/andrewsalveson/CaptainHook
   75a7232..2cbacaf  master -> master
```