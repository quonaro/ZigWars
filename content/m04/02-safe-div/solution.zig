const std = @import("std");

/// Деление a на b с усечением к нулю; при b == 0 — null.
pub fn safeDiv(a: i32, b: i32) ?i32 {
    // TODO: если b == 0 верни null, иначе @divTrunc(a, b)
    _ = a;
    _ = b;
    return null;
}
