#!/usr/bin/awk -f

BEGIN { sum = 0 }

{ 
    line_numbers = ""
    
    for (i=1; i <= length($0); i++) {
	    # Create substring from current char
        substring = substr($0, i)

        # Match digits in line
        match(substring, /^[0-9]/)
        if (RLENGTH != -1) {
            line_numbers = line_numbers " " substr(substring, RSTART, 1)
        }
    }
    
    n = split(line_numbers, numbers_array)
    sum +=  numbers_array[1] numbers_array[n]
}


END { print sum }
