const std = @import("std");

/// Зажимает x в диапазон [lo, hi].
pub fn clamp(x: i32, lo: i32, hi: i32) i32 {
    return if (x < lo) lo else if (x > hi) hi else x;
}
