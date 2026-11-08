# Error sets: объединение, `anyerror` и выведение

## Имена ошибок глобальны

`error.OutOfMemory` в файловом API и `error.OutOfMemory` в твоём коде — **одна и та же ошибка**. Error set — это просто подмножество всех имён ошибок программы. Поэтому объединять их тривиально.

## `||` — слияние сетов

```zig
const IoErrors = error{ FileNotFound, AccessDenied };
const AppErrors = error{ NotFound, Denied };
const AllErrors = IoErrors || AppErrors;
// ≡ error{ FileNotFound, AccessDenied, NotFound, Denied }
```

Так функция-обёртка декларирует: «могу кинуть всё, что кидают мои зависимости, плюс своё».

## Подмножества и приведение

Меньший сет неявно приводится к большему:

```zig
fn inner() error{FileNotFound}!u32 { ... }
fn outer() AllErrors!u32 {
    return try inner();   // FileNotFound входит в AllErrors — ок
}
```

Обратное — только явно: поймать `catch` и вернуть более конкретную ошибку.

## `anyerror` — «что угодно»

`anyerror` — сет **всех** ошибок сразу. `anyerror!T` — самый широкий error union: туда приводится любой сет.

Удобно для прототипов и тестов, но в API это `throws Exception` — сигнатура перестаёт говорить, чего ждать. `switch` по такой ошибке не сможет проверить исчерпание — компилятор не знает полного списка.

## Inferred error set: голый `!T`

Написал `!u32` без сета — компилятор **выведет его сам**, пройдясь по `return error.X` и `try`-вызовам внутри функции:

```zig
fn validate(s: []const u8) !u32 {
    if (s.len == 0) return error.Empty;
    return s.len;   // сет выведен: error{Empty}
}
```

Очень удобно для внутренних функций: сет не рассинхронизируется с телом при рефакторинге.

**Когда всё же писать сет явно:**

- публичный API — сет часть контракта, важна для документации;
- рекурсивные функции — выведение не всегда может замкнуться;
- хочешь `switch` по ошибкам с проверкой полноты у вызывающего.

**Осторожно:** функция с inferred-сетом, возвращаемая в интерфейс (`fn(...) !u32` в поле структуры), может не совпасть с ожидаемым сетом — лучше объявить явно.

## Зачем имя сету

```zig
pub const ValidateError = error{ Empty, TooLong, NotAscii };
pub fn validate(s: []const u8) ValidateError!u32 { ... }
```

Вызывающий может написать `catch |err| switch (err)` — и компилятор проследит, что все три случая покрыты. Добавишь четвёртую ошибку в сет — все switch-и у пользователей перестанут компилироваться и укажут, что забыли. Безопасный рефакторинг из коробки.

## Что почитать

- [Langref 0.17.1 — Error Set Type](https://ziglang.org/documentation/0.17.1/#Error-Set-Type)
- [Langref 0.17.1 — Error Union Type](https://ziglang.org/documentation/0.17.1/#Error-Union-Type)
- [Langref 0.17.1 — Errors](https://ziglang.org/documentation/0.17.1/#Errors)
