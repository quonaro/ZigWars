const std = @import("std");
const sol = @import("solution.zig");

test "чередование успехов и провалов" {
    sol.resetRollback();
    var fails: usize = 0;
    var i: usize = 0;
    while (i < 10) : (i += 1) {
        const fail = (@rem(i, 3) == 0);
        if (sol.riskyOp(fail)) |_| {
            try std.testing.expect(!fail);
        } else |err| {
            try std.testing.expectEqual(error.SimulatedFailure, err);
            fails += 1;
        }
    }
    try std.testing.expectEqual(@as(usize, 4), fails);
    try std.testing.expectEqual(fails, sol.rollbackCount());
}

test "reset обнуляет" {
    sol.resetRollback();
    _ = sol.riskyOp(true) catch {};
    try std.testing.expectEqual(@as(usize, 1), sol.rollbackCount());
    sol.resetRollback();
    try std.testing.expectEqual(@as(usize, 0), sol.rollbackCount());
}

test "успех после провала не уменьшает счётчик" {
    sol.resetRollback();
    _ = sol.riskyOp(true) catch {};
    try sol.riskyOp(false);
    try sol.riskyOp(false);
    _ = sol.riskyOp(true) catch {};
    try std.testing.expectEqual(@as(usize, 2), sol.rollbackCount());
}
