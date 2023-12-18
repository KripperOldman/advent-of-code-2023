const std = @import("std");
const parseInt = std.fmt.parseInt;
const fs = std.fs;
const File = std.fs.File;

const Direction = enum { NORTH, SOUTH, EAST, WEST };

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const ally = arena.allocator();
    const load = try solve(ally, "input.txt", 1000000000);

    try stdout.print("{d}", .{load});
}

fn solve(ally: std.mem.Allocator, inputFile: []const u8, cycles: u64) !u64 {
    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    var prevs = std.ArrayList([]u8).init(ally);
    defer deallocMap(ally, prevs);

    var cycle_length: usize = 0;
    var cycle_start: usize = 0;

    const stringLength = map.items.len * map.items[0].len;
    var buf = try ally.alloc(u8, stringLength);
    var bufIndex: usize = 0;
    for (map.items) |line| {
        std.mem.copy(u8, buf[bufIndex..], line);
        bufIndex += line.len;
    }
    try prevs.append(buf);

    outer: for (1..cycles) |i| {
        spin(map.items);

        buf = try ally.alloc(u8, stringLength);
        bufIndex = 0;
        for (map.items) |line| {
            std.mem.copy(u8, buf[bufIndex..], line);
            bufIndex += line.len;
        }

        for (prevs.items, 0..) |prev, j| {
            if (std.mem.eql(u8, prev, buf)) {
                cycle_start = j;
                cycle_length = i - j;
                ally.free(buf);
                break :outer;
            }
        }

        try prevs.append(buf);
    }

    if (cycle_length > 0) {
        const index = cycle_start + (cycles - cycle_start) % cycle_length;
        const load = measureLoadFlat(prevs.items[index], map.items[0].len);

        return load;
    } else {
        const load: u64 = measureLoad(map.items);
        return load;
    }
}

fn spin(map: [][]u8) void {
    slide(map, Direction.NORTH);
    slide(map, Direction.WEST);
    slide(map, Direction.SOUTH);
    slide(map, Direction.EAST);
}

fn measureLoadFlat(map: []const u8, lineLength: usize) u64 {
    const maxLoad: usize = map.len / lineLength;

    var totalLoad: u64 = 0;
    var y: usize = 0;
    for (map, 0..) |c, i| {
        if (i % lineLength == 0) {
            y += 1;
        }

        if (c == 'O') {
            totalLoad += maxLoad - y + 1;
        }
    }

    return totalLoad;
}

fn measureLoad(map: []const []const u8) u64 {
    const maxLoad: usize = map.len;

    var totalLoad: u64 = 0;
    for (map, 0..) |line, y| {
        for (line) |c| {
            if (c == 'O') {
                totalLoad += maxLoad - y;
            }
        }
    }

    return totalLoad;
}

fn slide(map: [][]u8, direction: Direction) void {
    if (direction == .NORTH or direction == .WEST) {
        var y: usize = 0;
        var x: usize = 0;

        while (y < map.len) {
            x = 0;
            while (x < map[y].len) {
                const c = map[y][x];
                if (c == 'O') {
                    switch (direction) {
                        .NORTH => slideUp(map, x, y),
                        .WEST => slideLeft(map, x, y),
                        else => unreachable,
                    }
                }
                x += 1;
            }
            y += 1;
        }
    } else {
        var y = map.len;
        var x = map[0].len;

        while (y > 0) {
            y -= 1;
            x = map[y].len;
            while (x > 0) {
                x -= 1;
                const c = map[y][x];
                if (c == 'O') {
                    switch (direction) {
                        .SOUTH => slideDown(map, x, y),
                        .EAST => slideRight(map, x, y),
                        else => unreachable,
                    }
                }
            }
        }
    }
}

fn slideUp(map: [][]u8, x: usize, y: usize) void {
    const c = map[y][x];

    var y2 = y;
    while (y2 > 0 and map[y2 - 1][x] == '.') {
        y2 -= 1;
    }

    map[y][x] = map[y2][x];
    map[y2][x] = c;
}

fn slideDown(map: [][]u8, x: usize, y: usize) void {
    const c = map[y][x];

    var y2 = y;
    while (y2 < map.len - 1 and map[y2 + 1][x] == '.') {
        y2 += 1;
    }

    map[y][x] = map[y2][x];
    map[y2][x] = c;
}

fn slideLeft(map: [][]u8, x: usize, y: usize) void {
    const c = map[y][x];

    var x2 = x;
    while (x2 > 0 and map[y][x2 - 1] == '.') {
        x2 -= 1;
    }

    map[y][x] = map[y][x2];
    map[y][x2] = c;
}

fn slideRight(map: [][]u8, x: usize, y: usize) void {
    const c = map[y][x];

    var x2 = x;
    while (x2 < map[y].len - 1 and map[y][x2 + 1] == '.') {
        x2 += 1;
    }

    map[y][x] = map[y][x2];
    map[y][x2] = c;
}

fn deallocMap(ally: std.mem.Allocator, map: std.ArrayList([]u8)) void {
    for (map.items) |line| {
        ally.free(line);
    }

    map.deinit();
}

fn readFileAlloc(ally: std.mem.Allocator, inputFile: []const u8) !std.ArrayList([]u8) {
    const file = try fs.cwd().openFile(inputFile, File.OpenFlags{});
    defer file.close();

    const rdr = file.reader();

    var map = std.ArrayList([]u8).init(ally);

    while (try rdr.readUntilDelimiterOrEofAlloc(ally, '\n', 256)) |line| {
        try map.append(line);
    }

    return map;
}

test "file read" {
    const ally = std.testing.allocator;

    const inputFile = "test.txt";

    const map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    const expected = [_][]const u8{
        "O....#....",
        "O.OO#....#",
        ".....##...",
        "OO.#O....O",
        ".O.....O#.",
        "O.#..O.#.#",
        "..O..#O..O",
        ".......O..",
        "#....###..",
        "#OO..#....",
    };

    for (map.items, expected) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "slideNorth" {
    const ally = std.testing.allocator;

    const inputFile = "test.txt";

    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    slide(map.items, Direction.NORTH);

    const expectedSlid = [_][]const u8{
        "OOOO.#.O..",
        "OO..#....#",
        "OO..O##..O",
        "O..#.OO...",
        "........#.",
        "..#....#.#",
        "..O..#.O.O",
        "..O.......",
        "#....###..",
        "#....#....",
    };

    for (map.items, expectedSlid) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "slideWest" {
    const ally = std.testing.allocator;

    const inputFile = "test.txt";

    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    slide(map.items, Direction.WEST);

    const expectedSlid = [_][]const u8{
        "O....#....",
        "OOO.#....#",
        ".....##...",
        "OO.#OO....",
        "OO......#.",
        "O.#O...#.#",
        "O....#OO..",
        "O.........",
        "#....###..",
        "#OO..#....",
    };

    for (map.items, expectedSlid) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "slideSouth" {
    const ally = std.testing.allocator;

    const inputFile = "test.txt";

    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    slide(map.items, Direction.SOUTH);

    const expectedSlid = [_][]const u8{
        ".....#....",
        "....#....#",
        "...O.##...",
        "...#......",
        "O.O....O#O",
        "O.#..O.#.#",
        "O....#....",
        "OO....OO..",
        "#OO..###..",
        "#OO.O#...O",
    };

    for (map.items, expectedSlid) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "slideEast" {
    const ally = std.testing.allocator;

    const inputFile = "test.txt";

    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    slide(map.items, Direction.EAST);

    const expectedSlid = [_][]const u8{
        "....O#....",
        ".OOO#....#",
        ".....##...",
        ".OO#....OO",
        "......OO#.",
        ".O#...O#.#",
        "....O#..OO",
        ".........O",
        "#....###..",
        "#..OO#....",
    };

    for (map.items, expectedSlid) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "measure load" {
    const map = [_][]const u8{
        "OOOO.#.O..",
        "OO..#....#",
        "OO..O##..O",
        "O..#.OO...",
        "........#.",
        "..#....#.#",
        "..O..#.O.O",
        "..O.......",
        "#....###..",
        "#....#....",
    };

    const expected: u64 = 136;
    const actual = measureLoad(&map);

    try std.testing.expectEqual(expected, actual);
}

test "1 cycle" {
    const ally = std.testing.allocator;
    const inputFile = "test.txt";
    const cycles = 1;

    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    const expected = [_][]const u8{
        ".....#....",
        "....#...O#",
        "...OO##...",
        ".OO#......",
        ".....OOO#.",
        ".O#...O#.#",
        "....O#....",
        "......OOOO",
        "#...O###..",
        "#..OO#....",
    };

    for (0..cycles) |_| {
        spin(map.items);
    }

    for (map.items, expected) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "2 cycle" {
    const ally = std.testing.allocator;
    const inputFile = "test.txt";
    const cycles = 2;

    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    const expected = [_][]const u8{
        ".....#....",
        "....#...O#",
        ".....##...",
        "..O#......",
        ".....OOO#.",
        ".O#...O#.#",
        "....O#...O",
        ".......OOO",
        "#..OO###..",
        "#.OOO#...O",
    };

    for (0..cycles) |_| {
        spin(map.items);
    }

    for (map.items, expected) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "3 cycle" {
    const ally = std.testing.allocator;
    const inputFile = "test.txt";
    const cycles = 3;

    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    const expected = [_][]const u8{
        ".....#....",
        "....#...O#",
        ".....##...",
        "..O#......",
        ".....OOO#.",
        ".O#...O#.#",
        "....O#...O",
        ".......OOO",
        "#...O###.O",
        "#.OOO#...O",
    };

    for (0..cycles) |_| {
        spin(map.items);
    }

    for (map.items, expected) |line, exp| {
        try std.testing.expectEqualStrings(exp, line);
    }
}

test "solve" {
    const ally = std.testing.allocator;
    const inputFile = "test.txt";

    const expected: u64 = 64;
    const actual = try solve(ally, inputFile, 1000000000);

    try std.testing.expectEqual(expected, actual);
}
