const std = @import("std");
const sol = @import("solution.zig");

const io = std.testing.io;
const path = "/tmp/zigwars_m05_05.txt";

fn writeFile(content: []const u8) !void {
    var f = try std.Io.Dir.cwd().createFile(io, path, .{});
    defer f.close(io);
    try f.writeStreamingAll(io, content);
}

fn cleanup() void {
    std.Io.Dir.cwd().deleteFile(io, path) catch {};
}

test "размер файла" {
    try writeFile("hello zig");
    defer cleanup();
    try std.testing.expectEqual(@as(usize, 9), try sol.processFile(path));
}

test "пустой файл" {
    try writeFile("");
    defer cleanup();
    try std.testing.expectEqual(@as(usize, 0), try sol.processFile(path));
}

test "большое содержимое" {
    var buf: [1000]u8 = undefined;
    @memset(&buf, 'x');
    try writeFile(&buf);
    defer cleanup();
    try std.testing.expectEqual(@as(usize, 1000), try sol.processFile(path));
}

test "несуществующий файл" {
    cleanup();
    try std.testing.expectError(error.FileNotFound, sol.processFile(path));
}
