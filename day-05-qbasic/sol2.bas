open "input.txt" for input as #1
open "output" for output as #2

const MAXIDS = 10240
idCount = 0

type pair
  updated as integer
  first as _INTEGER64
  last as _INTEGER64
end type

dim activeIds(MAXIDS) as pair
dim temp(MAXIDS) as pair

call emptyArray(activeIds())
call emptyArray(temp())

input #1, seedLine$
print "Starting..."

' Read the seeds list
prop = 0
n&& = 0
for i = 8 to len(seedLine$)
  char$ = mid$(seedLine$, i, 1)
 
  if char$ = " " then
    if prop = 0 then
      idCount = idCount + 1
      prop = 1
      activeIds(idCount).first = n&&
    elseif prop = 1 then
      prop = 0
      activeIds(idCount).last = activeIds(idCount).first + n&& - 1
    else
      print "HUH why is prop not 1 or 0"
    end if
    n&& = 0
  else
    n&& = (n&& * 10) + val(char$)
  end if
next

activeIds(idCount).last = activeIds(idCount).first + n&& - 1

call printArray(activeIds())

input #1, scrap$
input #1, scrap$

print #2, ""
call copyArray(activeIds(), temp())
index = 1
do
  input #1, line$

  if line$ = "" then

    for i = 1 to MAXIDS
      if activeIds(i).updated = 0 then
        call appendToArray(temp(), activeIds(i))
      end if
    next

    print #2, ""
    print #2, "Active"
    call printArray(activeIds())
    print #2, ""
    print #2, "Temp"
    call printArray(temp())
    print #2, ""

    call copyArray(temp(), activeIds())
    call emptyArray(temp())

    input #1, scrap$
  else
    destStart&& = 0
    sourceStart&& = 0
    num&& = 0
    
    count = 0
    n&& = 0
    for i = 1 TO len(line$)
      char$ = mid$(line$, i, 1)
     
      if char$ = " " then
        count = count + 1

        if count = 1 then
          destStart&& = n&&
        elseif count = 2 then
          sourceStart&& = n&&
        else
          print #2, "HUH why is count not 1 or 2???"
        end if

        n&& = 0
      else
        n&& = (n&& * 10) + val(char$)
      end if
    next
    num&& = n&&
    
    replaced = checkActiveIdAndReplace(sourceStart&&, destStart&&, num&&, activeIds(), temp())
  end if
loop until EOF(1)

print #2, ""
print #2, "Active"
call printArray(activeIds())
print #2, ""
print #2, "Temp"
call printArray(temp())
print #2, ""

call copyArray(temp(), activeIds())

min = activeIds(1).first

for i = 2 to MAXIDS
  if activeIds(i).first <> -1 and activeIds(i).first < min then
    min = activeIds(i).first
  end if
next

print #2, min

sub printArray(arr() as pair)
  for i = 1 to MAXIDS
    if arr(i).first <> -1 and arr(i).last <> -1 then
      print #2, arr(i).first, arr(i).last, arr(i).last - arr(i).first + 1, arr(i).updated
    end if
  next
end sub

sub emptyArray(arr() as pair)
  for i = 1 to MAXIDS
    arr(i).first = -1
    arr(i).last = -1
    arr(i).updated = 0
  next
end sub

sub copyArray(source() as pair, dest() as pair)
  for i = 1 to MAXIDS
    dest(i).first = source(i).first
    dest(i).last = source(i).last
    dest(i).updated = 0
  next
end sub

function checkActiveIdAndReplace(sourceStart as _INTEGER64, destStart as _INTEGER64, num as _INTEGER64, activeIds() as pair, newArray() as pair)
  replaced = 0
  for i = 1 to MAXIDS
    first&& = activeIds(i).first
    last&& = activeIds(i).last
    sourceEnd&& = sourceStart + num - 1
    diff&& = destStart - sourceStart

    if last&& >= sourceStart and first&& < sourceEnd&& then
      dim before as pair
      dim converted as pair
      dim after as pair
      before.updated = 1
      converted.updated = 1
      after.updated = 1

      if first&& >= sourceStart then
        before.first = -1
        before.last = -1

        converted.first = first&& + diff&&
        if last&& <= sourceEnd&& then
          converted.last = last&& + diff&&
          after.first = -1
          after.last = -1
        else
          converted.last = sourceEnd&& + diff&&
          after.first = sourceEnd&& + 1
          after.last = last&&
        end if
      else
        before.first = first&&
        before.last = sourceStart&& - 1

        converted.first = sourceStart&& + diff&&
        if last&& <= sourceEnd&& then
          converted.last = last&& + diff&&
          after.first = -1
          after.last = -1
        else
          converted.last = sourceEnd&& + diff&&
          after.first = sourceEnd&& + 1
          after.last = last&&
        end if
      end if

      activeIds(i).updated = 1

      call appendToArray(newArray(), before)
      call appendToArray(newArray(), converted)
      call appendToArray(newArray(), after)

      print #2, ""
      print #2, first&&, last&&
      print #2, before.first, before.last
      print #2, converted.first, converted.last
      print #2, after.first, after.last
      print #2, "src start: ", sourceStart, "dest start:", destStart, "count: ", num
      print #2, ""
    end if
  next
  checkActiveIdAndReplace = replaced
end function

sub appendToArray(arr() as pair, p as pair)
  for i = 1 to MAXIDS
    if arr(i).first = p.first and arr(i).last = p.last then
      arr(i).updated = 1
      exit for
    elseif arr(i).first = -1 and arr(i).last = -1 then
      arr(i).first = p.first
      arr(i).last = p.last
      arr(i).updated = p.updated
      exit for
    end if
  next
end sub
