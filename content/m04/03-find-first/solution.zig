const std = @import("std");

/// Первый элемент xs, для которого pred(x) == true; иначе null.
pub fn findFirst(xs: []const i32, pred: fn (i32) bool) ?i32 {
    // TODO: for (xs) |x| — если pred(x), верни x; после цикла — null
    _ = xs;
    _ = pred;
    return null;
}
