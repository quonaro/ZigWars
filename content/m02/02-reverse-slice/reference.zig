const std = @import("std");

/// Разворачивает элементы слайса на месте.
pub fn reverseInPlace(xs: []i32) void {
    var i: usize = 0;
    var j: usize = xs.len;
    while (i < j) {
        j -= 1;
        const tmp = xs[i];
        xs[i] = xs[j];
        xs[j] = tmp;
        i += 1;
    }
}
