#!/usr/bin/env io

totalScore := 0
while ((line := File standardInput readLine),
  numbers := line splitNoEmpties(":") at(1) splitNoEmpties("|")
  winning := numbers at(0) splitNoEmpties(" ")
  chosen := numbers at(1) splitNoEmpties(" ")

  loseCount := chosen clone removeSeq(winning) size
  winCount := chosen size - loseCount

  if (winCount > 0, score := 2 ** (winCount - 1), score := 0)

  totalScore := totalScore + score

  writeln(score, "   ", totalScore)
)

writeln(totalScore)
