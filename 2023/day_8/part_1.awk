#!/usr/bin/gawk -f

NR == 1 {
  split($1, DIRECTIONS, //) 
}

NR >= 3 {
  gsub(/[\(,]/, "", $3)
  gsub(/[\)]/, "", $4)

  steps[$1]["L"] = $3
  steps[$1]["R"] = $4
}

END {
  steps_amt = 0
  current_step["val"] = "AAA"
  current_step["num"] = 1
  
  while (current_step["val"] != "ZZZ") {
    if (current_step["num"] > length(DIRECTIONS))
      current_step["num"] = 1

    current_step["val"] = steps[current_step["val"]][DIRECTIONS[current_step["num"]]]
    current_step["num"]++
    steps_amt++

  }

  print steps_amt
}
