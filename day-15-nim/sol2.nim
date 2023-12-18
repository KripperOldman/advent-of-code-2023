import std/[strutils, strformat]

proc hash(s: string): int =
  var current_value = 0
  for c in s:
    current_value += int(c)
    current_value *= 17
    current_value = current_value mod 256

  return current_value

type Lens = tuple
  label: string
  focal_length: int

type
  LensSeq = seq[Lens]

var HASHMAP: array[256, LensSeq]

let strings = readline(stdin).split(",")

for s in strings:
  if s.endsWith("-"):
    let label = s.split("-")[0]
    let i = hash(label)

    var found_index = -1;
    for j, lens in HASHMAP[i]:
      if lens.label == label:
        found_index = j
        break

    if found_index >= 0:
      # echo(fmt"Removing {HASHMAP[i][found_index]} at {i}, {found_index}")
      var new_seq: LensSeq
      new_seq.add(HASHMAP[i][0..<found_index]) 
      new_seq.add(HASHMAP[i][(found_index+1) .. ^1])
      HASHMAP[i] = new_seq

  else:
    let splits = s.split("=")
    let label = splits[0]
    let focal_length = splits[1].parseInt()
    let i = hash(label)

    var found_index = -1;
    for j, l in HASHMAP[i]:
      if l.label == label:
        found_index = j
        break

    let lens: Lens = (label: label, focal_length: focal_length)

    if found_index == -1:
      # echo(fmt"Adding new lens {lens} at {i}")
      HASHMAP[i].add(lens)
    else:
      # echo(fmt"Replacing lens {HASHMAP[i][found_index]} with {lens} at {i}, {found_index}")
      HASHMAP[i][found_index] = lens

var sum = 0
for box_no, ls in HASHMAP:
  for slot_no, lens in ls:
    let focal_power = (box_no + 1) * (slot_no + 1) * lens.focal_length
    sum += focal_power

echo(sum)
