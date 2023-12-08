#!/usr/bin/awk -f

BEGIN {
  RS=""
}

function getNextMapping(current_list, map) {
  for (key in current_list) {
    if (current_list[key] >= map[2] && current_list[key] < map[2] + map[3]) {
      new_mapping[current_list[key]] = current_list[key] + map[1] - map[2] 
    } else {
      if (current_list[key] in new_mapping)
        continue

      new_mapping[current_list[key]] = current_list[key]
    }
  }
}

function getNextRangeMapping(current_list, map) {
  dest = map[1]
  src = map[2]
  rng = map[3]

  offset = dest - src

  min_src = src
  max_src = src + rng

  for (key in current_list) {
    split(current_list[key], map_rng, /\:/)
    if (map_rng[1] >= min_src && map_rng[2] < max_src) {
      # within
      new_list[current_list[key]] = map_rng[1] + offset ":" map_rng[2] + offset
      continue
    }

    if (map_rng[1] >= min_src && map_rng[1] < max_src && map_rng[2] >= max_src) {
      # upper
      new_list[current_list[key]] = max_src ":" map_rng[2]
      new_list[current_list[key] "upper"] = map_rng[1] + offset ":" max_src + offset
      continue
    }

    if (map_rng[1] < min_src && map_rng[2] >= min_src && map_rng[2] < max_src) {
      # lower
      new_list[current_list[key]] = map_rng[1] ":" min_src
      new_list[current_list[key] "lower"] = min_src + offset ":" map_rng[2] + offset
      continue
    }

    if (map_rng[1] < min_src && map_rng[2] >= max_src) {
      new_list[current_list[key] "neither upper"] = map_rng[1] ":" min_src 
      new_list[current_list[key]] = min_src + 1 + offset ":" max_src + offset
      new_list[current_list[key] "neither lower"] = max_src ":" map_rng[2]
      continue
    }

    new_list[current_list[key]] = current_list[key]
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
