const std = @import("std");

/// Дженерик-стек. Возвращает структуру, параметризованную типом T.
pub fn Stack(comptime T: type) type {
    return struct {
        items: std.ArrayList(T) = .empty,

        pub fn push(self: *@This(), alloc: std.mem.Allocator, item: T) !void {
            try self.items.append(alloc, item);
        }

        pub fn pop(self: *@This()) ?T {
            return self.items.pop();
        }

        pub fn isEmpty(self: *const @This()) bool {
            return self.items.items.len == 0;
        }
    };
}
