import 'dart:io';

const filename = "input";

List<String> readInput(filename) {
  String contents = File('./$filename').readAsStringSync();
  final List<String> lines = contents.split('\n');
  return lines;
}

void mainPart2() {
  List<String> lines = readInput(filename);

  int total = 0;
  for (final String line in lines) {
    int lineVal = computeLine(line);
    total += lineVal;
  }

  print("Part 2 final total: $total");
}

/// Wrapper function for recurseLine
int computeLine(String line) {
  if (line == "") {
    return 0;
  }

  final List<String> parts = line.split(' ');
  List<String> springs = "${parts[0]}?${parts[0]}?${parts[0]}?${parts[0]}?${parts[0]}".split('');
  List<int> spaces = parts[1].split(',').map((space) => int.parse(space)).toList();
  spaces = spaces + spaces + spaces + spaces + spaces;

  // For maximum efficiency we could use an array of `int?` but this is unnecessary
  Map<(int, int, int), int> cache = <(int, int, int), int>{};

  return recurseLine(springs, spaces, 0, 0, 0, cache);
}

/// Uses dynamic programming to compute the total for a line
int recurseLine(List<String> line, List<int> spaces, int index, int space,
    int spaceLen, Map<(int, int, int), int> cache) {
  (int, int, int) key = (index, space, spaceLen);
  // Check cache
  if (cache.containsKey(key)) {
    return cache[key]!;
  }

  // Base cases
  if (index >= line.length) {
    if (spaceLen > 0) {
      if (space != spaces.length - 1 || spaces[space] != spaceLen) {
        cache[key] = 0;
        return 0;
      }
    } else if (space != spaces.length) {
      cache[key] = 0;
      return 0;
    }
    cache[key] = 1;
    return 1;
  }

  if (line[index] == '#') {
    if (space >= spaces.length) {
      cache[key] = 0;
      return 0;
    }
    int val = recurseLine(line, spaces, index + 1, space, spaceLen + 1, cache);
    cache[key] = val;
    return val;
  }

  if (line[index] == '.') {
    if (spaceLen > 0) {
      if (spaces[space] != spaceLen) {
        cache[key] = 0;
        return 0;
      }
      int val = recurseLine(line, spaces, index + 1, space + 1, 0, cache);
      cache[key] = val;
      return val;
    }
    int val = recurseLine(line, spaces, index + 1, space, 0, cache);
    cache[key] = val;
    return val;
  }

  if (line[index] == '?') {
    // #
    int octo = 0;
    if (space < spaces.length) {
      octo = recurseLine(line, spaces, index + 1, space, spaceLen + 1, cache);
    }
    // .
    if (spaceLen > 0) {
      if (spaces[space] != spaceLen) {
        cache[key] = octo;
        return octo;
      }
      int val =
          octo + recurseLine(line, spaces, index + 1, space + 1, 0, cache);
      cache[key] = val;
      return val;
    }
    int val = octo + recurseLine(line, spaces, index + 1, space, 0, cache);
    cache[key] = val;
    return val;
  }
  print("ERROR: Invalid character.");
  return 0;
}
