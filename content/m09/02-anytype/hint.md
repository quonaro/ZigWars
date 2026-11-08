Обе функции — однострочники. `maxOf` — тернарник `if (a > b) a else b`, `add` — обычное `a + b`.

---

Возврат `@TypeOf(a, b)` заставляет Zig привести `a + b` к общему типу автоматически — ничего кастовать не нужно.

---

```zig
pub fn maxOf(a: anytype, b: @TypeOf(a)) @TypeOf(a) {
    return if (a > b) a else b;
}
```
