#!/usr/bin/awk -f

BEGIN {
  WHINY_USERS=1
}

function sortCardCopies(arr,    a, i) {
  # Copy orig array into temp array
  for (key in arr)
    a[key] = arr[key]

  for (i = 1; i <= length(a); i++) {
    for (j = 1; j <= length(a) - i - 1; j++) {
      if (a[j] > a[j + 1]) {
        a[j] = a[j + 1]
        a[j + 1] = a[j]
      }
    }
  }

  # Copy temp array back to orig array
  for (key in a) 
    arr[key] = a[key]
}

function insertAtIndex(arr, idx, value,    a, i) {
  # Copy orig array into temp array
  for (key in arr)
    a[key] = arr[key]

  # Insert new value
  for (i = length(a); i >= idx; i--) {
    a[i+1] = a[i]  

    if (i == idx)
      a[i] = value
  }

  # Copy temp array back to orig array
  for (key in a) 
    arr[key] = a[key]
}

function calculateHandLabel(hand,   cards, i, copies) {
  split(hand, cards, //)

  for (i = 1; i <= length(cards); i++) {
    if (cards[i] in copies) {
      copies[cards[i]]++
      continue
    }

    copies[cards[i]] = 1
  }

  for (key in copies) {
    print key ": " copies[key]
  }
}

NR == 1 { 
  marr[1] = 4
  marr[2] = 3
  marr[3] = 5

  sortCardCopies(marr)

  for (key in marr)
    print key ": " marr[key]
}

END {}
