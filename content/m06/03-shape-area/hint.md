Заготовка: `return switch (s) { ... };` — каждая ветка возвращает `f64`.

---

Payload захватывается через `|имя|` после тега: `.circle => |r| r * r` — внутри `r` уже `f64`, а не весь union.

---

```zig
return switch (s) {
    .circle => |r| std.math.pi * r * r,
    .rect => |rc| rc.w * rc.h,
    .square => |a| a * a,
};
```
