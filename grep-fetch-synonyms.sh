#! /bin/bash

rg --no-filename -o -r '$1' "(?:\"suggest\": \[\"$1\"\]|\"word_form\": \"$1\").*?\"lemma\": \"([^\"]*?)\"" ./article/

#rg -r '$1' --no-filename -m1 "(?:\"suggest\": \[\"$1\"\]|\"word_form\": \"$1\").*?\"lemma\": \"([^\"]*)" ./article/
 # if result=$(grep -hr "\"suggest\": \[\"$1\"\]" ./article/); then
 #     echo "$result" | head -1 | grep -oP "\"lemma\": \"\K[^\" ]*"
 #  else
 #      grep -hr "\"word_form\": \"$1\"" ./article/ | head -1 | grep -oP "\"lemma\": \"\K[^\" ]*"
 #  fi



