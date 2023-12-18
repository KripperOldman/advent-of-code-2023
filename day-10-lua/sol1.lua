local graph = {}
local vertices = {}

local current_x = 0
local current_y = 0
local animal = {}
local min_x = 0
local min_y = 0
local max_x = 0
local max_y = 0

local loop_vertices = {}

while true do
	local line = io.stdin:read()
	if line == nil then
		break
	end

	max_y = current_y

	for char in string.gmatch(line, ".") do
		print(current_x, current_y, char)
		max_x = current_x

		if char == "." then
		elseif char == "S" then
			animal = { x = current_x, y = current_y, key = string.format("%d, %d", current_x, current_y) }
			loop_vertices[animal.key] = { x = animal.x, y = animal.y, char = char }

			left_key = string.format("%d, %d", current_x - 1, current_y)
			right_key = string.format("%d, %d", current_x + 1, current_y)
			up_key = string.format("%d, %d", current_x, current_y - 1)
			down_key = string.format("%d, %d", current_x, current_y + 1)

			graph[animal.key] = {}
			graph[up_key] = {}
			graph[down_key] = {}
			graph[left_key] = {}
			graph[right_key] = {}

			graph[animal.key][up_key] = 1
			graph[animal.key][down_key] = 1
			graph[animal.key][left_key] = 1
			graph[animal.key][right_key] = 1

			graph[up_key][animal.key] = 1
			graph[down_key][animal.key] = 1
			graph[left_key][animal.key] = 1
			graph[right_key][animal.key] = 1
		elseif char == "|" or char == "-" or char == "L" or char == "J" or char == "7" or char == "F" then
			vertices[string.format("%d, %d", current_x, current_y)] = { x = current_x, y = current_y, char = char }
		else
			error("Why is char not someething expected??" .. char)
		end

		current_x = current_x + 1
	end

	current_y = current_y + 1
	current_x = 0
end

for _, v in pairs(vertices) do
	local source, target

	if v.char == "|" then
		source = { x = v.x, y = v.y - 1 }
		target = { x = v.x, y = v.y + 1 }
	elseif v.char == "-" then
		source = { x = v.x - 1, y = v.y }
		target = { x = v.x + 1, y = v.y }
	elseif v.char == "L" then
		source = { x = v.x, y = v.y - 1 }
		target = { x = v.x + 1, y = v.y }
	elseif v.char == "J" then
		source = { x = v.x, y = v.y - 1 }
		target = { x = v.x - 1, y = v.y }
	elseif v.char == "7" then
		source = { x = v.x, y = v.y + 1 }
		target = { x = v.x - 1, y = v.y }
	elseif v.char == "F" then
		source = { x = v.x, y = v.y + 1 }
		target = { x = v.x + 1, y = v.y }
	end

	local current_key = string.format("%d, %d", v.x, v.y)
	local source_key = string.format("%d, %d", source.x, source.y)
	local target_key = string.format("%d, %d", target.x, target.y)

	if type(graph[current_key]) ~= "table" then
		graph[current_key] = {}
	end

	loop_vertices[current_key] = { x = v.x, y = v.y, char = v.char }

	if source.x >= min_x and source.x <= max_x and source.y >= min_y and source.y <= max_y then
		if type(graph[source_key]) ~= "table" then
			graph[source_key] = {}
		end

		graph[source_key][current_key] = (graph[source_key][current_key] or 0) + 1
		graph[current_key][source_key] = (graph[current_key][source_key] or 0) + 1
	end

	if target.x >= min_x and target.x <= max_x and target.y >= min_y and target.y <= max_y then
		if type(graph[target_key]) ~= "table" then
			graph[target_key] = {}
		end

		graph[target_key][current_key] = (graph[target_key][current_key] or 0) + 1
		graph[current_key][target_key] = (graph[current_key][target_key] or 0) + 1
	end
end

local visited = {}
local next = {}

table.insert(next, { key = animal.key, distance = 0 })

print()
while #next > 0 do
	local v = table.remove(next, 1)
	print(v.key, v.distance, #next)
	local neighbors = graph[v.key]

	for key, flag in pairs(neighbors) do
		if flag > 1 then
			print("    ", key, flag)
			local already_visited = false
			local distance = v.distance + 1

			for i, u in pairs(visited) do
				if u.key == key then
					already_visited = true
					break
				end
			end

			if not already_visited then
				for i, u in pairs(next) do
					if u.key == key then
						if u.distance < distance then
							distance = u.distance
						end
						table.remove(next, i)
					end
				end

				table.insert(next, { key = key, distance = distance })
			end
		end
	end

	table.insert(visited, v)
end

print()

local val_map = {}

for y = 0, max_y + 1, 1 do
	val_map[y] = {}
	for x = 0, max_x + 1, 1 do
		val_map[y][x] = { char = " " }
	end
end

local max = { key = "", distance = 0 }
for _, v in pairs(visited) do
	print(v.key, v.distance)
	local vert = loop_vertices[v.key]
	if vert ~= nil then
		print(v.key, "vert.char: ", vert.char)
		val_map[vert.y][vert.x] = { char = "#", distance = v.distance }
	else
		print("val_map[y][x] in nil", v.key)
	end
	if v.distance > max.distance then
		max = v
	end
end

print()

for _, row in pairs(val_map) do
	local row_str = ""
	for _, v in pairs(row) do
		row_str = row_str .. v.char
	end
	print(row_str)
end

print()
print("Max:")
print(max.key, max.distance)
