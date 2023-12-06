#!/usr/bin/awk -f

BEGIN { sum = 0 }

{
  prevLine = currLine
  currLine = nextLine
  nextLine = $0
}

FNR >= 2 {
  currLineCopy = currLine
  delete check
  while (match(currLineCopy, /[0-9]+/)) {
    number = substr(currLine, RSTART, RLENGTH);

    # Replace num with spaces according to length ("123" > "   ")
    spaces = sprintf("%*s", length(number), " ")
    sub(/[0-9]+/, spaces, currLineCopy)

    bounds["min"] = RSTART > 1 ? RSTART - 1 : RSTART
    bounds["max"] = RSTART > 1 ? RLENGTH + 2 : RLENGTH + 1

    check[FNR-2] = substr(prevLine, bounds["min"], bounds["max"])
    check[FNR-1] = substr(currLine, bounds["min"], bounds["max"])
    check[FNR] = substr(nextLine, bounds["min"], bounds["max"])

    for (key in check) {
      match(check[key], /\*/)

      if (RLENGTH != -1) {
        stars[RSTART+bounds["min"] " " key] = stars[RSTART+bounds["min"] " " key] " " number
        break
      }
    }

  }

}

END { 
  for (key in stars) {
    split(stars[key], nums, " ")

    if (length(nums) == 2) {
      sum += nums[1] * nums[2]
    }
  }

  print sum 
}
