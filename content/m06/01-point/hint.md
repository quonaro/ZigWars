`add` должен вернуть новый `Point` — анонимный литерал `.{ .x = ..., .y = ... }` сам подхватит тип из `-> Point`.

---

Для корня есть builtin `@sqrt(значение)` — ничего импортировать не нужно.

---

```zig
pub fn add(self: Point, other: Point) Point {
    return .{ .x = self.x + other.x, .y = self.y + other.y };
}

pub fn distance(a: Point, b: Point) f64 {
    const dx = a.x - b.x;
    const dy = a.y - b.y;
    return @sqrt(dx * dx + dy * dy);
}
```
