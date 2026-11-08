## Задание

Реализуй `parsePositive` — парсинг строго положительного десятичного числа.

```zig
pub fn parsePositive(s: []const u8) !u32
```

Правила:

- строка содержит только десятичные цифры (и допустимый `+`/подчёркивания — как у `std.fmt.parseInt`);
- результат должен быть `> 0`: `"0"` → `error.NotPositive`;
- мусор → прокинь ошибку `parseInt` (`InvalidCharacter`, `Overflow` и т.п.).

### Примеры

| Вызов | Результат |
|-------|-----------|
| `parsePositive("42")` | `42` |
| `parsePositive("1")` | `1` |
| `parsePositive("0")` | `error.NotPositive` |
| `parsePositive("abc")` | `error.InvalidCharacter` |
| `parsePositive("12a")` | `error.InvalidCharacter` |
| `parsePositive("")` | `error.InvalidCharacter` |
| `parsePositive("99999999999")` | `error.Overflow` |
| `parsePositive("-7")` | ошибка (`Overflow` для unsigned) |
