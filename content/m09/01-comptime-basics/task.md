## Задание

Реализуй две функции, которые вычисляются **при компиляции**.

### `comptimeSquare`

```zig
pub fn comptimeSquare(comptime n: u32) u32
```

Возвращает `n * n`. Аргумент обязан быть известен при компиляции — поэтому параметр помечен `comptime`.

### `comptimeFactorial`

```zig
pub fn comptimeFactorial(comptime n: u32) u64
```

Факториал `n!` через `comptime var`-переменные и `inline while` (в `comptime var` можно писать только из inline-цикла). `factorial(0) == 1`, `factorial(1) == 1`.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `comptimeSquare(9)` | `81` |
| `comptimeSquare(0)` | `0` |
| `comptimeFactorial(5)` | `120` |
| `comptimeFactorial(0)` | `1` |
| `comptimeFactorial(20)` | `2432902008176640000` |

### Ограничения

- Обе функции должны работать **только** с comptime-аргументами (компилятор сам это проверит — передавать в тестах runtime-переменные нельзя).
- `u64` вмещает факториал максимум до `20!` — тесты не выходят за этот предел, но учти тип результата.
