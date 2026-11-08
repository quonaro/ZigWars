const std = @import("std");
const sol = @import("solution.zig");

test "буфер нулевой ёмкости" {
    var buf: [0]u8 = undefined;
    const got = try sol.concatFixed(&buf, "", "");
    try std.testing.expectEqualStrings("", got);
    try std.testing.expectError(error.OutOfMemory, sol.concatFixed(&buf, "a", ""));
    try std.testing.expectError(error.OutOfMemory, sol.concatFixed(&buf, "", "b"));
}

test "на один байт не влезло" {
    var buf: [5]u8 = undefined;
    try std.testing.expectError(error.OutOfMemory, sol.concatFixed(&buf, "abc", "def"));
    try std.testing.expectError(error.OutOfMemory, sol.concatFixed(&buf, "abcde", "x"));
}

test "большой буфер и длинные строки" {
    const alloc = std.testing.allocator;
    var a: std.ArrayList(u8) = .empty;
    defer a.deinit(alloc);
    var b: std.ArrayList(u8) = .empty;
    defer b.deinit(alloc);
    try a.appendNTimes(alloc, 'z', 300);
    try b.appendNTimes(alloc, '!', 100);

    var buf: [512]u8 = undefined;
    const got = try sol.concatFixed(&buf, a.items, b.items);
    try std.testing.expectEqual(@as(usize, 400), got.len);
    try std.testing.expectEqualStrings(a.items, got[0..300]);
    try std.testing.expectEqualStrings(b.items, got[300..]);
}

test "каждый вызов — с начала buf" {
    var buf: [16]u8 = undefined;
    const g1 = try sol.concatFixed(&buf, "aa", "bb");
    try std.testing.expectEqualStrings("aabb", g1);
    const g2 = try sol.concatFixed(&buf, "x", "yy");
    try std.testing.expectEqualStrings("xyy", g2);
    try std.testing.expectEqual(@intFromPtr(&buf[0]), @intFromPtr(g2.ptr));
}
