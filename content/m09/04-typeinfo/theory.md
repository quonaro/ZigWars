# @typeInfo — спросить у типа, кто он

`@typeInfo(T)` возвращает объединение `std.builtin.Type` — полную «карту» типа: вид, размер, поля структуры, параметры указателя. Всё это происходит в comptime — никакого RTTI в бинарнике, компилятор просто подставляет константы.

```zig
switch (@typeInfo(T)) {
    .int => |info| // info.signedness, info.bits
    .float => |info| // info.bits
    .pointer => |info| // info.size, info.child, info.is_const
    .@"struct" => |info| // info.fields, info.decls
    else => {},
}
```

Теги объединения совпадают с именами видов типов в Zig. Обрати внимание на экранирование: `.@"struct"`, `.@"enum"`, `.@"union"` — эти имена конфликтуют с ключевыми словами.

## Основные теги и поля

| Тег | Что за тип | Полезные поля |
|-----|-----------|----------------|
| `.int` | `u8`, `i32`, `usize`… | `signedness` (`.signed`/`.unsigned`), `bits` |
| `.float` | `f16`…`f128`, `c_longdouble` | `bits` |
| `.bool` | `bool` | — |
| `.pointer` | `*T`, `[]T`, `*const T`… | `size` (`.one`/`.many`/`.slice`/`.c`), `child`, `is_const` |
| `.array` | `[N]T` | `len`, `child` |
| `.@"struct"` | `struct {}` | `fields` (массив с `.name`, `.type`), `is_tuple` |
| `.@"enum"` | `enum {}` | `tag_type`, `fields` |
| `.optional` | `?T` | `child` |
| `.error_union` | `E!T` | `error_set`, `payload` |

## Строим строки в comptime

Результат `describe` — `[]const u8`. Обычный `print` пишет в Writer, а для comptime-строк есть `std.fmt.comptimePrint` — тот же синтаксис формата, но строка появляется как константа в бинарнике:

```zig
const s = std.fmt.comptimePrint("целое, {d} бит", .{info.bits});
```

`@typeName(T)` — компаньон: возвращает имя типа строкой, тоже comptime.

## Зачем рефлексия в системном языке?

- **Сериализация**: обойти `.@"struct".fields` и выписать каждое поле в JSON — один код на все структуры.
- **Отладочный вывод**: `std.fmt` печатает `{any}` именно так — через `@typeInfo`.
- **Проверки интерфейсов**: «у типа есть метод `push`?» — `std.meta.hasMethod` построен на этом.
- **Компиляционные ошибки**: `if (!isInt(T)) @compileError("нужен целый тип");` — дружелюбные сообщения вместо мистических ошибок внутри дженерика.

## Граница comptime/runtime

`@typeInfo` можно вызывать и на runtime-переменных типа — но аргумент всё равно должен быть `comptime`-известен (типы существуют только в comptime). Параметр `comptime T: type` — стандартный способ передачи.

## Что почитать

- [Zig Language Reference 0.17.1 — @typeInfo](https://ziglang.org/documentation/0.17.1/#typeInfo)
- [std.builtin.Type](https://ziglang.org/documentation/0.17.1/std/#std.builtin.Type)
