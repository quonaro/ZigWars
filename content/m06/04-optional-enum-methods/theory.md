# Методы в enum, `?T` и switch по символам

## Enum — тоже контейнер

Как и struct, enum может содержать функции и константы. «Метод» — функция, принимающая enum первым параметром:

```zig
const Op = enum { add, sub, mul, div,

    /// Символ операции: '+', '-', '*', '/'.
    pub fn symbol(op: Op) u8 {
        return switch (op) {
            .add => '+',
            .sub => '-',
            .mul => '*',
            .div => '/',
        };
    }
};
```

Первый параметр традиционно зовут `self`, но любое имя сработает — важен только тип. Вызов: `op.symbol()` (то же, что `Op.symbol(op)`).

## Свободные функции-«конструкторы»

Функция внутри enum, **не** принимающая enum параметром, — просто функция в пространстве имён типа. Идиома для парсинга — `fromXxx`, возвращающая `?T` или `!T`:

```zig
pub fn fromChar(c: u8) ?Op {
    return switch (c) {
        '+' => .add,
        '-' => .sub,
        '*' => .mul,
        '/' => .div,
        else => null,
    };
}
// вызов: Op.fromChar('+') → ?Op
```

Обрати внимание: в ветках пишем `.add` — тип результата известен из `-> ?Op`, enum-компактная запись работает и внутри опционального значения.

## `?T` — опциональный тип

`?f64` читается «f64 или null». Это не магия, а обычный тип-обёртка уровня языка. Работа с ним:

```zig
const maybe: ?f64 = Op.fromChar('/') orelse null; // можно присвоить
if (maybe) |v| { /* v: f64 */ }                   // развернуть
const x = maybe orelse 0;                         // с дефолтом
```

`null` в Zig — первоклассное значение опциональных типов, не «нулевой указатель». `?f64` ≠ `*f64`.

## switch по `u8` и диапазоны

Парсинг символов — идеальная задача для switch по `u8`: литералы `'+'` имеют тип `comptime_int` и склеиваются с `u8`. Диапазоны включительны:

```zig
const class = switch (c) {
    '0'...'9' => .digit,
    'a'...'z', 'A'...'Z', '_' => .ident,
    '+', '-', '*', '/', '=' => .operator,
    ' ', '\t', '\n' => .whitespace,
    else => .other,
};
```

В этом kata `fromChar` диапазоны не нужны (4 точных символа), но паттерн пригодится в лексерах и парсерах.

## Labeled switch — коротко

`switch` можно пометить и «перейти» в другой кейс через `continue :метка значение`:

```zig
const v = st: switch (op) {
    .add => a + b,
    .sub => continue :st .add, // шутка; просто синтаксис
    else => 0,
};
```

Реальный кейс — state machine: `continue :state .next` перекидывает управление в ветку `.next`. Подробности — в langref, здесь достаточно узнать синтаксис.

## Что почитать

- [Langref 0.17.1 — enum](https://ziglang.org/documentation/0.17.1/#enum)
- [Langref 0.17.1 — Optionals](https://ziglang.org/documentation/0.17.1/#Optionals)
- [Langref 0.17.1 — switch](https://ziglang.org/documentation/0.17.1/#switch)
