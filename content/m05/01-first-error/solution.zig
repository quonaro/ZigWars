const std = @import("std");

/// Деление a на b; при b == 0 — error.DivisionByZero.
pub fn divide(a: i32, b: i32) error{DivisionByZero}!i32 {
    // TODO: если b == 0 верни error.DivisionByZero, иначе @divTrunc(a, b)
    _ = a;
    _ = b;
    return error.DivisionByZero;
}
