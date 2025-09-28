#! /bin/bash

##TODO PLASSÉR NOTER PÅ PARTITURLINJE IFØLGE ORDKLASSE.  

##TODO - sett miditempo til lydfilslengde/antall bokstaver i lydfila - DONE
##TODO - spill av lydfil samtidig som csound-synth -DONE

#Optional microphone variable.  If not specified, listen on default input
#ARG1=${1:-default}

rm -f ly-display.pdf

inputlength=$(soxi -D input-speech.wav)
inputsr=$(soxi -r input-speech.wav)

echo "jobber på inndatalydfil 1 som er $inputlength sekunder lang, med sample rate på $inputsr"

inputlength=$(soxi -D speech.wav)
inputsr=$(soxi -r speech.wav)

echo "jobber på inndatalydfil 2 som er $inputlength sekunder lang, med sample rate på $inputsr"


textlength=$(wc -c input.txt)

echo "jobber på inndatatekst som er $textlength bokstaver lang lang"

mv speech.wav temp-speech.wav && sox temp-speech.wav input-speech.wav speech.wav & wait && echo "sammenstilte lydfiler"

echo "Lager lily-input fra teksta i lydfila, og kjører lilypond med resulterende input"


soundlength=$(soxi -D speech.wav)
soundsr=$(soxi -r speech.wav)

echo "har lagd en lydfil (speech_wav) som er $soundlength sekunder lang, med samplerate på $soundsr"



lilypond ./lily-run-scheme-web.ly

chars=$(tr -d '[:space:]' < ./input.txt | wc -c)

words=$(wc -w < ./input.txt)

midilength=$(($chars * 1000 * 60 / 184 / 1000)) ## calculate length of midifile in seconds by distributing charcount on 184 bpm

if [ "${midilength:-0}" -eq 0 ]; then
    midilength=1
fi

if [ "${words:-0}" -eq 0 ]; then
    words=1
fi
## avoid dividing with 0


echo $midilength
scale=$(echo "scale=2; $soundlength / $midilength" | bc -l)

echo "her er scale:"
echo "$scale"


## TODO lower tempo of speech properly - done i think?
lengthdiff=($midilength - $soundlength)

paddingdur=$(echo "scale=2; $lengthdiff / $words" | bc -l)
paddings=$(perl -lane 'for (@F) { /(\d+):(\d+):([\d.]+)/; print "'$paddingdur'@" . ($1*3600 + $2*60 + $3) }' < timestamps.txt)    # perl-kommando for omformatering av python-skapte tidskoder

sox speech.wav speech-scaled.wav pad $paddings && csound -d -F ly-display.midi -o output.wav ./poly-synth-web.csd & wait && echo "
Partitur generert og lydutdata skapt
"


level=$(sox speech-scaled.wav -n stats 2>&1 | grep "RMS")
echo "har lagd en lydfil (speech-scaled_wav) som er $soundlength sekunder lang"
echo "lydnivåene er $level"


cat "guile-outp.txt"

#docker run   -v /home/hjallis/.keys/logical-sled-473014-i0-5e82617cf489.json:/app/key.json:ro   -e GOOGLE_APPLICATION_CREDENTIALS=/app/key.json   -p 8000:8000 lily-to-speech:latest 

#docker build -t lily-to-speech .


