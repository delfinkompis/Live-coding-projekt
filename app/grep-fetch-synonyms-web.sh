#! /bin/bash


rg --files-with-matches '"lemma": "[^"]+"' article/ | while read -r file; do
    rg -m1 '"word-form": "([^"]+)"' -or '$1' "$file"
done

rg --files-with-matches '"word_form": "[^"]+"' article/ | while read -r file; do
    rg -m1 '"lemma": "([^"]+)"' -or '$1' "$file"
done


#rg -r '$1' --no-filename -m1 -o "(?:\"suggest\": \[\"$1\"\]|\"word_form\": \"$1\").*?\"lemma\": \"([^\"]*)" ./article/

#rg -r '$1' --no-filename -m1 -o "(?:\"word_form\": \"$1\").*?\"lemma\": \"([^\"]*)" ./article/



#rg -r --debug '$1' --no-filename -m1 -o "(?:\"suggest\": \[\"$1\"\]|\"word_form\": \"$1\").*?\"lemma\": \"([^\"]*)" ./article/

