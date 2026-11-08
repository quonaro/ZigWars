const std = @import("std");

/// Сколько шагов Коллатца нужно, чтобы из n получить 1.
pub fn collatzSteps(n: u64) usize {
    var x = n;
    var steps: usize = 0;
    while (x != 1) {
        x = if (@rem(x, 2) == 0) x / 2 else 3 * x + 1;
        steps += 1;
    }
    return steps;
}
