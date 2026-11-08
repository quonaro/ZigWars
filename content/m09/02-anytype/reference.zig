const std = @import("std");

/// Максимум двух значений одного типа.
pub fn maxOf(a: anytype, b: @TypeOf(a)) @TypeOf(a) {
    return if (a > b) a else b;
}

/// Сумма двух значений произвольных числовых типов.
pub fn add(a: anytype, b: anytype) @TypeOf(a, b) {
    return a + b;
}
