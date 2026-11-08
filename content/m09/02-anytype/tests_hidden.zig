const std = @import("std");
const sol = @import("solution.zig");

test "равные значения — любой порядок" {
    try std.testing.expectEqual(5, sol.maxOf(@as(i32, 5), @as(i32, 5)));
    try std.testing.expectApproxEqAbs(1.5, sol.maxOf(@as(f64, 1.5), @as(f64, 1.5)), 1e-12);
    // минус-ноль против нуля — не важно, кого вернём, значение то же
    try std.testing.expectEqual(0.0, sol.maxOf(@as(f64, -0.0), @as(f64, 0.0)));
}

test "экстремумы типа" {
    try std.testing.expectEqual(
        std.math.maxInt(i32),
        sol.maxOf(@as(i32, std.math.maxInt(i32)), @as(i32, std.math.minInt(i32))),
    );
    try std.testing.expectEqual(
        -1,
        sol.maxOf(@as(i64, std.math.minInt(i64)), @as(i64, -1)),
    );
    try std.testing.expectEqual(
        std.math.minInt(i64),
        sol.maxOf(@as(i64, std.math.minInt(i64)), @as(i64, std.math.minInt(i64))),
    );
    try std.testing.expectEqual(0, sol.maxOf(@as(u8, 0), @as(u8, 0)));
}

test "сумма — знаковый с беззнаковым" {
    const r = sol.add(@as(i16, -2), @as(u8, 3));
    try std.testing.expectEqual(1, r);
    try std.testing.expectEqual(i16, @TypeOf(r));
}

test "сумма — ноль и отрицания" {
    try std.testing.expectEqual(0, sol.add(@as(i32, -7), @as(i32, 7)));
    try std.testing.expectApproxEqAbs(0.0, sol.add(@as(f64, -2.5), @as(f64, 2.5)), 1e-12);
    try std.testing.expectEqual(255, sol.add(@as(u8, 200), @as(u8, 55)));
}

test "тип результата add выводится шире" {
    try std.testing.expectEqual(i64, @TypeOf(sol.add(@as(i64, 1), @as(i32, 2))));
    try std.testing.expectEqual(f32, @TypeOf(sol.add(@as(f32, 1.0), @as(f32, 2.0))));
}
