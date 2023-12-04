#!/usr/bin/awk -f

BEGIN {
  sum = 0

  bag["red"] = 12
  bag["green"] = 13
  bag["blue"] = 14
}

{
  # Split to get each game in array
  split($0, games, /:|;/)
  for (i = 2; i <= length(games); i++) {
    gsub(", ", ",", games[i])
    gsub("^ ", "", games[i])
    
    # Split games into handfulls
    split(games[i], handfulls, /,/)
    for (key in handfulls) {
      split(handfulls[key], cubes, / /)
      
      # If handfull of cubes < amt in bag, game is impossible
      if (bag[cubes[2]] < cubes[1])
        next
    }

  }
  sum += NR
}

END { print sum }
