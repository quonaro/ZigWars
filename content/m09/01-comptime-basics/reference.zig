const std = @import("std");

/// Верни квадрат n. Значение вычисляется при компиляции.
pub fn comptimeSquare(comptime n: u32) u32 {
    return n * n;
}

/// Верни n! через comptime-вычисление.
pub fn comptimeFactorial(comptime n: u32) u64 {
    comptime var result: u64 = 1;
    comptime var i: u32 = 2;
    inline while (i <= n) : (i += 1) {
        result *= i;
    }
    return result;
}
