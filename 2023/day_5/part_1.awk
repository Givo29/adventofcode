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

NR == 1 {
  split($0, a, /: /)
  split(a[2], seed_list, / /)
  for (key in seed_list)
    mapping[key] = seed_list[key]
}

NR >= 2 {
  split($0, a, /\n/)

  for (i = 2; i <= length(a); i++) {
    split(a[i], map, / /)
    getNextMapping(mapping, map)
  }

  delete mapping
  for (key in new_mapping) {
    mapping[key] = new_mapping[key]
  }
  delete new_mapping
}

END {
  smallest = 0
  for (key in mapping) {
    if (smallest == 0 || mapping[key] < smallest)
      smallest = mapping[key]
  }
  print smallest
}
