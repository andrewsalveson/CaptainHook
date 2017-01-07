# CaptainHook

Captain Hook provides a system for catching files pre-commit and generating meaningful diffs for non-text files where versioning is important.


## installation

run `caphook.sh install` in git repository root


## usage

`$ caphook.sh url [all|extension] [http://domain.com:port/service]`  
`$ caphook.sh add [extension] [/path/to/script.sh]`  
`$ caphook.sh rem [extension]`  


## example

### Grasshopper file

`/repo $ caphook.sh install`  
`> captain hook git hook installed`  
`/repo $ caphook.sh url http://13.93.214.149/`  
`> service url set to http://13.93.214.149/`  
`/repo $ caphook.sh add gh`  
`> gh files will be submitted to http://13.93.214.149/`
(edit .gh file)  
`/repo $ git add --all :/`  
`/repo $ git commit -m "I edited the graph"`  
`/repo $ git push origin master`  
`> caphook says: a gh file was sent to 13.93.214.149`  
`> -- 13.93.214.149 says: diff generated and returned`
`> -- diff image received`  
