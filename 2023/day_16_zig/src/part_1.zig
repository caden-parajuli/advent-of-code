const std = @import("std");
const Allocator = std.mem.Allocator;

const DirError = error{
    BadChar,
    Newline,
    ShouldSplit,
};

const Direction = enum(usize) {
    Up = 0,
    Down = 1,
    Left = 2,
    Right = 3,
};

const Beam = struct { x: usize, y: usize, dir: Direction };
const Beams = struct {
    head: Beam,
    tail: ?*Beams,
};

pub fn main(input: []u8) !usize {
    const dimensions = getSize(input);

    var beams: ?*Beams = &(try std.heap.c_allocator.alloc(Beams, 1))[0];
    const start_dir = (try turn(input[0], Direction.Right))[0];
    beams.?.* = Beams{
        .head = Beam{
            .x = 0,
            .y = 0,
            .dir = start_dir
        },
        .tail = null,
    };

    var cache: [][4]bool = try std.heap.c_allocator.alloc([4]bool, dimensions[0] * dimensions[1]);
    cache[0][@intFromEnum(Direction.Right)] = true;

    while (beams) |_| {
        beams = try updateBeams(std.heap.c_allocator, beams, input, &dimensions, &cache);
    }

    return countCache(cache);
}

fn countCache(cache: [][4]bool) usize {
    var total: usize = 0;
    for (cache) |space| {
        if (space[0] or space[1] or space[2] or space[3]) {
            total += 1;
        }
    }
    return total;
}

fn getSize(input: []u8) struct { usize, usize } {
    var width: usize = undefined;
    for (input, 0..) |char, i| {
        if (char == '\n') {
            width = i;
            break;
        }
    }
    var height: usize = 0;
    while (input[height] != 0) {
        height += width + 1;
    }
    return .{ width, height / (width + 1) };
}

fn updateBeams(allocator: Allocator, beams: ?*Beams, input: []u8, dimensions: *const struct { usize, usize }, cache: *[][4]bool) !?*Beams {
    const stride = dimensions[0] + 1;

    var new_beams: ?*Beams = beams;
    var last_beams: ?*Beams = null;
    var current_beams: ?*Beams = beams;

    while (current_beams) |current| {
        const beam = current.head;
        const dir = beam.dir;

        const new_pos = goDir(beam, dimensions);
        if ((new_pos == null) or (cache.*[new_pos.?[0] + (stride - 1) * new_pos.?[1]][@intFromEnum(dir)] == true)) {
            // Remove from linked list
            if (last_beams == null) {
                // At the front
                new_beams = current.*.tail;
            } else {
                last_beams.?.*.tail = current.*.tail;
            }
            const temp = current.*.tail;
            allocator.destroy(current);
            current_beams = temp;
            continue;
        }

        // Update the entry
        const x, const y = new_pos.?;
        const char = input[x + y * stride];
        const new_dir = try turn(char, dir);
        current_beams.?.*.head = Beam{
            .x = x,
            .y = y,
            .dir = new_dir[0],
        };
        cache.*[new_pos.?[0] + (stride - 1) * new_pos.?[1]][@intFromEnum(dir)] = true;

        // Check if we need to add a beam
        if (new_dir[1]) {
            // Add another beam to the front of the linked list
            const another_beams = try allocator.create(Beams);
            another_beams.*.head = Beam{ .x = x, .y = y, .dir = switch (char) {
                '-' => Direction.Right,
                '|' => Direction.Down,
                else => return DirError.ShouldSplit,
            } };
            another_beams.tail = new_beams;
            new_beams = another_beams;
        }

        last_beams = current_beams;
        current_beams = current_beams.?.*.tail;
    }
    return new_beams;
}

fn turn(char: u8, dir: Direction) !struct { Direction, bool } {
    return switch (char) {
        '.' => .{ dir, false },
        '/' => switch (dir) {
            Direction.Up => .{ Direction.Right, false },
            Direction.Right => .{ Direction.Up, false },
            Direction.Left => .{ Direction.Down, false },
            Direction.Down => .{ Direction.Left, false },
        },
        '\\' => switch (dir) {
            Direction.Up => .{ Direction.Left, false },
            Direction.Left => .{ Direction.Up, false },
            Direction.Right => .{ Direction.Down, false },
            Direction.Down => .{ Direction.Right, false },
        },
        '-' => switch (dir) {
            Direction.Up => .{ Direction.Left, true },
            Direction.Down => .{ Direction.Left, true },
            Direction.Left => .{ Direction.Left, false },
            Direction.Right => .{ Direction.Right, false },
        },
        '|' => switch (dir) {
            Direction.Left => .{ Direction.Up, true },
            Direction.Right => .{ Direction.Up, true },
            Direction.Up => .{ Direction.Up, false },
            Direction.Down => .{ Direction.Down, false },
        },
        '\n' => DirError.Newline,
        else => {
            return DirError.BadChar;
        },
    };
}

fn goDir(beam: Beam, dim: *const struct { usize, usize }) ?struct { usize, usize } {
    switch (beam.dir) {
        Direction.Up => {
            if (beam.y == 0) {
                return null;
            }
            return .{ beam.x, beam.y - 1 };
        },
        Direction.Down => {
            if (beam.y >= dim[1] - 1) {
                return null;
            }
            return .{ beam.x, beam.y + 1 };
        },
        Direction.Left => {
            if (beam.x == 0) {
                return null;
            }
            return .{ beam.x - 1, beam.y };
        },
        Direction.Right => {
            if (beam.x >= dim[0] - 1) {
                return null;
            }
            return .{ beam.x + 1, beam.y };
        },
    }
}
