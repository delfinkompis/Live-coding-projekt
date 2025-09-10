#! /bin/bash

# enter venv for whisper to run
source ./.venv/bin/activate

pkill ffmpeg
whisper-ctranslate2 ./speech.mp3 --model small --batched True --batch_size 16 --beam_size 1 --best_of 1 --temperature 0 --vad_filter True --threads 22 --compute_type int8 --language no | sed '1d; $d; s/\[.*\]//g' | { read message; echo "(with-current-buffer \"input.txt\" (progn (message \"transcribed input\") (insert \"$message\") (save-buffer)))"; } | { read command; emacsclient --eval "$command"; }

