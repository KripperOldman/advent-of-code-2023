import 'dart:io';

enum Direction { UP, DOWN, LEFT, RIGHT }

typedef Flag = Map<Direction, bool>;
typedef Coord = ({int x, int y, Direction direction});

void main() {
  List<String> input = [];

  var line = stdin.readLineSync();
  while (line != null) {
    input.add(line);
    line = stdin.readLineSync();
  }

  List<Coord> startingCoords = [];
  for (var i = 0; i < input.length; i++) {
    startingCoords.add((x: 0, y: i, direction: Direction.RIGHT));
    startingCoords.add((x: input.length - 1, y: i, direction: Direction.LEFT));
  }

  for (var i = 0; i < input[0].length; i++) {
    startingCoords.add((x: i, y: 0, direction: Direction.DOWN));
    startingCoords.add((x: i, y: input[0].length - 1, direction: Direction.UP));
  }

  var maxEnergized = 0;
  for (final startingCoord in startingCoords) {
    List<List<Flag>> flags = initFlags(input);

    List<Coord> queue = [startingCoord];
    while (queue.length > 0) {
      var coord = queue.removeLast();
      var next = traverseOne(coord, input, flags);
      for (final nextCoord in next) {
        if (nextCoord.y >= 0 &&
            nextCoord.y < input.length &&
            nextCoord.x >= 0 &&
            nextCoord.x < input[nextCoord.y].length) {
          queue.add(nextCoord);
        }
      }
    }

    var energized = 0;
    for (final line in flags) {
      for (final flag in line) {
        if (flag[Direction.UP] == true ||
            flag[Direction.DOWN] == true ||
            flag[Direction.LEFT] == true ||
            flag[Direction.RIGHT] == true) {
          energized++;
        }
      }
    }

    // print("$startingCoord : $energized");

    if (energized > maxEnergized) {
      maxEnergized = energized;
    }
  }

  print(maxEnergized);
}

List<Coord> traverseOne(Coord start, List<String> map, List<List<Flag>> flags) {
  var flag = flags[start.y][start.x];

  if (flag[start.direction] == true) {
    return [];
  }
  flags[start.y][start.x][start.direction] = true;

  switch (map[start.y][start.x]) {
    case '.':
      var nextX = start.x;
      var nextY = start.y;
      switch (start.direction) {
        case Direction.UP:
          nextY -= 1;
          break;
        case Direction.DOWN:
          nextY += 1;
          break;
        case Direction.LEFT:
          nextX -= 1;
          break;
        case Direction.RIGHT:
          nextX += 1;
          break;
      }
      return [(x: nextX, y: nextY, direction: start.direction)];
      break;
    case '/':
      var nextX = start.x;
      var nextY = start.y;
      var nextDir = start.direction;
      switch (start.direction) {
        case Direction.UP:
          nextDir = Direction.RIGHT;
          nextX += 1;
          break;
        case Direction.DOWN:
          nextDir = Direction.LEFT;
          nextX -= 1;
          break;
        case Direction.LEFT:
          nextDir = Direction.DOWN;
          nextY += 1;
          break;
        case Direction.RIGHT:
          nextDir = Direction.UP;
          nextY -= 1;
          break;
      }
      return [(x: nextX, y: nextY, direction: nextDir)];
      break;
    case '\\':
      var nextX = start.x;
      var nextY = start.y;
      var nextDir = start.direction;
      switch (start.direction) {
        case Direction.UP:
          nextDir = Direction.LEFT;
          nextX -= 1;
          break;
        case Direction.DOWN:
          nextDir = Direction.RIGHT;
          nextX += 1;
          break;
        case Direction.LEFT:
          nextDir = Direction.UP;
          nextY -= 1;
          break;
        case Direction.RIGHT:
          nextDir = Direction.DOWN;
          nextY += 1;
          break;
      }
      return [(x: nextX, y: nextY, direction: nextDir)];
      break;
    case '|':
      switch (start.direction) {
        case Direction.UP:
          return [(x: start.x, y: start.y - 1, direction: start.direction)];
          break;
        case Direction.DOWN:
          return [(x: start.x, y: start.y + 1, direction: start.direction)];
          break;
        case Direction.LEFT:
          return [
            (x: start.x, y: start.y - 1, direction: Direction.UP),
            (x: start.x, y: start.y + 1, direction: Direction.DOWN)
          ];
          break;
        case Direction.RIGHT:
          return [
            (x: start.x, y: start.y - 1, direction: Direction.UP),
            (x: start.x, y: start.y + 1, direction: Direction.DOWN)
          ];
          break;
      }
    case '-':
      switch (start.direction) {
        case Direction.LEFT:
          return [(x: start.x - 1, y: start.y, direction: start.direction)];
          break;
        case Direction.RIGHT:
          return [(x: start.x + 1, y: start.y, direction: start.direction)];
          break;
        case Direction.UP:
          return [
            (x: start.x - 1, y: start.y, direction: Direction.LEFT),
            (x: start.x + 1, y: start.y, direction: Direction.RIGHT)
          ];
          break;
        case Direction.DOWN:
          return [
            (x: start.x - 1, y: start.y, direction: Direction.LEFT),
            (x: start.x + 1, y: start.y, direction: Direction.RIGHT)
          ];
          break;
      }
      break;
    default:
      throw "How did character not match?? $map[start.y][start.x]";
  }
}

List<List<Flag>> initFlags(List<String> input) {
  List<List<Flag>> flags = [];
  for (var y = 0; y < input.length; y++) {
    flags.add([]);
    for (var x = 0; x < input[y].length; x++) {
      flags[y].add({
        Direction.UP: false,
        Direction.DOWN: false,
        Direction.LEFT: false,
        Direction.RIGHT: false,
      });
    }
  }

  return flags;
}
