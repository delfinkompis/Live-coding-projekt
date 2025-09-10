#! /bin/bash

if result=$(grep -hr "\"suggest\": \[\"$1\"\]" ./article/); then
   echo "$result" | head -1 | grep -oP "\"lemma\": \"\K[^\" ]*"
else
    grep -hr "\"word_form\": \"$1\"" ./article/ | head -1 | grep -oP "\"lemma\": \"\K[^\" ]*"
fi
