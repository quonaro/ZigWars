const std = @import("std");
const sol = @import("solution.zig");

const io = std.testing.io;
const alloc = std.testing.allocator;
const cwd = std.Io.Dir.cwd();

var counter: usize = 0;

fn withFile(text: []const u8) ![]const u8 {
    counter += 1;
    const path = try alloc.print("/tmp/zw_m10_02h_{d}.txt", .{counter});
    var f = try cwd.createFile(io, path, .{});
    defer f.close(io);
    try f.writeStreamingAll(io, text);
    return path;
}

fn expectLines(text: []const u8, want: usize) !void {
    const path = try withFile(text);
    defer alloc.free(path);
    defer cwd.deleteFile(io, path) catch {};
    try std.testing.expectEqual(want, try sol.countLines(io, alloc, path));
}

test "пробелы — не разделители строк" {
    try expectLines(" ", 1);
    try expectLines("  \t  ", 1);
    try expectLines(" \n ", 2);
}

test "\\r не считается переводом строки" {
    try expectLines("a\rb", 1);
    try expectLines("a\r\nb", 2); // одна '\n' — одна граница
}

test "файл только из одного \\n и смешанные финалы" {
    try expectLines("\n", 1);
    try expectLines("x\n\n\n", 3);
    try expectLines("\nabc", 2);
}

test "много строк" {
    var buf: std.ArrayList(u8) = .empty;
    defer buf.deinit(alloc);
    for (0..500) |_| try buf.appendSlice(alloc, "x\n");
    try expectLines(buf.items, 500);

    try buf.appendSlice(alloc, "x");
    try expectLines(buf.items, 501);
}

test "несуществующий файл — ошибка" {
    try std.testing.expectError(
        error.FileNotFound,
        sol.countLines(io, alloc, "/tmp/zw_m10_02h_no_such.txt"),
    );
}
