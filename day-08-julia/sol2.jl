function all_zs(lst)
  for i in lst
    if i[3] != 'Z'
      return false
    end
  end

  return true
end

dir_mapping = Dict('L' => 1, 'R' => 2)
directions = readline()
dirlist = [dir_mapping[d] for d in directions]

readline()

routes = Dict()
start_nodes = []

for line in readlines()
  global routes
  m = match(r"^([0-9A-Z]+) = \(([0-9A-Z]+), ([0-9A-Z]+)\)$", line)
  if m != nothing
    a, b, c = m.captures
    routes[a] = [b, c]
    if a[3] == 'A'
      push!(start_nodes, a)
    end
  end
end

sequences = Dict()

for start_node in start_nodes
  current = start_node
  turns = 1
  i = 0

  sequences[start_node] = []

  while current[3] != 'Z'
    global sequences
    direction = dirlist[i+1]
    next = routes[current][direction]

    push!(sequences[start_node], next)

    current = next
    turns += 1
    i = (i + 1) % length(dirlist)
  end
end

# println([sequences[x] for x in start_nodes])
println(reduce(lcm, [length(sequences[x]) for x in start_nodes]))
