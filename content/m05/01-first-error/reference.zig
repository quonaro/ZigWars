const std = @import("std");

/// Деление a на b; при b == 0 — error.DivisionByZero.
pub fn divide(a: i32, b: i32) error{DivisionByZero}!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}
