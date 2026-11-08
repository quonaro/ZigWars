const std = @import("std");

/// Дженерик-стек. Возвращает структуру, параметризованную типом T.
/// TODO: заполни методы реальной логикой.
pub fn Stack(comptime T: type) type {
    return struct {
        items: std.ArrayList(T) = .empty,

        pub fn push(self: *@This(), alloc: std.mem.Allocator, item: T) !void {
            // TODO: реализуй меня
            _ = self;
            _ = alloc;
            _ = item;
        }

        pub fn pop(self: *@This()) ?T {
            // TODO: реализуй меня
            _ = self;
            return null;
        }

        pub fn isEmpty(self: *const @This()) bool {
            // TODO: реализуй меня
            _ = self;
            return true;
        }
    };
}
