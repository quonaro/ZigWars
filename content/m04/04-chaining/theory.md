# Цепочки optionals: `orelse return`, `??T` и `while` по optional

## `orelse` умеет не только значения

Правый операнд `orelse` — любое выражение, лишь бы тип сходился. А ещё там может быть `noreturn`-выход:

```zig
const v = maybe orelse return null;   // «нет — и у нас тоже нет»
const v = maybe orelse return error.Empty;
const v = maybe orelse unreachable;   // «это невозможно»
```

Паттерн `orelse return` — рабочая лошадка ранних выходов: каждая строка «достань или выйди», без пирамид вложенных `if`.

## `if` — выражение

Уже знаешь, что `if` возвращает значение. С optional это даёт компактные трансформации:

```zig
const doubled = if (a) |v| v * 2 else null;  // ?i32
```

Проверка, распаковка и маппинг — в одной строке. Это то, что в других языках пишут как `a.map(x => x * 2)`.

## Вложенные optionals: `??T`

Раз `?T` — тип, его можно опционализировать снова: `??i32` — «может быть optional-i32, может быть null». Звучит экзотично, но встречается: например, «значение в мапе может быть `null` (ключ есть, значения нет) vs ключа вообще нет».

Распаковывается слоями:

```zig
const x: ??i32 = @as(?i32, 5);
if (x) |inner| {        // inner: ?i32
    if (inner) |v| {    // v: i32
        // наконец-то число
    }
}
```

`x.?` снимает только один слой. Осторожно с `orelse` на `??T` — результат правой ветки должен быть `?i32`, легко запутаться, что именно ты вернул.

## `while` по optional — итераторы

```zig
while (queue.pop()) |item| {
    // крутится, пока pop не вернёт null
}
```

Это и есть модель итераторов в stdlib: метод `next() ?Item`, а цикл `while (it.next()) |x|` обходит всё до конца. Никаких `hasNext()` — optional сам сигнализирует остановку.

## Стиль

```zig
fn process(a: ?i32, b: ?i32) ?i32 {
    const x = a orelse return null;
    const y = b orelse return null;
    return x + y;
}
```

Три строки — и обе распакованы. Сравни с пирамидой `if`-ов и полюби Zig чуть сильнее.

## Что почитать

- [Langref 0.17.1 — Optionals](https://ziglang.org/documentation/0.17.1/#Optionals)
- [Langref 0.17.1 — while](https://ziglang.org/documentation/0.17.1/#while)
