## Задание

Валидатор строки с именованным error set:

```zig
pub const ValidateError = error{ Empty, TooLong, NotAscii };

pub fn validate(s: []const u8) ValidateError!u32
pub fn validateInfer(s: []const u8) !u32
```

`validate` — проверки **строго в этом порядке**:

1. `s.len == 0` → `error.Empty`
2. `s.len > 8` → `error.TooLong`
3. любой байт `> 127` → `error.NotAscii`
4. иначе — сумма байт (`u32`)

`validateInfer` — та же логика, но тип возврата просто `!u32` (сет выведется сам). Проще всего — просто `return validate(s);` внутри: вызвавший сет входит в выведенный.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `validate("a")` | `97` |
| `validate("hi")` | `209` |
| `validate("")` | `error.Empty` |
| `validate("123456789")` | `error.TooLong` — длина важнее ASCII |
| `validate("\xff")` | `error.NotAscii` |

Порядок проверок важен: длинная не-ASCII строка даёт `TooLong`, а не `NotAscii`.
