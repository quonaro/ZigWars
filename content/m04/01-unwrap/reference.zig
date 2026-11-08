const std = @import("std");

/// Значение из x, а если x == null — default.
pub fn unwrapOr(x: ?i32, default: i32) i32 {
    return x orelse default;
}

/// Достать значение из x; при null — panic.
pub fn unwrapPanic(x: ?i32) i32 {
    return x.?;
}
