# `std.fmt.parseInt` и error union

## Парсинг чисел

Строка `"42"` — это три байта `'4'`, `'2'`… точнее два: `'4'`, `'2'`. Чтобы получить число, её надо распарсить:

```zig
const n = try std.fmt.parseInt(u32, "42", 10);   // n == 42
const h = try std.fmt.parseInt(u8, "ff", 16);    // h == 255
const b = try std.fmt.parseInt(u8, "101", 2);    // b == 5
```

Сигнатура: `parseInt(T, buf, base) ParseIntError!T`. Тип `T` — comptime-параметр: `u8`, `u32`, `i64`, `usize` — любой целочисленный. Для чисел с плавающей точкой есть `std.fmt.parseFloat`.

## Что считается ошибкой

`parseInt` строгий — он **не** пропускает пробелы и не останавливается на первом мусоре:

| Ввод для `u32` | Результат |
|---|---|
| `"42"`, `"+42"` | ок, `42` |
| `"1_000"` | ок, `1000` — подчёркивания разрешены, как в литералах |
| `"-5"` | `error.Overflow` — минус парсится, но не влезает в unsigned |
| `"12x"`, `" 12"`, `""` | `error.InvalidCharacter` |
| `"99999999999"` | `error.Overflow` |

## Error union за 30 секунд

`!u32` читается «u32 или ошибка» — это **error union**: либо значение, либо одна из ошибок множества. С ним три базовых приёма:

```zig
const n = try parseInt(u32, s, 10);          // ошибка — выйти из функции с ней
const m = parseInt(u32, s, 10) catch 0;      // ошибка — подставить запасное
const k = parseInt(u32, s, 10) catch |e| {   // ошибка — посмотреть на неё
    return e == error.InvalidCharacter;
};
```

Полная тема ошибок — модуль 5. Сейчас важно: **`try` прокидывает ошибку выше**, и если ты объявил в сигнатуре свою ошибку (`error.NotPositive`), она просто добавляется в union — множество ошибок выводится автоматически.

## Собственная ошибка

В задании ноль не считается положительным. `parseInt` его пропустит (`"0"` → `0`), так что проверка — твоя:

```zig
const n = try std.fmt.parseInt(u32, s, 10);
if (n == 0) return error.NotPositive;
return n;
```

`error.NotPositive` — полноценное значение, его можно ловить: `catch |e| e == error.NotPositive`.

## Проверка ошибок в тестах

```zig
try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("abc"));
```

`expectError` проверяет, что выражение вернуло именно эту ошибку — идеально для негативных сценариев.

## Что почитать

- [Langref 0.17.1 — Errors](https://ziglang.org/documentation/0.17.1/#Errors)
- [std.fmt](https://ziglang.org/documentation/0.17.1/std/#std.fmt)
- [std.testing](https://ziglang.org/documentation/0.17.1/std/#std.testing)
