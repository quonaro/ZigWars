Объяви `var total: i64 = 0;` и пройдись по слайсу `for (xs) |x|`.

---

`total += x;` работает: `i32` неявно расширяется в `i64`, так что отдельный `@intCast` не нужен.

---

```zig
pub fn sumSlice(xs: []const i32) i64 {
    var total: i64 = 0;
    for (xs) |x| total += x;
    return total;
}
```
