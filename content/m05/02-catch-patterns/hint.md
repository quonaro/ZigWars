`std.fmt.parseInt(i64, s, 10)` возвращает error union. Подавить его в значение поможет `catch`.

---

`parseOr` — одна строка: `return std.fmt.parseInt(i64, s, 10) catch default;`

---

`parseOrZero` ещё короче: `return parseOr(s, 0);` — не дублируй парсинг.
