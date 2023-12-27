#!/usr/bin/gawk -f

NR == 1 {
  split($1, DIRECTIONS, //) 
}

NR >= 3 {
  gsub(/[\(,]/, "", $3)
  gsub(/[\)]/, "", $4)

  paths[$1]["L"] = $3
  paths[$1]["R"] = $4
}

NR >= 3 && $1 ~ /A$/ {
  current_steps[++current_key]["path"] = $1
  current_steps[current_key]["steps"] = 0 
}

END {
  current_step = 1

  for (i = 1; i <= length(current_steps); i++) {
    current_step = 1
    while (current_steps[i]["path"] !~ /[Z]$/) {
      if (current_step > length(DIRECTIONS))
        current_step = 1
      
      current_steps[i]["path"] = paths[current_steps[i]["path"]][DIRECTIONS[current_step]]
      current_steps[i]["steps"]++
      current_step++
    }
  }

  lcm = (current_steps[1]["steps"] * current_steps[2]["steps"]) / GCD(current_steps[1]["steps"], current_steps[2]["steps"])
  for (i = 1; i <= length(current_steps); i++) {
    lcm = (lcm * current_steps[i]["steps"]) / GCD(lcm, current_steps[i]["steps"])
  }

  print lcm
}

function GCD(a, b) {
  if (b == 0)
    return a
  return GCD(b, a % b)
}
