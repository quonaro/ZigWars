const std = @import("std");
const sol = @import("solution.zig");

const io = std.testing.io;
const path = "/tmp/zigwars_m05_05_hidden.txt";

fn writeFile(content: []const u8) !void {
    var f = try std.Io.Dir.cwd().createFile(io, path, .{});
    defer f.close(io);
    try f.writeStreamingAll(io, content);
}

fn cleanup() void {
    std.Io.Dir.cwd().deleteFile(io, path) catch {};
}

test "многострочный и юникодный файл" {
    const content = "строка один\nстрока два\nТри юникода привет!\n";
    try writeFile(content);
    defer cleanup();
    try std.testing.expectEqual(content.len, try sol.processFile(path));
}

test "бинарные данные" {
    var buf: [256]u8 = undefined;
    for (&buf, 0..) |*b, i| b.* = @intCast(i);
    try writeFile(&buf);
    defer cleanup();
    try std.testing.expectEqual(@as(usize, 256), try sol.processFile(path));
}

test "файл ровно 1 байт и большой файл" {
    try writeFile("Q");
    try std.testing.expectEqual(@as(usize, 1), try sol.processFile(path));
    var big: [20_000]u8 = undefined;
    @memset(&big, 'y');
    try writeFile(&big);
    defer cleanup();
    try std.testing.expectEqual(@as(usize, 20_000), try sol.processFile(path));
}

test "другой несуществующий путь" {
    try std.testing.expectError(error.FileNotFound, sol.processFile("/tmp/zigwars_m05_05_no_such_file_xyz.bin"));
}
