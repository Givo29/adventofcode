#!/usr/bin/awk -f

BEGIN {
	sum = 0

	# Mapping from written numbers to digits
	mapping["one"] = 1
	mapping["two"] = 2
	mapping["three"] = 3
	mapping["four"] = 4
	mapping["five"] = 5
	mapping["six"] = 6 
	mapping["seven"] = 7
	mapping["eight"] = 8
	mapping["nine"] = 9
}

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

		# Match written numbers in line
		match(substring, /^(one|two|three|four|five|six|seven|eight|nine)/)
		if (RLENGTH != -1) {
		    line_numbers = line_numbers " " mapping[substr(substring, RSTART, RLENGTH)]
		}
  }
	
	# Add line to sum
	n = split(line_numbers, numbers_array)
	sum += numbers_array[1] numbers_array[n]
}


END { print sum }
