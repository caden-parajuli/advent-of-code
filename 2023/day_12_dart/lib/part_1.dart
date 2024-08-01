import 'dart:io';

const filename = "input";

List<String> readInput(filename) {
  String contents = File('./$filename').readAsStringSync();
  final List<String> lines = contents.split('\n');
  return lines;
}

void mainPart1() {
  List<String> lines = readInput(filename);

  int total = 0;
  for (final String line in lines) {
    int lineVal = computeLine(line);
    total += lineVal;
  }

  print("Part 1 final total: $total");
}

int computeLine(String line) {
  if (line == "") {
    return 0;
  }

  final List<String> parts = line.split(' ');
  List<String> springs = parts[0].split('');
  final List<int> spaces =
      parts[1].split(',').map((space) => int.parse(space)).toList();

  return recurseLine(springs, spaces, 0, 0);
}

bool lineWorks(List<String> line, final List<int> spaces) {
  int spaceLen = 0;
  int space = 0;
  for (int i = 0; i < line.length; i++) {
    // .
    if (spaceLen > 0 && line[i] == '.') {
      if (space >= spaces.length || spaceLen != spaces[space]) {
        return false;
      }
      spaceLen = 0;
      ++space;
    }
    // #
    else if (line[i] == '#') {
      ++spaceLen;
    }
  }
  // Ends in #
  if (spaceLen > 0) {
    if (space != spaces.length - 1 || spaces[space] != spaceLen) {
      return false;
    }
  }
  // Ends in .
  else if (space != spaces.length) {
    return false;
  }
  return true;
}

// Yes, I'm aware this is very naive and inefficient. The part 2 solution is much
// better and uses dynamic programming
int recurseLine(List<String> line, List<int> spaces, int index, int total) {
  if (index == line.length) {
    if (lineWorks(line, spaces)) {
      return total + 1;
    } else {
      return total;
    }
  } else if (line[index] != '?') {
    return recurseLine(line, spaces, index + 1, total);
  }

  line[index] = '#';
  int first = recurseLine(line, spaces, index + 1, total);

  line[index] = '.';
  int second = recurseLine(line, spaces, index + 1, total);

  line[index] = '?';
  return first + second;
}
