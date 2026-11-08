const std = @import("std");

/// Comptime-описание типа строкой.
pub fn describe(comptime T: type) []const u8 {
    return switch (@typeInfo(T)) {
        .int => |info| switch (info.signedness) {
            .signed => std.fmt.comptimePrint("знаковое целое, {d} бит", .{info.bits}),
            .unsigned => std.fmt.comptimePrint("беззнаковое целое, {d} бит", .{info.bits}),
        },
        .float => |info| std.fmt.comptimePrint("число с плавающей точкой, {d} бит", .{info.bits}),
        .bool => "логический",
        .pointer => |info| if (info.size == .slice)
            std.fmt.comptimePrint("слайс на {s}", .{@typeName(info.child)})
        else
            std.fmt.comptimePrint("указатель на {s}", .{@typeName(info.child)}),
        else => std.fmt.comptimePrint("другое: {s}", .{@typeName(T)}),
    };
}
