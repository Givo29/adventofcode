#!/usr/bin/gawk -f

BEGIN {
  labelRanks["high"] = 1
  labelRanks["pair"] = 2
  labelRanks["2 pair"] = 3
  labelRanks["3 kind"] = 4
  labelRanks["full"] = 5
  labelRanks["4 kind"] = 6
  labelRanks["5 kind"] = 7

  ranks["J"] = 1
  ranks["T"] = 10
  ranks["Q"] = 12
  ranks["K"] = 13
  ranks["A"] = 14
}

{ 
  findCardCopies($1)
  jacks = 0
  if ("J" in copies)
    jacks = copies["J"]
  joinedCards = join(copies)
  split(joinedCards, copies, /,/)
  isort(copies, length(copies))
   
  label = "high"
  if (jacks > 0)
    label = "pair"
  for (i = 1; i <= length(copies); i++) {
    if (copies[i] == 5) {
      label = "5 kind"
      break
    }
      
    if (copies[i] == 4) {
      label = "4 kind"

      if (jacks > 0)
        label = "5 kind"
      break
    }

    if (copies[i] == 3 && copies[i+1] == 2) {
      label = "full"

      if (jacks == 1)
        label = "4 kind"
      if (jacks > 1)
        label = "5 kind"
      break
    }
      
    if (copies[i] == 3 && copies[i+1] == 1) {
      label = "3 kind"

      if (jacks > 0)
        label = "4 kind"
      break
    }

    if (copies[i] == 2 && copies[i+1] == 2) {
      label = "2 pair"

      if (jacks == 1)
        label = "full"
      if (jacks == 2)
        label = "4 kind"
      break
    }

    if (copies[i] == 2 && copies[i+1] == 1) {
      label = "pair"

      if (jacks > 0)
        label = "3 kind"
    }
  }


  if (NR == 1) {
    hands[1]["hand"] = $1
    hands[1]["value"] = $2
    hands[1]["label"] = label
  } else {
    rank = getCardRank(hands, length(hands), $1, label)
    insertAtIndex(hands, length(hands), $1, $2, label, rank)
  }
}

END {
  sum = 0
  for (i = 1; i <= length(hands); i++) {
    sum += hands[i]["value"] * i
  }
  print sum
}

function getCardRank(A, n, hand, label,    current_idx) {
  current_idx = 1
  split(hand, currentHand, //)
  for (i = 1; i <= n; i++) {
    if (labelRanks[label] < labelRanks[A[i]["label"]]) {
      break 
    }

    if (labelRanks[label] > labelRanks[A[i]["label"]]) {
      current_idx++
      continue
    }

    split(A[i]["hand"], labelHand, //)

    for (j = 1; j <= 5; j++) {
      currentHandCard = currentHand[j]
      labelHandCard = labelHand[j]
      if (currentHandCard in ranks)
        currentHandCard = ranks[currentHandCard]
      if (labelHandCard in ranks)
        labelHandCard = ranks[labelHandCard]

      if (currentHandCard > labelHandCard) {
        current_idx++
        break
      } else if (currentHandCard < labelHandCard) { break }
      
    }
  }

  return current_idx
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

function insertAtIndex(arr, len, hand, value, label, idx,    i) {
  if (idx > len) {
    hands[idx]["hand"] = hand
    hands[idx]["value"] = value
    hands[idx]["label"] = label
    return
  }
  # Insert new value
  for (i = len; i >= idx; i--) {
    hands[i+1]["hand"] = hands[i]["hand"] 
    hands[i+1]["value"] = hands[i]["value"] 
    hands[i+1]["label"] = hands[i]["label"]

    if (i == idx) {
      hands[i]["hand"] = hand
      hands[i]["value"] = value
      hands[i]["label"] = label
    }
  }
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
