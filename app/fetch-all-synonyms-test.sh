#!/bin/bash
export LC_ALL=nb_NO.UTF-8 
export LANG=nb_NO.UTF-8

find ./article -type f -name "*.json" -print0 | \
    parallel -0 -j+0 -N50 'jq -r "
  (try .lemmas[]? | .lemma as \$lem | .paradigm_info[]? | .inflection[]? | .word_form + \" \" + \$lem),
  (try .referers[]?.lemma as \$ref | .lemmas[]? | .lemma as \$lem | \$ref + \" \" + \$lem)
" "$@" 2>/dev/null'
