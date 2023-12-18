import std/[strutils, strformat]

proc hash(s: string): int =
  var current_value = 0
  for c in s:
    current_value += int(c)
    current_value *= 17
    current_value = current_value mod 256

  return current_value

let strings = readline(stdin).split(",")

var sum = 0
for s in strings:
  sum += hash(s)

echo(sum)
