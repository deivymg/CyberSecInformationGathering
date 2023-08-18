#!/bin/bash
#script shell that calculate repetigions of foler in a file
for file in *.txt; do
    if [ -f "$file" ]; then
        #step 1: extract paths from gathering file
        directorios=$(cat "$file"  |sed -n '/============ Archivos encontrados ============/,$p' | awk -F '  ' '{print  $3 }'  | sort -u  | sed 's![^/]*$!!' | sed 's/^[^/]*\///' | sed '/^\s*$/d' | sed 's/^/\//' | sort);
        #step 2: get directotris with 5 levels
        rootdir='';
        for ((j=2; j<=5; j++)) do
            rootdir+=$(echo "$directorios"| grep -E '([^/]*\/){'$j',}' | awk -F/ 'BEGIN{OFS="/"} {for(i=1; i<='$j'; i++) printf "%s%s", $i, (i=='$j' ? "\n" : "/")}' | sort -u  | sed 's/$/\//' );
        done
        #step 3: count ocurrences of each directory
        for dir in $rootdir; do
            count=$(echo "$directorios"| grep "$dir"| wc -l);
            echo  "$count"";""$dir">>"$file"".csv"; 
            #echo  'echo $directorios | grep -ic "'$dir'"';
        done

         #cat "$file" >> "$outputfile"
    fi
done