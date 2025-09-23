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

rm -f ly-display.pdf display.pdf

inputlength=$(soxi -D input-speech.wav)

echo "jobber på inndatalydfil som er $inputlength sekunder lang"

textlength=$(wc -c input.txt)

echo "jobber på inndatatekst som er $textlength bokstaver lang lang"


ffmpeg -y -f concat -safe 0 -i files.txt -acodec copy speech.wav
#ffmpeg -y -f concat -safe 0 -i <(printf "file 'speech.wav'\nfile 'input-speech.wav'\n") -acodec copy speech.wav

#ffmpeg -y -i "
#concat:speech.wav|input-speech.wav
#" -acodec copy speech.wav > ./log.txt 2>&1

echo "Lager lily-input fra teksta i lydfila, og kjører lilypond med resulterende input"

soundlength=$(soxi -D speech.wav)

echo "har lagd en lydfil som er $soundlength sekunder lang"


lilypond ./lily-run-scheme-web.ly
#lilypond ./test.ly

chars=$(tr -d '[:space:]' < ./input.txt | wc -c)

midilength=$(($chars * 1000 * 60 / 600 / 1000)) ## calculate length of midifile in seconds by distributing charcount on 184 bpm

if [ "${midilength:-0}" -eq 0 ]; then
    midilength=1
fi

echo $midilength
     
scale=$(echo "scale=2; $soundlength / $midilength" | bc -l)

echo "her er scale:"
echo "$scale"

check=$(echo "$scale < 0.5 || $scale > 2.0" | bc -l)
if [ "${check:-0}" -eq 1 ]; then
    scale=1
    echo "scale ute av range, endrer til 1"
fi

ffmpeg -y -i speech.wav -filter:a "atempo=$scale" speech-scaled.wav > ./log.txt 2>&1

echo "
Åpner midifil, lydfil og pdf
"

cat "guile-outp.txt"

csound -F ly-display.midi ./poly-synth-test.csd > ./log.txt 2>&1 & wait &&

echo "
Partitur generert og lydutdata spilt av
"
#docker run   -v /home/hjallis/.keys/logical-sled-473014-i0-5e82617cf489.json:/app/key.json:ro   -e GOOGLE_APPLICATION_CREDENTIALS=/app/key.json   -p 8000:8000 lily-to-speech:latest 

#docker build -t lily-to-speech .
