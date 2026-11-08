## Задание

Реализуй две функции:

```zig
pub fn isEven(n: i32) bool        // true, если n чётное
pub fn isMultipleOf(n: i32, d: i32) bool   // true, если n делится на d без остатка
```

### Примеры

| Вызов | Результат |
|-------|-----------|
| `isEven(4)` | `true` |
| `isEven(-3)` | `false` |
| `isEven(0)` | `true` |
| `isMultipleOf(10, 5)` | `true` |
| `isMultipleOf(10, 3)` | `false` |
| `isMultipleOf(-9, 3)` | `true` |

`d` никогда не равен нулю.
