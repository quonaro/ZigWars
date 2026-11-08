## Задание

Реализуй две функции для нуль-терминированных строк:

```zig
pub fn cStrLen(s: [*:0]const u8) usize
pub fn equalZigStr(a: [*:0]const u8, b: []const u8) bool
```

- `cStrLen` — длина C-строки **без** сентинела, посчитанная вручную циклом `while (s[n] != 0)`. Не используй `std.mem.span` и `std.mem.len` — смысл kata в ручном проходе.
- `equalZigStr` — `true`, если C-строка `a` посимвольно равна слайсу `b`. Тут `std.mem.span` разрешён и приветствуется.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `cStrLen("hello")` | `5` |
| `cStrLen("")` | `0` |
| `equalZigStr("zig", "zig")` | `true` |
| `equalZigStr("zig", "zigg")` | `false` |
| `equalZigStr("zig", "zi")` | `false` |
| `equalZigStr("", "")` | `true` |

Строковый литерал `"..."` в Zig уже имеет тип `*const [N:0]u8` и неявно приводится к `[*:0]const u8` — передавай прямо в функцию.
