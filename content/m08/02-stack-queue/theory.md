# ArrayList как стек

## Стек — это паттерн использования

В Zig нет отдельного `std.Stack` — `ArrayList` им и является: `append` = push, `pop` = pop, `last()` = peek. Конец `items` — вершина стека:

```zig
var stack: std.ArrayList(i64) = .empty;
defer stack.deinit(alloc);

try stack.append(alloc, 10);       // push
if (stack.last()) |top| {          // peek: ?i64
    // top — вершина, не снятая
}
const v = stack.pop();             // ?i64 — снять вершину
```

`pop()` возвращает `?T`: `null` на пустом стеке. Не забудь развернуть опционал — `orelse`, `if (x) |v|`, `?` для unwrap-panic (осторожно) или `orelse return error.StackUnderflow`.

## parseInt: строка → число

```zig
const n = try std.fmt.parseInt(i64, "-42", 10);
```

Третий аргумент — основание (обычно 10). На невалидном вводе возвращает `error.InvalidCharacter`. Тип — какой попросишь: `i64`, `u8`, `i32`... Переполнение целевого типа — `error.Overflow`.

## Обратная польская нотация (RPN)

RPN — запись выражения, где оператор идёт **после** операндов: `3 4 +` = 7, `3 4 + 5 *` = (3+4)·5 = 35. Скобки не нужны никогда — порядок вычисления задан стеком.

Алгоритм вычисления:

1. Идём по токенам слева направо.
2. Число → push на стек.
3. Оператор → pop два операнда `b` и `a` (порядок важен: `a op b`), посчитать, push результат.
4. В конце на стеке ровно одно число — ответ.

```zig
for (tokens) |tok| {
    if (std.mem.eql(u8, tok, "+")) {
        const b = stack.pop() orelse return error.InvalidExpression;
        const a = stack.pop() orelse return error.InvalidExpression;
        try stack.append(alloc, a + b);
    } else {
        const n = try std.fmt.parseInt(i64, tok, 10);
        try stack.append(alloc, n);
    }
}
```

## Подводные камни

- **Порядок операндов**: сначала снимается второй операнд! `4 2 -` — это `4 - 2 = 2`, а не `2 - 4`.
- **Деление**: `@divTrunc` — усечение к нулю, как в C (`-7 / 2 = -3`, а не `-4`). `divFloor` дал бы floor-семантику.
- **Деление на ноль**: `@divTrunc(a, 0)` — паника безопасности, а не ошибка. Проверяй `b == 0` и возвращай ошибку сам.
- **Валидация**: лишние числа в конце (`1 2 3`), оператор без двух операндов — некорректные выражения. Хорошая реализация возвращает `error`, а не паникует.

## Мини-словарь проверки токена

Токен либо один из операторов `+ - * /`, либо число. Удобно: сначала проверить все операторы (`std.mem.eql`), иначе — `parseInt`. Отрицательные числа (`"-11"`) parseInt переварит сам.

## Что почитать

- [std 0.17.1 — std.fmt.parseInt](https://ziglang.org/documentation/0.17.1/std/#std.fmt.parseInt)
- [std 0.17.1 — std.ArrayList](https://ziglang.org/documentation/0.17.1/std/#std.ArrayList)
- [Langref 0.17.1 — std.mem.eql](https://ziglang.org/documentation/0.17.1/#std.mem.eql)
