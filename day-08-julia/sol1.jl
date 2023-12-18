dir_mapping = Dict('L' => 1, 'R' => 2)
directions = readline()
dirlist = [dir_mapping[d] for d in directions]

readline()

routes = Dict()

for line in readlines()
  global routes
  m = match(r"^([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)$", line)
  if m != nothing
    a, b, c = m.captures
    routes[a] = [b, c]
  end
end

current = "AAA"
turns = 1
i = 0
while current != "ZZZ"
  global turns, i, current
  direction = dirlist[i + 1]
  next = routes[current][direction]

  println(turns, ": ", current, " -> ", next)

  current = next
  turns += 1
  i = (i + 1) % length(dirlist)
end
