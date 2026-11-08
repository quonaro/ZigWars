const std = @import("std");

var rollbacks: usize = 0;

/// Сколько раз сработал откат.
pub fn rollbackCount() usize {
    return rollbacks;
}

/// Обнулить счётчик.
pub fn resetRollback() void {
    rollbacks = 0;
}

/// Операция с «ресурсом»: при fail — error.SimulatedFailure и откат.
pub fn riskyOp(fail: bool) !void {
    // «Ресурс захвачен» — при выходе по ошибке откатываем.
    errdefer rollbacks += 1;
    if (fail) return error.SimulatedFailure;
    // Успех: errdefer не сработал — «ресурс» остался у вызывающего.
}
