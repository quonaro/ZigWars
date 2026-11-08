const std = @import("std");

pub const Op = enum {
    add,
    sub,
    mul,
    div,

    /// Символ операции: '+', '-', '*', '/'.
    pub fn symbol(op: Op) u8 {
        return switch (op) {
            .add => '+',
            .sub => '-',
            .mul => '*',
            .div => '/',
        };
    }

    /// Парсинг символа в операцию; незнакомый символ → null.
    pub fn fromChar(c: u8) ?Op {
        return switch (c) {
            '+' => .add,
            '-' => .sub,
            '*' => .mul,
            '/' => .div,
            else => null,
        };
    }
};

/// Применить операцию к a и b. Деление на 0 → null.
pub fn apply(op: Op, a: f64, b: f64) ?f64 {
    return switch (op) {
        .add => a + b,
        .sub => a - b,
        .mul => a * b,
        .div => if (b == 0) null else a / b,
    };
}
