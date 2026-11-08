const std = @import("std");

/// Индекс первого максимального элемента; null для пустого слайса.
pub fn indexOfMax(xs: []const i32) ?usize {
    if (xs.len == 0) return null;
    var best: usize = 0;
    for (xs[1..], 1..) |x, i| {
        if (x > xs[best]) best = i;
    }
    return best;
}
