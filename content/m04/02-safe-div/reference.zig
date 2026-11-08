const std = @import("std");

/// Деление a на b с усечением к нулю; при b == 0 — null.
pub fn safeDiv(a: i32, b: i32) ?i32 {
    if (b == 0) return null;
    return @divTrunc(a, b);
}
