const std = @import("std");
const sol = @import("solution.zig");

test "возраст u8 и округление" {
    const alloc = std.testing.allocator;
    const r = try sol.fmtUser(alloc, "Бабушка", 255, 66.666);
    defer alloc.free(r);
    try std.testing.expectEqualStrings("Бабушка, 255 лет, счёт 66.67", r);
}

test "отрицательный счёт" {
    const r = try sol.fmtUser(std.testing.allocator, "Loser", 42, -3.5);
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("Loser, 42 лет, счёт -3.50", r);
}

test "большой счёт" {
    const r = try sol.fmtUser(std.testing.allocator, "Чемпион", 99, 1234.5678);
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("Чемпион, 99 лет, счёт 1234.57", r);
}

test "сверка с alloc.print" {
    const alloc = std.testing.allocator;
    const cases = [_]struct { n: []const u8, a: u8, s: f64 }{
        .{ .n = "x", .a = 1, .s = 0.001 },
        .{ .n = "Тест", .a = 55, .s = 1.234 },
        .{ .n = "A B", .a = 8, .s = 99.99 },
    };
    for (cases) |c| {
        const got = try sol.fmtUser(alloc, c.n, c.a, c.s);
        defer alloc.free(got);
        const want = try alloc.print("{s}, {d} лет, счёт {d:.2}", .{ c.n, c.a, c.s });
        defer alloc.free(want);
        try std.testing.expectEqualStrings(want, got);
    }
}
