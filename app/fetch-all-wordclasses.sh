#!/bin/bash
export LC_ALL=nb_NO.UTF-8 
export LANG=nb_NO.UTF-8

find ./article -type f -name "*.json" -print0 | \
    parallel -0 -j+0 -N50 'jq -r "
  # First output the main lemma with its wordclass
  (.lemmas[]? | 
    .lemma as \$lem | 
    .paradigm_info[0].tags[0] as \$wc | 
    \$lem + \";\" + \$wc
  ),
  # Then output all word forms with their wordclass
  (.lemmas[]? | 
    .paradigm_info[]? | 
    .tags[0] as \$wc | 
    .inflection[]? | 
    .word_form + \";\" + \$wc
  )
" {} 2>/dev/null | sort -u'
