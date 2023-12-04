#!/usr/bin/env io

extras := Map clone
totalCards := 0

while ((line := File standardInput readLine),
  words := line splitNoEmpties(":")

  id := words at(0) splitNoEmpties(" ") at(1) asNumber

  cardExtras := extras at(id asString, 1)
  totalCards := totalCards + cardExtras

  numbers := words at(1) splitNoEmpties("|")
  winning := numbers at(0) splitNoEmpties(" ")
  chosen := numbers at(1) splitNoEmpties(" ")

  loseCount := chosen clone removeSeq(winning) size
  winCount := chosen size - loseCount

  for (i, id+1, id+winCount,
    extras atPut(i asString, extras at(i asString, 1) + cardExtras)
  )

  writeln(id, ": ", winCount, " ", totalCards, " ", cardExtras)
  writeln(extras values)
)

writeln(totalCards)
