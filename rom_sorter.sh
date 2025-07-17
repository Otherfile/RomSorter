#!/bin/bash

clear


echo "Searching for Gamecube roms..."

# One-line rainbow for fun :)
for ((i = 0; i < 45; i++)); do
    color=$((160 + i % 36))
    printf "\033[38;5;%sm-\033[0m" "$color"
done
echo



# echo "--------------------------------------------"


XMLDB="wiitdb.xml"  # Using GameTDB's XML to search for rom data

find . -maxdepth 1 -name "*.iso" | while read -r file; do
    romSum=$(sha1sum "$file" | awk '{print $1}')


    xpath="//rom[@sha1='$romSum']"
    result=$(xmllint --xpath "$xpath" "$XMLDB" 2>/dev/null)

    if [[ -n "$result" ]]; then
        gameName=$(xmllint --xpath "string(//game[rom[@sha1='$romSum']]/@name)" "$XMLDB" 2>/dev/null)
        echo
        gameName=$(echo "${gameName}" | sed 's/ *([^)]*)//g')
        gameName=$(echo "${gameName}" | sed 's/ *\[[^]]*\]//g')
        gameName="${gameName//\//}"
        gameName=$(echo "${gameName}" | sed 's/[:!]//g')
        gameName=$(echo "${gameName}" | sed 's/[$]/s/g')
        gameName=$(echo "${gameName}" | sed 's/[&]/and/g')
        gameName=$(echo "${gameName}" | sed 's/  */ /g')

        

        gameID=$(xmllint --xpath "string(//game[rom[@sha1='$romSum']]/id)" "$XMLDB" 2>/dev/null)
        echo "Game Name: $gameName"
        echo "Game ID: $gameID"
    else
        echo "No match found for SHA-1: $romSum"
    fi

   
for ((i = 0; i < 45; i++)); do
    color=$((160 + i % 36))
    printf "\033[38;5;%sm-\033[0m" "$color"
done
echo

    echo "Creating Directory for $gameName"
    dirname="${gameName} [${gameID}]"
    mkdir -p "$dirname"
    echo "Done!"
    echo "Moving current rom into directory and renaming..."
    mv "$file" "$dirname/game.iso"
    echo "Done!"

    for ((i = 0; i < 10; i++)); do
    color=$((160 + i % 36))
    printf "\033[38;5;%sm-\033[0m" "$color"
done
echo
    
    # echo "--------------------------------------------"
    

done

# echo "Completed!"

read -n 1 -s -r -p "Completed! Press any key to exit..."

echo
echo

exit
