#!/usr/bin/awk -f

BEGIN { 
  sum = 0 
  FS = "[:|]"
}

{
  split($3, my_nums, " ")
  
  running_sum = 0 
  for (i = 1; i <= length(my_nums); i++) {
    if ($2 ~ " "my_nums[i]" ")
      running_sum = running_sum == 0 ? 1 : running_sum * 2
  }
  sum += running_sum
}

END { print sum }
