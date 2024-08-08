const std = @import("std");
const part_1 = @import("part_1.zig");
const part_2 = @import("part_2.zig");
const Allocator = std.mem.Allocator;

const input_file = "input";
const max_file_size = 15_000;

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // Read input
    var input: [max_file_size]u8 = std.mem.zeroes([max_file_size]u8);
    try readInput(input_file, &input);

    const part_1_total = part_1.main(&input);
    try stdout.print("Part 1 final total: {!d}\n", .{part_1_total});
    try bw.flush();
    const part_2_total = part_2.main(&input);
    try stdout.print("Part 2 final total: {!d}\n", .{part_2_total});
    try bw.flush();
}

pub fn readInput(filename: []const u8, buffer: []u8) !void {
    _ = try std.fs.cwd().readFile(filename, buffer);
}
