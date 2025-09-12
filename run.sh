#! /bin/bash

#Optional microphone variable.  If not specified, listen on default input
ARG1=${1:-default}

cp ./lower-template.ily ./lower.ily
cp ./upper-template.ily ./upper.ily
cp ./input-template.txt ./input.txt
cp ./input-template.txt ./log.txt 
cp ./ly-display-template.pdf ./ly-display.pdf

# setup emacs
# rm speech.mp3 before running command because flush old content
emacsclient -a "" -n "./input.txt"
emacsclient --eval "(define-minor-mode toggle-listening-mode
  \"Start or stop listening to output for transcription with whisper.\"
  :global f
    (if toggle-listening-mode
	    (progn
	    (message \"started listening\")
	    (async-shell-command \"rm -f ./speech.mp3 && ffmpeg -y -f alsa -i ${ARG1} ./speech.mp3 > ./log.txt 2>&1\"))
	    (progn
	    (message \"stopped listening\")
     	    (async-shell-command \"./run-whisper-input.sh > ./log.txt 2>&1 && lilypond ./lily-run-scheme.ly > ./log.txt 2>&1\")
	    )))"
emacsclient --eval "(with-current-buffer \"input.txt\" (local-set-key (kbd \"SPC\") 'toggle-listening-mode))"

echo "Emacs listening-mode initiert, bundet til SPC og satt opp til å lytte på ALSA-input: $ARG1"
