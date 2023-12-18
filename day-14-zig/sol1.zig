const std = @import("std");
const parseInt = std.fmt.parseInt;
const fs = std.fs;
const File = std.fs.File;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const ally = arena.allocator();
    const load = try solve(ally, "input.txt");

    try stdout.print("{d}", .{load});
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

fn slideNorth(map: [][]u8) void {
    var y: u32 = 0;
    var x: u32 = 0;

    while (y < map.len) {
        x = 0;
        while (x < map[y].len) {
            const c = map[y][x];
            if (c == 'O') {
                slideUp(map, x, y);
            }
            x += 1;
        }
        y += 1;
    }
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

fn solve(ally: std.mem.Allocator, inputFile: []const u8) !u64 {
    var map = try readFileAlloc(ally, inputFile);
    defer deallocMap(ally, map);

    slideNorth(map.items);

    const load: u64 = measureLoad(map.items);

    return load;
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

    const expected = [_]*const [10:0]u8{
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

    slideNorth(map.items);

    const expectedSlid = [_]*const [10:0]u8{
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

test "solve" {
    const ally = std.testing.allocator;
    const inputFile = "test.txt";

    const expected: u64 = 136;
    const actual = try solve(ally, inputFile);

    try std.testing.expectEqual(expected, actual);
}
