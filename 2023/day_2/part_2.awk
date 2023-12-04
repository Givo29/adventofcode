#!/usr/bin/awk -f

BEGIN { sum = 0 }

{
  # Init min cube array for game
  min_cubes["red"] = 0
  min_cubes["green"] = 0
  min_cubes["blue"] = 0

  # Split to get each game in array
  split($0, games, /:|;/)
  for (i = 2; i <= length(games); i++) {
    gsub(", ", ",", games[i])
    gsub("^ ", "", games[i])
    split(games[i], handfulls, /,/)

    for (key in handfulls) {
      split(handfulls[key], cubes, / /)

      if (min_cubes[cubes[2]] < cubes[1])
        min_cubes[cubes[2]] = cubes[1]
    }

  }
  sum += min_cubes["red"] * min_cubes["green"] * min_cubes["blue"]
}

END { print sum }
