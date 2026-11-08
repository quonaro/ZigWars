const std = @import("std");
const sol = @import("solution.zig");

const io = std.testing.io;
const alloc = std.testing.allocator;
const cwd = std.Io.Dir.cwd();

var counter: usize = 0;

fn makeFile(text: []const u8) ![]const u8 {
    counter += 1;
    const path = try alloc.print("/tmp/zw_m10_01h_{d}.txt", .{counter});
    var f = try cwd.createFile(io, path, .{});
    defer f.close(io);
    try f.writeStreamingAll(io, text);
    return path;
}

test "dst перезаписывается" {
    const src = try makeFile("ab");
    defer alloc.free(src);
    defer cwd.deleteFile(io, src) catch {};
    const dst = try makeFile("OLD OLD OLD");
    defer alloc.free(dst);
    defer cwd.deleteFile(io, dst) catch {};

    try sol.copyUpper(io, alloc, src, dst);
    const out = try cwd.readFileAlloc(io, dst, alloc, .limited(1 << 16));
    defer alloc.free(out);
    try std.testing.expectEqualStrings("AB", out);
}

test "границы диапазона a-z точны" {
    const src = try makeFile("`azz{ ~}~`A`Z[");
    defer alloc.free(src);
    defer cwd.deleteFile(io, src) catch {};
    const dst = "/tmp/zw_m10_01h_out1.txt";
    defer cwd.deleteFile(io, dst) catch {};

    try sol.copyUpper(io, alloc, src, dst);
    const out = try cwd.readFileAlloc(io, dst, alloc, .limited(1 << 16));
    defer alloc.free(out);
    // '`' (до 'a') и '{' (после 'z') не трогаем
    try std.testing.expectEqualStrings("`AZZ{ ~}~`A`Z[", out);
}

test "байты > 127 не портятся" {
    const src = try makeFile("\xFF\x80\xC3\xA9abc\x00z");
    defer alloc.free(src);
    defer cwd.deleteFile(io, src) catch {};
    const dst = "/tmp/zw_m10_01h_out2.txt";
    defer cwd.deleteFile(io, dst) catch {};

    try sol.copyUpper(io, alloc, src, dst);
    const out = try cwd.readFileAlloc(io, dst, alloc, .limited(1 << 16));
    defer alloc.free(out);
    try std.testing.expectEqualStrings("\xFF\x80\xC3\xA9ABC\x00Z", out);
}

test "dst в несуществующей директории — ошибка" {
    const src = try makeFile("data");
    defer alloc.free(src);
    defer cwd.deleteFile(io, src) catch {};
    try std.testing.expectError(
        error.FileNotFound,
        sol.copyUpper(io, alloc, src, "/tmp/zw_no_such_dir_17/out.txt"),
    );
}

test "большой файл" {
    var content_list: std.ArrayList(u8) = .empty;
    defer content_list.deinit(alloc);
    for (0..500) |_| try content_list.appendSlice(alloc, "hello world\n");
    const content = content_list.items; // 6000 байт
    const src = try makeFile(content);
    defer alloc.free(src);
    defer cwd.deleteFile(io, src) catch {};
    const dst = "/tmp/zw_m10_01h_big.txt";
    defer cwd.deleteFile(io, dst) catch {};

    try sol.copyUpper(io, alloc, src, dst);
    const out = try cwd.readFileAlloc(io, dst, alloc, .limited(1 << 16));
    defer alloc.free(out);
    try std.testing.expectEqual(content.len, out.len);
    try std.testing.expectEqualStrings("HELLO WORLD\n", out[0..12]);
    try std.testing.expectEqualStrings("HELLO WORLD\n", out[out.len - 12 ..]);
    for (out) |c| {
        try std.testing.expect(!(c >= 'a' and c <= 'z'));
    }
}
