#!/bin/bash
awk -v insert="$2" '
{
    while (match($0, /\\fixed c[[:space:]]*\{/)) {
        start = RSTART + RLENGTH - 1
        depth = 1
        pos = start + 1
        
        while (pos <= length($0) && depth > 0) {
            char = substr($0, pos, 1)
            if (char == "{") depth++
            else if (char == "}") depth--
            pos++
        }
        
        if (depth == 0) {
            end_pos = pos - 1
            $0 = substr($0, 1, end_pos-1) insert "\n" substr($0, end_pos)
        } else {
            break
        }
    }
}
1' "$1" > tmp && mv tmp "$1"
