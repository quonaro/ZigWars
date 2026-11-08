const std = @import("std");

/// Значение из x, а если x == null — default.
pub fn unwrapOr(x: ?i32, default: i32) i32 {
    // TODO: x orelse default
    _ = x;
    _ = default;
    return 0;
}

/// Достать значение из x; при null — panic.
pub fn unwrapPanic(x: ?i32) i32 {
    // TODO: x.?
    _ = x;
    return 0;
}
