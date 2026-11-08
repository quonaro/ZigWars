const std = @import("std");

/// Индексы {i, j}, i < j, такие что xs[i] + xs[j] == target. Или null.
pub fn twoSum(alloc: std.mem.Allocator, xs: []const i32, target: i32) !?[2]usize {
    var seen = std.AutoHashMap(i32, usize).init(alloc);
    defer seen.deinit();
    for (xs, 0..) |x, i| {
        if (seen.get(target - x)) |j| return .{ j, i };
        try seen.put(x, i);
    }
    return null;
}
