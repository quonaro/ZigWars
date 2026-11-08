## Задание

Реализуй две функции над байт-слайсом:

```zig
pub fn startsWithZ(s: []const u8) bool   // true, если строка начинается с 'Z' (только заглавная)
pub fn lastChar(s: []const u8) ?u8       // последний байт строки; null для пустой
```

### Примеры

| Вызов | Результат |
|-------|-----------|
| `startsWithZ("Zig")` | `true` |
| `startsWithZ("zig")` | `false` — регистр важен |
| `startsWithZ("")` | `false` |
| `lastChar("zig")` | `'g'` |
| `lastChar("a")` | `'a'` |
| `lastChar("")` | `null` |
| `lastChar("Даня")` | `0x8F` — последний БАЙТ 'я' в UTF-8 |

Помни: `s.len` — байты, а не символы; `s[i]` на пустой строке — краш.
