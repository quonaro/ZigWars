Сначала отсеки пустой слайс: `if (xs.len == 0) return null;`. Дальше держи `var best: usize = 0;` и иди `for (xs[1..], 1..) |x, i|`.

---

Обновляй `best` только при строгом `x > xs[best]` — иначе вернёшь последний максимум вместо первого.

---

```zig
pub fn indexOfMax(xs: []const i32) ?usize {
    if (xs.len == 0) return null;
    var best: usize = 0;
    for (xs[1..], 1..) |x, i| {
        if (x > xs[best]) best = i;
    }
    return best;
}
```
