Все три функции — один `switch` каждая. Для `fromChar` ветки возвращают `.add`/`.sub`/… — тип `?Op` сам додумается.

---

`apply` тоже switch-выражение, но в ветке `.div` нужен `if (b == 0) null else a / b` — `if`-выражение внутри стрелки.

---

```zig
pub fn apply(op: Op, a: f64, b: f64) ?f64 {
    return switch (op) {
        .add => a + b,
        .sub => a - b,
        .mul => a * b,
        .div => if (b == 0) null else a / b,
    };
}
```
