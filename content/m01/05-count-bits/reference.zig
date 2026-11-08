const std = @import("std");

/// Количество единичных бит в x. Без @popCount!
pub fn countOnes(x: u32) u32 {
    var v = x;
    var count: u32 = 0;
    while (v != 0) : (v &= v - 1) {
        count += 1;
    }
    return count;
}
