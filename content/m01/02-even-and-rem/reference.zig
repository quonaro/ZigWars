const std = @import("std");

/// true, если n чётное.
pub fn isEven(n: i32) bool {
    return @rem(n, 2) == 0;
}

/// true, если n делится на d без остатка.
pub fn isMultipleOf(n: i32, d: i32) bool {
    return @rem(n, d) == 0;
}
