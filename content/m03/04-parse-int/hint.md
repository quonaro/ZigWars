`std.fmt.parseInt(u32, s, 10)` делает почти всё — осталось прокинуть его ошибки через `try` и отдельно отвергнуть ноль.

---

```zig
const n = try std.fmt.parseInt(u32, s, 10);
```

`try` при ошибке сам вернёт её из функции — не нужен `catch`.

---

```zig
const n = try std.fmt.parseInt(u32, s, 10);
if (n == 0) return error.NotPositive;
return n;
```

Своя ошибка `error.NotPositive` автоматически добавляется в error union функции.
