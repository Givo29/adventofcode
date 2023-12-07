#!/usr/bin/awk -f

BEGIN { sum = 0 }

{
  prevLine = currLine
  currLine = nextLine
  nextLine = $0
}

FNR >= 2 {
  currLineCopy = currLine
  while (match(currLineCopy, /[0-9]+/)) {
    number = substr(currLine, RSTART, RLENGTH);

    # Replace num with spaces according to length ("123" > "   ")
    spaces = sprintf("%*s", length(number), " ")
    sub(/[0-9]+/, spaces, currLineCopy)

    bounds["min"] = RSTART > 1 ? RSTART - 1 : RSTART
    bounds["max"] = RSTART > 1 ? RLENGTH + 2 : RLENGTH + 1

    check["prev"] = substr(prevLine, bounds["min"], bounds["max"])
    check["curr"] = substr(currLine, bounds["min"], bounds["max"])
    check["next"] = substr(nextLine, bounds["min"], bounds["max"])

    for (key in check) {
      match(check[key], /[^0-9\.]/)

      if (RLENGTH != -1) {
        sum += number
        break
      }
    }
  }
}

END { print sum }
