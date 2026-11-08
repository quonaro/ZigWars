const std = @import("std");
const sol = @import("solution.zig");

const io = std.testing.io;
const alloc = std.testing.allocator;
const cwd = std.Io.Dir.cwd();

fn makeFile(path: []const u8, text: []const u8) !void {
    var f = try cwd.createFile(io, path, .{});
    defer f.close(io);
    try f.writeStreamingAll(io, text);
}

fn readAll(path: []const u8) ![]u8 {
    return cwd.readFileAlloc(io, path, alloc, .limited(1 << 16));
}

test "базовое преобразование" {
    const src = "/tmp/zw_m10_01_a.txt";
    const dst = "/tmp/zw_m10_01_b.txt";
    defer cwd.deleteFile(io, src) catch {};
    defer cwd.deleteFile(io, dst) catch {};

    try makeFile(src, "Hello Zig 0.17!");
    try sol.copyUpper(io, alloc, src, dst);

    const out = try readAll(dst);
    defer alloc.free(out);
    try std.testing.expectEqualStrings("HELLO ZIG 0.17!", out);
}

test "смешанный контент — трогаем только a-z" {
    const src = "/tmp/zw_m10_01_c.txt";
    const dst = "/tmp/zw_m10_01_d.txt";
    defer cwd.deleteFile(io, src) catch {};
    defer cwd.deleteFile(io, dst) catch {};

    try makeFile(src, "abc-XYZ-123-Привет!\nnewline\ttab");
    try sol.copyUpper(io, alloc, src, dst);

    const out = try readAll(dst);
    defer alloc.free(out);
    try std.testing.expectEqualStrings("ABC-XYZ-123-Привет!\nNEWLINE\tTAB", out);
}

test "пустой файл" {
    const src = "/tmp/zw_m10_01_e.txt";
    const dst = "/tmp/zw_m10_01_f.txt";
    defer cwd.deleteFile(io, src) catch {};
    defer cwd.deleteFile(io, dst) catch {};

    try makeFile(src, "");
    try sol.copyUpper(io, alloc, src, dst);

    const out = try readAll(dst);
    defer alloc.free(out);
    try std.testing.expectEqualStrings("", out);
}

test "исходный файл не существует" {
    try std.testing.expectError(
        error.FileNotFound,
        sol.copyUpper(io, alloc, "/tmp/zw_m10_01_no_such.txt", "/tmp/zw_m10_01_out.txt"),
    );
}
