#!/bin/bash
set -eou pipefail
# set -x
## Docs Start ##
## Parses yaml into bash variables
## Docs End ##

# Supports objects but not arrays (yet)
parse_yaml() {
   prefix=${2:-""}
   local prefix=${prefix}
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

# eval $(sed -e 's/\(.*\) #.*/\1/g;s/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' ${clusterConfigPath})
