#!/usr/bin/awk -f

BEGIN { 
  RS = ""

  total = 1
}

{
  split($0, a, /\n/)
  gsub(/ +/, "", a[1])
  gsub(/ +/, "", a[2])
  split(a[1], times, /:/)
  split(a[2], distances, /:/)

  running_total = 0
  for (j = 1; j <= times[2]; j++) {
    if ((times[2] - j) * j > distances[2])
      running_total++
  }

  total *= running_total
}

END { print total }
