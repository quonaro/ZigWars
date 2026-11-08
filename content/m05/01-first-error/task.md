## Задание

То же деление, что в модуле 4, но теперь честная ошибка вместо `null`:

```zig
pub fn divide(a: i32, b: i32) error{DivisionByZero}!i32
```

- `b == 0` → `return error.DivisionByZero;`
- иначе → `@divTrunc(a, b)`

### Примеры

| Вызов | Результат |
|-------|-----------|
| `divide(10, 2)` | `5` |
| `divide(-7, 2)` | `-3` |
| `divide(1, 0)` | `error.DivisionByZero` |
| `divide(0, 5)` | `0` |

Тип возврата — `error{DivisionByZero}!i32`: слева от `!` сет возможных ошибок, справа — тип успеха.
