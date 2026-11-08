const std = @import("std");

/// Сумма элементов слайса. Пустой слайс → 0.
pub fn sumSlice(xs: []const i32) i64 {
    var total: i64 = 0;
    for (xs) |x| {
        total += x;
    }
    return total;
}
