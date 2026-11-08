const std = @import("std");

/// Меняет местами значения по двум указателям.
pub fn swap(a: *i32, b: *i32) void {
    const tmp = a.*;
    a.* = b.*;
    b.* = tmp;
}

/// Прибавляет delta к каждому элементу слайса.
pub fn incAll(xs: []i32, delta: i32) void {
    for (xs) |*x| {
        x.* += delta;
    }
}
