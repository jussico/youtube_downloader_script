#!/bin/bash

# get youtube-dl
function lataa_youtube_dl() {
    if [[ -d bin ]]
    then
        echo "bin/ already exists. not downloading youtube-dl."
    else
        mkdir bin/
        if [[ "$OS" == "Windows_NT" ]]; then # elif [[ "$OSTYPE" == "msys" ]]; then
            # Windows 10 with Msys2
            echo "info: downloading Windows youtube-dl."
            curl -L https://yt-dl.org/latest/youtube-dl.exe -o bin/youtube-dl.exe
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Ubuntu 20.04 and such
            echo "info: downloading Linux youtube-dl."
            curl -L https://yt-dl.org/downloads/latest/youtube-dl -o bin/youtube-dl
            chmod a+rx bin/youtube-dl
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS (?not tested..)
            curl -L https://yt-dl.org/downloads/latest/youtube-dl -o bin/youtube-dl
            sudo chmod a+rx bin/youtube-dl    
        fi
    fi
    if [[ "$OS" == "Windows_NT" ]]; then # elif [[ "$OSTYPE" == "msys" ]]; then
        # Windows 10 with Msys2
        lataa='bin/youtube-dl.exe'
        echo "info: Windows command: ${lataa}"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Ubuntu 20.04 and such
        export lataa='bin/youtube-dl'
        echo "info: Linux command: ${lataa}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS (?not tested..)
        lataa='bin/youtube-dl'
        echo "info: macOS command: ${lataa}"
    fi
}

function lataile_videoita() {
    echo "ladataan videoita tiedostosta $1"
    mkdir -p files
    while IFS= read -r line
    do
        echo "info: downloading: $line"
        #$lataa -F "$line"   # list available formats
        $lataa -f best -o files/'%(title)s.%(ext)s' "$line" # the best (and probably only one with video and audio)
    done < "${1}"
    # done < "some_videos.txt"
}

# function lataile_audioita() {
#     mkdir -p files
#     while IFS= read -r line
#     do
#         echo "info: downloading: $line"
#         #$lataa -F "$line"   # list available formats
#         $lataa -f bestaudio -o files/'%(title)s.%(ext)s' "$line" # the best audio
#     done < "some_audios.txt"
# }

if [[ -z "$1" ]]
then
    echo "no argument given"
    exit 1
fi

lataa_youtube_dl
lataile_videoita "$1"
# lataile_audioita
