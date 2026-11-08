const std = @import("std");
const sol = @import("solution.zig");

test "успех — отката нет" {
    sol.resetRollback();
    try sol.riskyOp(false);
    try sol.riskyOp(false);
    try std.testing.expectEqual(@as(usize, 0), sol.rollbackCount());
}

test "ошибка — откат сработал" {
    sol.resetRollback();
    try std.testing.expectError(error.SimulatedFailure, sol.riskyOp(true));
    try std.testing.expectEqual(@as(usize, 1), sol.rollbackCount());
}

test "каждый провал — свой откат" {
    sol.resetRollback();
    _ = sol.riskyOp(true) catch {};
    _ = sol.riskyOp(true) catch {};
    try sol.riskyOp(false);
    _ = sol.riskyOp(true) catch {};
    try std.testing.expectEqual(@as(usize, 3), sol.rollbackCount());
}
