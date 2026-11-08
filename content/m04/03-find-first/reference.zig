const std = @import("std");

/// Первый элемент xs, для которого pred(x) == true; иначе null.
pub fn findFirst(xs: []const i32, pred: fn (i32) bool) ?i32 {
    for (xs) |x| {
        if (pred(x)) return x;
    }
    return null;
}
