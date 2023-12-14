#!/usr/bin/awk -f

BEGIN {
  ranks["T"] = 10
  ranks["J"] = 11
  ranks["Q"] = 12
  ranks["K"] = 13
  ranks["A"] = 14
}

{ 
  print "----------------------"
  findCardCopies($1)
  joinedCards = join(copies)
  split(joinedCards, copies, /,/)
  n = ALength(copies)
  isort(copies, n)
   
  label = "high"
  for (i = 1; i < n; i++) {
    if (copies[i] == 5) {
      label = "5"
      break
      
    if (copies[i] == 4) {
      label = "4"
      break

    if (copies[i] == 3 && copies[i+1] == 2) {
      label = "full"
      break
      
    if (copies[i] == 3 && copies[i+1] == 1) {
      label = "3"
      break

    if (copies[i] == 2 && copies[i+1] == 2) {
      label = "2"
      break

    if (copies[i] == 2 && copies[i+1] == 1) {
      label = "1"
      break
    }
  }
}

END {}

function ALength(A,   i, n) {
  n = 0
  for (i in A) n++

  return n
}

function join(A,    i, string) {
  for (i in A) {
    if (length(string) > 0)
      string = A[i] "," string
    else 
      string = A[i]

  }
  return string
}

function isort(A, n,   i, j, t) {
  for (i = 2; i <= n; i++)
    for (j = i; j > 1 && A[j-1] < A[j]; j--) {
      t = A[j-1]; A[j-1] = A[j]; A[j] = t
    }
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

function findCardCopies(hand,   cards, i) {
  delete copies

  split(hand, cards, //)

  for (i = 1; i <= length(cards); i++) {
    if (cards[i] in copies) {
      copies[cards[i]]++
      continue
    }

    copies[cards[i]] = 1
  }
}
