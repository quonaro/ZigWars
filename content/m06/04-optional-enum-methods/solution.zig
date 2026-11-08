const std = @import("std");

pub const Op = enum {
    add,
    sub,
    mul,
    div,

    /// Символ операции: '+', '-', '*', '/'.
    pub fn symbol(op: Op) u8 {
        // TODO: switch по четырём вариантам
        _ = op;
        return '?';
    }

    /// Парсинг символа в операцию; незнакомый символ → null.
    pub fn fromChar(c: u8) ?Op {
        // TODO: switch по символам, else → null
        _ = c;
        return null;
    }
};

/// Применить операцию к a и b. Деление на 0 → null.
pub fn apply(op: Op, a: f64, b: f64) ?f64 {
    // TODO
    _ = op;
    _ = a;
    _ = b;
    return null;
}
