const std = @import("std");

/// Максимум двух значений одного типа.
pub fn maxOf(a: anytype, b: @TypeOf(a)) @TypeOf(a) {
    // TODO: реализуй меня
    _ = b;
    return a;
}

/// Сумма двух значений произвольных (возможно разных) числовых типов.
pub fn add(a: anytype, b: anytype) @TypeOf(a, b) {
    // TODO: реализуй меня (параметры уже «используются» в @TypeOf — сброс не нужен)
    return 0;
}
