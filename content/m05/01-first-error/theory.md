# Ошибки — это значения

## Без исключений

В Zig нет `throw`/`catch`-исключений и скрытого потока управления. Ошибка — обычное значение, которое возвращается из функции рядом с нормальным результатом. Тип такого «двойного» результата — **error union**: `!i32` читается как «ошибка ИЛИ i32».

## Error set

Конкретные ошибки перечислены в **error set** — как enum, только без числовых значений:

```zig
const DivError = error{DivisionByZero};

pub fn divide(a: i32, b: i32) DivError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}
```

Можно и инлайн: `error{DivisionByZero}!i32`. Имена ошибок глобальны — `error.DivisionByZero` везде один и тот же; разные сеты объединяются бесплатно.

## `try` — пробрось наверх

Самый частый сценарий — «упало? отдай ошибку вызывающему»:

```zig
fn compute(a: i32, b: i32) DivError!i32 {
    const q = try divide(a, b);  // ошибка? сразу return error... — иначе q: i32
    return q * 2;
}
```

`try x` — сахар для `x catch |err| return err`. Одна буква вместо пирамиды проверок, как `?` в Rust.

## `catch` — обработай на месте

Если ошибку надо погасить — ловим её сами:

```zig
const q = divide(10, 0) catch 0;              // запасное значение
const q = divide(a, b) catch |err| switch (err) {
    error.DivisionByZero => -1,
};
const q = divide(a, b) catch unreachable;     // «не может быть» — panic, если соврал
```

## Ошибка — не panic

Важно различать:

- **error** — ожидаемый сбой: файл не найден, данные кривые, сеть отвалилась. Часть нормального контракта функции.
- **panic** — баг в программе: выход за границы, `unreachable` которое достигли, `.?` на null. Программа останавливается.

Не прячь баги в ошибки и не паникуй на рядовые сбои. Деление на ноль, кстати, в Zig — panic (это контракт «делитель не ноль»); наша `divide` переводит его в явную ошибку.

## Проверить как значение

Error union можно разобрать и вручную через `if`:

```zig
if (divide(10, 0)) |q| {
    // q: i32 — успех
} else |err| {
    // err: ошибка
}
```

Но в 90% кода хватает `try` и `catch`.

## Что почитать

- [Langref 0.17.1 — Errors](https://ziglang.org/documentation/0.17.1/#Errors)
- [Langref 0.17.1 — Error Set Type](https://ziglang.org/documentation/0.17.1/#Error-Set-Type)
- [Langref 0.17.1 — Error Union Type](https://ziglang.org/documentation/0.17.1/#Error-Union-Type)
