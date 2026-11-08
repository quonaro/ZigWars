const std = @import("std");
const sol = @import("solution.zig");

const io = std.testing.io;
const alloc = std.testing.allocator;
const cwd = std.Io.Dir.cwd();

var counter: usize = 0;

fn withFile(text: []const u8) ![]const u8 {
    counter += 1;
    const path = try alloc.print("/tmp/zw_m10_02_{d}.txt", .{counter});
    var f = try cwd.createFile(io, path, .{});
    defer f.close(io);
    try f.writeStreamingAll(io, text);
    return path;
}

test "пустой файл — 0 строк" {
    const path = try withFile("");
    defer alloc.free(path);
    defer cwd.deleteFile(io, path) catch {};
    try std.testing.expectEqual(0, try sol.countLines(io, alloc, path));
}

test "одна строка без перевода" {
    const path = try withFile("a");
    defer alloc.free(path);
    defer cwd.deleteFile(io, path) catch {};
    try std.testing.expectEqual(1, try sol.countLines(io, alloc, path));
}

test "строка с финальным \\n" {
    const path = try withFile("a\n");
    defer alloc.free(path);
    defer cwd.deleteFile(io, path) catch {};
    try std.testing.expectEqual(1, try sol.countLines(io, alloc, path));
}

test "две строки — разные финалы" {
    const p1 = try withFile("a\nb");
    defer alloc.free(p1);
    defer cwd.deleteFile(io, p1) catch {};
    try std.testing.expectEqual(2, try sol.countLines(io, alloc, p1));

    const p2 = try withFile("a\nb\n");
    defer alloc.free(p2);
    defer cwd.deleteFile(io, p2) catch {};
    try std.testing.expectEqual(2, try sol.countLines(io, alloc, p2));
}

test "пустые строки считаются" {
    const p1 = try withFile("a\n\n");
    defer alloc.free(p1);
    defer cwd.deleteFile(io, p1) catch {};
    try std.testing.expectEqual(2, try sol.countLines(io, alloc, p1));

    const p2 = try withFile("\n\n\n");
    defer alloc.free(p2);
    defer cwd.deleteFile(io, p2) catch {};
    try std.testing.expectEqual(3, try sol.countLines(io, alloc, p2));
}

test "много строк" {
    const path = try withFile("x\ny\nz\nw\nv");
    defer alloc.free(path);
    defer cwd.deleteFile(io, path) catch {};
    try std.testing.expectEqual(5, try sol.countLines(io, alloc, path));
}
