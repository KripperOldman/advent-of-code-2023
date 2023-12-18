function chunk(char)
	if char == "." then
		return { "   ", "   ", "   " }
	elseif char == "S" then
		return { " | ", "-S-", " | " }
	elseif char == "|" then
		return { " | ", " | ", " | " }
	elseif char == "-" then
		return { "   ", "---", "   " }
	elseif char == "L" then
		return { " | ", " L-", "   " }
	elseif char == "J" then
		return { " | ", "-J ", "   " }
	elseif char == "7" then
		return { "   ", "-7 ", " | " }
	elseif char == "F" then
		return { "   ", " F-", " | " }
	else
		error("Chunk called with " .. char)
	end
end

local graph = {}
local vertices = {}

local current_x = 0
local current_y = 0
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

	max_y = current_y + 2

	for in_char in string.gmatch(line, ".") do
		local chunky = chunk(in_char)
		local temp_y = current_y
		max_x = current_x + 2

		for _, chunk in pairs(chunky) do
			local temp_x = current_x
			for char in chunk:gmatch(".") do
				if char == " " then
				elseif char == "S" then
					animal = { x = temp_x, y = temp_y, key = string.format("%d, %d", temp_x, temp_y) }
					loop_vertices[animal.key] = { x = animal.x, y = animal.y, char = char }

					local left_key = string.format("%d, %d", temp_x - 1, temp_y)
					local right_key = string.format("%d, %d", temp_x + 1, temp_y)
					local up_key = string.format("%d, %d", temp_x, temp_y - 1)
					local down_key = string.format("%d, %d", temp_x, temp_y + 1)

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
					vertices[string.format("%d, %d", temp_x, temp_y)] =
						{ x = temp_x, y = temp_y, char = char }
				else
					error("Why is char not something expected?? '" .. char .. "'")
				end

				temp_x = temp_x + 1
			end
			temp_y = temp_y + 1
		end
		current_x = current_x + 3
	end
	current_y = current_y + 3
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

while #next > 0 do
	local v = table.remove(next, 1)
	local neighbors = graph[v.key]

	for key, flag in pairs(neighbors) do
		if flag > 1 then
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

local val_map = {}

for y = 0, max_y + 1, 1 do
	val_map[y] = {}
	for x = 0, max_x + 1, 1 do
		val_map[y][x] = { char = " " }
	end
end

local max = { key = "", distance = 0 }
for _, v in pairs(visited) do
	local vert = loop_vertices[v.key]
	if vert ~= nil then
		val_map[vert.y][vert.x] = { char = vert.char, distance = v.distance }
	else
	end
	if v.distance > max.distance then
		max = v
	end
end

local inside_vertices = {}
local g = {}

for y, row in pairs(val_map) do
	local row_str = ""
	for x, v in pairs(row) do
		row_str = row_str .. v.char
		if v.char == " " then
			local key = string.format("%d, %d", x, y)

			inside_vertices[key] = { x = x, y = y }

			local left_key = string.format("%d, %d", x - 1, y)
			local right_key = string.format("%d, %d", x + 1, y)
			local up_key = string.format("%d, %d", x, y - 1)
			local down_key = string.format("%d, %d", x, y + 1)

			if g[key] == nil then
				g[key] = {}
			end

			if y - 1 >= min_y then
				if g[up_key] == nil then
					g[up_key] = {}
				end

				g[key][up_key] = (g[key][up_key] or 0) + 1
				g[up_key][key] = (g[up_key][key] or 0) + 1
			end

			if y + 1 <= max_y then
				if g[down_key] == nil then
					g[down_key] = {}
				end

				g[down_key][key] = (g[down_key][key] or 0) + 1
				g[key][down_key] = (g[key][down_key] or 0) + 1
			end

			if x - 1 >= min_x then
				if g[left_key] == nil then
					g[left_key] = {}
				end

				g[left_key][key] = (g[left_key][key] or 0) + 1
				g[key][left_key] = (g[key][left_key] or 0) + 1
			end

			if x + 1 <= max_x then
				if g[right_key] == nil then
					g[right_key] = {}
				end

				g[right_key][key] = (g[right_key][key] or 0) + 1
				g[key][right_key] = (g[key][right_key] or 0) + 1
			end
		end
	end
	print(row_str)
end

-- print()
--
-- print("Before removing")
-- for key, v in pairs(inside_vertices) do
-- 	if v then
-- 		print(key)
-- 	end
-- end
--
local edge_vertices = {}

for key, v in pairs(inside_vertices) do
	if v.x <= min_x or v.x >= max_x or v.y <= min_x or v.y >= max_y then
		table.insert(edge_vertices, { key = key })
	end
end

while #edge_vertices > 0 do
	local visited2 = {}
	next = { table.remove(edge_vertices, 1) }

	while #next > 0 do
		local v = table.remove(next, 1)
		local neighbors = g[v.key]

		for key, flag in pairs(neighbors) do
			if flag > 1 then
				local already_visited = false

				for _, u in pairs(visited2) do
					if u.key == key then
						already_visited = true
						break
					end
				end

				if not already_visited then
					for i, u in pairs(next) do
						if u.key == key then
							table.remove(next, i)
						end
					end

					table.insert(next, { key = key })
				end
			end
		end

		-- print("Removing vertex", v.key)
		g[v.key] = nil

		for i, u in pairs(next) do
			if u.key == v.key then
				table.remove(next, i)
			end
		end

		for i, u in pairs(edge_vertices) do
			if u.key == v.key then
				table.remove(edge_vertices, i)
			end
		end

		inside_vertices[v.key] = nil
		table.insert(visited2, v)
	end
end

-- print()

-- print("After removing")
local total = 0
for key, v in pairs(inside_vertices) do
	if v then
		-- print(key)
		total = total + 1
	end
end

-- print(total)

val_map = {}

for y = 0, max_y + 1, 1 do
	val_map[y] = {}
	for x = 0, max_x + 1, 1 do
		local key = string.format("%d, %d", x, y)
		if inside_vertices[key] ~= nil then
			val_map[y][x] = { char = "I" }
		else
			val_map[y][x] = { char = " " }
		end
	end
end

for _, v in pairs(visited) do
	local vert = loop_vertices[v.key]
	if vert ~= nil then
		if val_map[vert.y][vert.x].char == " " then
			val_map[vert.y][vert.x] = { char = vert.char, distance = v.distance }
		else
			error("Part of loop set as outside at ", v.key)
		end
	else
	end
end

for _, row in pairs(val_map) do
	local row_str = ""
	for _, v in pairs(row) do
		row_str = row_str .. v.char
	end
	print(row_str)
end

print()

for y = 1, #val_map, 3 do
	local row_str = ""
	for x = 1, #val_map[y], 3 do
		row_str = row_str .. val_map[y][x].char
	end
	print(row_str)
end

print()

total = 0

for y = 1, #val_map, 3 do
	for x = 1, #val_map[y], 3 do
		if val_map[y][x].char == "I" then
			total = total + 1
		end
	end
end

print(total)
