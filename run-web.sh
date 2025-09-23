#! /bin/bash

##TODO PLASSÉR NOTER PÅ PARTITURLINJE IFØLGE ORDKLASSE.  

##TODO - sett miditempo til lydfilslengde/antall bokstaver i lydfila - DONE
##TODO - spill av lydfil samtidig som csound-synth -DONE

#Optional microphone variable.  If not specified, listen on default input
#ARG1=${1:-default}

# setup emacs
# rm speech.mp3 before running command because flush old content

#echo "begynner å lytte"
#rm -f ./input-speech.mp3
#ffmpeg -y -f alsa -i ${ARG1} ./input-speech.mp3 > ./log.txt 2>&1 &

#sleep 8

echo "
slutter å lytte, begynner whisper-analyse
"

./run-whisper-input-web.sh # stopper ffmpeg og kjører whisper på lydfila

echo "
Whisper klar
"



ffmpeg -y -i "
concat:speech.mp3|input-speech.mp3
" -acodec copy speech.mp3 > ./log.txt 2>&1

echo "Lager lily-input fra teksta i lydfila, og kjører lilypond med resulterende input"

lilypond ./lily-run-scheme.ly > ./log.txt 2>&1

soundlength=$(soxi -D ./speech.mp3)
chars=$(tr -d '[:space:]' < ./input.txt | wc -c)
midilength=$(($chars * 1000 * 60 / 600 / 1000)) && echo $midilength ## calculate length of midifile in seconds by distributing charcount on 184 bpm
scale=$(echo "scale=2; $soundlength / $midilength" | bc -l)

echo "her er scale:"
echo "$scale"

if [ $(echo "$scale < 0.5 || $scale > 2.0" | bc -l) -eq 1 ]; then
    scale=1
    echo "scale ute av range, endrer til 1"
fi

ffmpeg -y -i speech.mp3 -filter:a "atempo=$scale" speech-scaled.mp3 > ./log.txt 2>&1

echo "
Åpner midifil, lydfil og pdf
"

xdg-open ./ly-display.pdf & csound -F ly-display.midi ./poly-synth-test.csd > ./log.txt 2>&1 & wait && echo "
Alle filer spilt av
"
