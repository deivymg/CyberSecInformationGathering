#!/bin/bash
#script shell that calculate repetigions of foler in a file
output_file="combined.csv"
for file in *.txt; do
    if [ -f "$file" ]; then
        #step 1: extract paths from gathering file
        directorios=$(cat "$file"  |sed -n '/============ Archivos encontrados ============/,$p' | awk -F '  ' '{print  $3 }'  | sort -u  | sed 's![^/]*$!!' | sed 's/^[^/]*\///' | sed '/^\s*$/d' | sed 's/^/\//' | sort);
        total=$(cat "$file" |sed -n '/============ Archivos encontrados ============/,$p' | wc -l);
        total=$((total-1));
        #step 2: get directotris with 5 levels
        rootdir='';
        for ((j=5; j<=5; j++)) do
            rootdir+=$(echo "$directorios" | sort -u | grep -E '^(.*\/){'$j',}'| sed 's#^\(\([^/]*\/\)\{'$j'\}\).*#\1#' | sort -u) ;

        done
        rootdir="$(echo "$rootdir" | sed 's#//#\n/#g' | sort -u)";
        #step 3: count ocurrences of each directory and create file ouput
        echo "=== $file ===" >> "$output_file";
        for dir in $rootdir; do
            count=$(echo "$directorios"| grep "$dir"| wc -l);
            echo  "$count"";""$dir">>"$output_file"; 
        done
        echo "TOTAL OF FOUNDED FILES:""$total" >> "$output_file";
    fi
done
