const std = @import("std");

/// "<имя>, <возраст> лет, счёт <очки с 2 знаками>". Освобождает вызывающий.
pub fn fmtUser(alloc: std.mem.Allocator, name: []const u8, age: u8, score: f64) ![]u8 {
    return alloc.print("{s}, {d} лет, счёт {d:.2}", .{ name, age, score });
}
