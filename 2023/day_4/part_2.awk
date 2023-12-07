#!/usr/bin/awk -f

BEGIN { 
  FS = "[:|]"
  total_cards = 0
}

{
  if (repeats[FNR] == "")
    repeats[FNR] = 1

  split($3, my_nums, " ")

  # Find amount of wins for current card
  card_wins = 0
  for (i = 1; i <= length(my_nums); i++) {
    if ($2 ~ " "my_nums[i]" "){
      card_wins++ 
    }
  }

  # Add new cards
  for (i = 1; i <= repeats[NR]; i++) {
    total_cards++
    for (j = 1; j <= card_wins; j++) {
      if (repeats[NR+j] == "")
        repeats[NR+j] = 1
      
      repeats[NR+j] += 1
    }
  }
}

END { 
  print total_cards
}
