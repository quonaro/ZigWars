const std = @import("std");

/// Comptime-описание типа строкой. См. task.md для формата.
pub fn describe(comptime T: type) []const u8 {
    // TODO: реализуй меня через switch (@typeInfo(T))
    _ = T;
    return "";
}
