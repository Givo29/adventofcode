#!/usr/bin/awk -f

BEGIN {
  RS=""
}

function getNextRangeMapping(current_list, map) {
  dest = map[1]
  src = map[2]
  rng = map[3]

  offset = dest - src

  min_src = src
  max_src = src + rng-1

  for (key in current_list) {
    split(current_list[key], map_rng, /\:/)
    min_rng = map_rng[1]
    max_rng = map_rng[2]

    # Within
    if (min_rng >= min_src && max_rng <= max_src) {
      new_list[current_list[key] "within"] = min_rng + offset ":" max_rng + offset
    }

    # Starting below
    if ((min_rng >= min_src && min_rng <= max_src) && max_rng > max_src) {
      new_list[current_list[key] "upper within"] = min_rng + offset ":" max_src + offset
      new_list[current_list[key] "upper above"] = max_src ":" max_rng
    }

    # Ending above
    if (min_rng < min_src && (max_rng >= min_src && max_rng <= max_src)) {
      new_list[current_list[key] "lower within"] = min_src + offset ":" max_rng + offset
      new_list[current_list[key] "lower below"] = min_rng ":" min_src 
    }
    
    # Around
    if (min_rng < min_src && max_rng > max_src) {
      new_list[current_list[key] "aruond below"] = min_rng ":" min_src 
      new_list[current_list[key] "around both"] = min_src + offset ":" max_src + offset
      new_list[current_list[key] "around above"] = max_src ":" max_rng
    }

		# Not in at all
    new_list[current_list[key] "same"] = current_list[key]
  }
}

NR == 1 {
  split($0, a, /: /)
  split(a[2], seed_list, / /)
  for (i = 1; i < length(seed_list); i += 2) {
    mapping[i] = seed_list[i] ":" seed_list[i] + seed_list[i+1]
  }
}

NR >= 2 {
  split($0, a, /\n/)

  for (i = 2; i <= length(a); i++) {
    split(a[i], map, / /)
    getNextRangeMapping(mapping, map)
  }

  delete mapping
  for (key in new_list) {
    mapping[key] = new_list[key]
  }
  delete new_list
}

END {
  smallest = 0
  for (key in mapping) {
    split(mapping[key], small, /\:/)
    if (smallest == 0 || small[1] < smallest)
      smallest = small[1]
  }
  print smallest
}
