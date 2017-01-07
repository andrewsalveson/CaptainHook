# process arguments "$1", "$2", ... (i.e. "$@")
while getopts "ab:" opt; do
    case $opt in
    a) aflag=true ;; # Handle -a
    b) barg=$OPTARG ;; # Handle -b argument
    \?) ;; # Handle error: unknown option or missing required argument.
    esac
done