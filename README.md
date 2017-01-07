# CaptainHook

Captain Hook provides a system for catching files pre-commit and generating meaningful diffs for non-text files where versioning is important.


## installation

`python install.py`


## usage

`$ caphook handlers --add [extension] [/path/to/script.sh]`  
`$ caphook handlers --rem [extension]`  
`$ caphook differs --add [extension] gh [/path/to/custom/diff/module]`  
`$ caphook differs --rem [extension]`  


## example



### Grasshopper file

`gh.sh`

```

```