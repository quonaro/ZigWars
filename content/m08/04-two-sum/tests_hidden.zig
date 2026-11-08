const std = @import("std");
const sol = @import("solution.zig");

const A = std.testing.allocator;

const Case = struct {
    xs: []const i32,
    target: i32,
    want: ?[2]usize,
};

test "свойства ответа — индексы валидны и сумма сходится" {
    const cases = [_]Case{
        .{ .xs = &.{ 5, 5, 5 }, .target = 10, .want = .{ 0, 1 } },
        .{ .xs = &.{ 1, 5, 3, 3 }, .target = 6, .want = .{ 0, 1 } },
        .{ .xs = &.{ -3, 4, 3, 90 }, .target = 0, .want = .{ 0, 2 } },
        .{ .xs = &.{ 0, 4, 3, 0 }, .target = 0, .want = .{ 0, 3 } },
        .{ .xs = &.{ 100, -100, 7 }, .target = 0, .want = .{ 0, 1 } },
    };
    for (cases) |c| {
        const got = try sol.twoSum(A, c.xs, c.target);
        const ij = got orelse return error.TestUnexpectedResult;
        try std.testing.expectEqual(c.want.?, ij);
        // анти-хардкод: проверяем семантику, а не только конкретные индексы
        try std.testing.expect(ij[0] < ij[1]);
        try std.testing.expectEqual(c.target, c.xs[ij[0]] + c.xs[ij[1]]);
    }
}

test "пара есть, но не та что кажется" {
    // первый возможный партнёр не обязан быть первым элементом
    try std.testing.expectEqual(@as(?[2]usize, .{ 1, 2 }), try sol.twoSum(A, &.{ 9, 2, 4, 1 }, 6));
    try std.testing.expectEqual(@as(?[2]usize, .{ 2, 3 }), try sol.twoSum(A, &.{ 9, 9, 1, 5 }, 6));
}

test "пара действительно отсутствует" {
    // брутфорс-проверка: ни одна пара не даёт target
    const xs = [_]i32{ 1, 3, 7, 15, 31 };
    const target: i32 = 50;
    for (xs, 0..) |a, i| {
        for (xs[i + 1 ..]) |b| {
            try std.testing.expect(a + b != target);
        }
    }
    try std.testing.expectEqual(@as(?[2]usize, null), try sol.twoSum(A, &xs, target));
    try std.testing.expectEqual(@as(?[2]usize, null), try sol.twoSum(A, &.{ 1, 1, 1 }, 3));
}

test "экстремумы i32 не ломают" {
    const xs = [_]i32{ std.math.maxInt(i32), -5, std.math.minInt(i32) };
    // maxInt + minInt = -1
    try std.testing.expectEqual(@as(?[2]usize, .{ 0, 2 }), try sol.twoSum(A, &xs, -1));
}
