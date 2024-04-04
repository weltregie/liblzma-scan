#!/bin/bash

# Pfad, in dem nach Dateien gesucht werden soll. Wurzelverzeichnis als Standard.
search_path="/"

# Datei mit den SHA256-Summen
hash_file="hashes.txt"

# Farbcodes
red='\033[0;31m'
green='\033[0;32m'
no_color='\033[0m' # Keine Farbe

# Überprüfen, ob die Datei hashes.txt existiert
if [ ! -f "$hash_file" ]; then
    echo "Die Datei $hash_file wurde nicht gefunden!"
    exit 1
fi

# Schritt 1: Ermitteln aller Dateien mit dem Muster "liblzma*" im angegebenen Pfad,
# wobei /proc /run /afs /home (und alles darunter) ausgeschlossen werden.
find "$search_path" \( -path "/proc" -o -path "/proc/*" -o -path "/run" -o -path "/run/*" \) -prune -o -type f -name "liblzma*" -print | while read -r file; do
    # Schritt 2: Bilden der SHA256-Summe der gefundenen Dateien
    sha256sum=$(sha256sum "$file" | awk '{print $1}')

    # Schritt 3 und 4: Abgleichen der SHA256-Summe mit den Werten in der Datei hashes.txt
    if grep -q "$sha256sum" "$hash_file"; then
        echo -e "${red}************ VERDACHT AUF BACKDOOR in $file *************${no_color}"
    else
        echo -e "${green}$file unproblematisch${no_color}"
    fi
done 
