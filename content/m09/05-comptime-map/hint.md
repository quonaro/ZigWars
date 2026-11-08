Для `fib`: `const fib_table = comptime blk: { var t: [93]u64 = undefined; ... break :blk t; };` на уровне файла, затем `return fib_table[n];` (с проверкой `n >= fib_table.len` → `@compileError`).

---

`rangeSum`: страж — `switch (@typeInfo(T)) { .int => {}, else => @compileError("...") }`. Затем обычный `while (i <= hi) : (i += 1) sum += i;` — `i` и `sum` типа `T`.

---

```zig
switch (@typeInfo(T)) {
    .int => {},
    else => @compileError("rangeSum: нужен целочисленный тип, а не " ++ @typeName(T)),
}
```
