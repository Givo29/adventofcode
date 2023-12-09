#!/usr/bin/awk -f

BEGIN { 
  RS = ""

  total = 1
}

{
  split($0, a, /\n/)
  split(a[1], times, / +/)
  split(a[2], distances, / +/)

  for(i = 2; i <= length(times); i++) {
    running_total = 0
    for (j = 1; j <= times[i]; j++) {
      if ((times[i] - j) * j > distances[i])
        running_total++
    }

    total *= running_total
  }
}

END { print total }
