#!/bin/bash
awk -v insert_string="$2" '
{
    text = (text == "" ? "" : text "\n") $0
}
END {
    result = ""
    i = 1
    
    while (i <= length(text)) {
        if (match(substr(text, i), /^\\fixed[ \t\n]*c[ \t\n]*\{/)) {
            match_len = RLENGTH
            result = result substr(text, i, match_len)
            i += match_len
            
            depth = 1
            block_start = i
            
            while (i <= length(text) && depth > 0) {
                char = substr(text, i, 1)
                if (char == "{") depth++
                else if (char == "}") depth--
                i++
            }
            
            if (depth == 0) {
                result = result substr(text, block_start, i - block_start - 1)
                result = result insert_string "\n}"
            } else {
                result = result substr(text, block_start, i - block_start)
            }
        } else {
            result = result substr(text, i, 1)
            i++
        }
    }
    
    printf "%s", result
}' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
