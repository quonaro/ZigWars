const std = @import("std");
const sol = @import("solution.zig");

test "длина обычных строк" {
    try std.testing.expectEqual(@as(usize, 5), sol.cStrLen("hello"));
    try std.testing.expectEqual(@as(usize, 3), sol.cStrLen("zig"));
    try std.testing.expectEqual(@as(usize, 1), sol.cStrLen("x"));
}

test "пустая строка" {
    try std.testing.expectEqual(@as(usize, 0), sol.cStrLen(""));
}

test "строка с пробелами и знаками" {
    try std.testing.expectEqual(@as(usize, 11), sol.cStrLen("hello, zig!"));
    try std.testing.expectEqual(@as(usize, 4), sol.cStrLen("a b "));
}

test "длина из слайса с сентинелом" {
    const arr: [6:0]u8 = .{ 'z', 'i', 'g', 'w', 'a', 'r' };
    const p: [*:0]const u8 = &arr;
    try std.testing.expectEqual(@as(usize, 6), sol.cStrLen(p));
}

test "равные строки" {
    try std.testing.expect(sol.equalZigStr("zig", "zig"));
    try std.testing.expect(sol.equalZigStr("", ""));
    try std.testing.expect(sol.equalZigStr("a b c", "a b c"));
}

test "неравные строки" {
    try std.testing.expect(!sol.equalZigStr("zig", "zigg"));
    try std.testing.expect(!sol.equalZigStr("zig", "zi"));
    try std.testing.expect(!sol.equalZigStr("zig", "Zig"));
    try std.testing.expect(!sol.equalZigStr("", "x"));
}

test "равенство с вычисленным слайсом" {
    const buf = "module";
    const slice = buf[0..3]; // "mod"
    try std.testing.expect(sol.equalZigStr("mod", slice));
    try std.testing.expect(!sol.equalZigStr("module", slice));
}
