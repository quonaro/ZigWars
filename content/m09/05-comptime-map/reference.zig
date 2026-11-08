const std = @import("std");

const fib_table = blk: {
    var t: [93]u64 = undefined;
    t[0] = 0;
    t[1] = 1;
    for (2..93) |i| {
        t[i] = t[i - 1] + t[i - 2];
    }
    break :blk t;
};

/// Число Фибоначчи n через comptime-таблицу. n <= 92.
pub fn fib(comptime n: u8) u64 {
    if (n >= fib_table.len) {
        @compileError("fib: n > 92 не влезает в u64");
    }
    return fib_table[n];
}

/// Сумма lo..hi включительно. Только для целочисленных T.
pub fn rangeSum(comptime T: type, comptime lo: T, comptime hi: T) T {
    switch (@typeInfo(T)) {
        .int => {},
        else => @compileError("rangeSum: нужен целочисленный тип, а не " ++ @typeName(T)),
    }
    var sum: T = 0;
    var i: T = lo;
    while (i <= hi) : (i += 1) {
        sum += i;
    }
    return sum;
}
