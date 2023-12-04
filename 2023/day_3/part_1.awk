#!/usr/bin/awk -f
BEGIN { prevLine = "" }

function findNextMatch(matchString, startIndex, pattern) {
  print "startIndex: "startIndex" ------------------"
  where = match(substr(matchString, startIndex), pattern)

  if (RLENGTH == -1)
    return -1
  
  return where+startIndex 
}

{
  getline nextLine

  nextNumIdx = 0
  RLENGTH = 0
  while (nextNumIdx+RLENGTH < length($0)) {
    print "Line: "$0
    print "Index: "nextNumIdx
    nextNumIdx = findNextMatch($0, nextNumIdx+RLENGTH, "[0-9]+")
  
    if (RLENGTH == -1)
      next

    print "Index and rlength: "nextNumIdx " " RLENGTH
    print "substring: "substr($0, nextNumIdx-1, RLENGTH)
  
  }
  
}

{ prevLine = $0 }

END {}
