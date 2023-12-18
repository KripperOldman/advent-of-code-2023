open "input.txt" for input as #1
open "output" for output as #2

const MAXIDS = 25

dim seeds(MAXIDS) as _INTEGER64
dim activeIds(MAXIDS) as _INTEGER64
dim temp(MAXIDS) as _INTEGER64
dim destStart as _INTEGER64
dim sourceStart as _INTEGER64
dim num as _INTEGER64
dim n as _INTEGER64

call emptyArray(seeds())
call emptyArray(activeIds())
call emptyArray(temp())

input #1, seedLine$
print "Starting..."

' Read the seeds list
seedCount = 0
n = 0
for i = 8 to len(seedLine$)
  char$ = mid$(seedLine$, i, 1)
 
  if char$ = " " then
    seedCount = seedCount + 1
    seeds(seedCount) = n
    activeIds(seedCount) = n
    n = 0
  else
    n = (n * 10) + val(char$)
  end if
next

seedCount = seedCount + 1
seeds(seedCount) = n
activeIds(seedCount) = n


for i = 1 to seedCount
  print seeds(i)
  print #2, seeds(i)
next

input #1, scrap$
input #1, scrap$

print #2, ""
call copyArray(activeIds(), temp())
index = 1
do
  input #1, line$

  if line$ = "" then
    call copyArray(temp(), activeIds())

    print #2, ""
    call printArray(activeIds())
    print #2, ""

    input #1, scrap$
  else
    destStart = 0
    sourceStart = 0
    num = 0
    
    count = 0
    n = 0
    for i = 1 TO len(line$)
      char$ = mid$(line$, i, 1)
     
      if char$ = " " then
        count = count + 1

        if count = 1 then
          destStart = n
        elseif count = 2 then
          sourceStart = n
        else
          print #2, "HUH why is count not 1 or 2???"
        end if

        n = 0
      else
        n = (n * 10) + val(char$)
      end if
    next
    num = n
    
    replaced = checkActiveIdAndReplace(sourceStart, destStart, num, activeIds(), temp())
  end if
loop until EOF(1)

call copyArray(temp(), activeIds())

print #2, ""
call printArray(activeIds())
print #2, ""

min = activeIds(1)

for i = 2 to MAXIDS
  if activeIds(i) <> -1 and activeIds(i) < min then
    min = activeIds(i)
  end if
next

print #2, min

sub printArray(arr() as _INTEGER64)
  for i = 1 to MAXIDS
    if arr(i) <> -1 then
      print #2, arr(i)
    end if
  next
end sub

sub emptyArray(arr() as _INTEGER64)
  for i = 1 to MAXIDS
    arr(i) = -1
  next
end sub

sub copyArray(source() as _INTEGER64, dest() as _INTEGER64)
  for i = 1 to MAXIDS
    dest(i) = source(i)
  next
end sub

function checkActiveIdAndReplace(sourceStart as _INTEGER64, destStart as _INTEGER64, num as _INTEGER64, activeIds() as _INTEGER64, newArray() as _INTEGER64)
  replaced = 0
  for i = 1 to MAXIDS
    if activeIds(i) >= sourceStart and activeIds(i) < sourceStart + num then
      replaced = replaced + 1
      newArray(i) = destStart + (activeIds(i) - sourceStart)
      print #2, "Replaced: ", activeIds(i), newArray(i), destStart, sourceStart, num
    end if
  next

  checkActiveIdAndReplace = replaced
end function
