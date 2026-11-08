# Спецификация контента ZigWars (обязательна для всех kata)

Целевая версия компилятора: **Zig 0.17.0** (команда `zig` в PATH). Весь код ОБЯЗАН компилироваться и проходить тесты на ней.

## Структура kata

`content/mNN/SS-slug/` где NN — номер модуля, SS — порядковый номер внутри модуля (01, 02…), slug — kebab-case.

Файлы:

- `meta.json` — `{"id":"mNN-SS","title":"…","kyu":N,"tags":["…"],"theory_minutes":M}` (kyu 8=проще всего)
- `theory.md` — теория на русском, markdown. 300–800 слов. Примеры кода — короткие, рабочие на 0.17. В конце — ссылки на https://ziglang.org/documentation/0.17.1/ разделы.
- `task.md` — условие: что реализовать, сигнатуры, примеры вход/выход, ограничения. Русский.
- `solution.zig` — стаб: нужные `pub fn` с телом-заглушкой (напр. `return 0;`) и комментарий `// TODO`. Стаб ОБЯЗАН компилироваться (`zig ast-check`): неиспользуемые параметры Zig считает ошибкой, поэтому сбрасывай их строкой `_ = имя;` в начале тела.
- `reference.zig` — эталон: те же `pub fn`, полностью рабочие.
- `tests.zig` — начинается с `const sol = @import("solution.zig");` затем 3–8 `test "…"` блоков с `std.testing.*`. Тесты именуются по-русски кратко. Эти тесты ученик ВИДИТ и может редактировать локально, но проверка идёт по ним же — не делай их тривиально обходимыми (не проверяй константы, которые ученик может захардкодить — варьируй входы).
- `hint.md` — 1–3 подсказки нарастающей конкретности, разделённые `---`.
- `tests_hidden.zig` — опциональные «скрытые» тесты (полный аналог tests.zig): ученик их не видит; прогоняются только если видимые прошли, и тоже обязаны быть зелёными для зачёта. Проверяют краевые случаи и анти-хардкод (генерируемые входы, эталонные оракулы), не дублируют видимые примеры. `lota verify` гоняет и их.

## Zig 0.17 API — обязательные формы

```zig
// ArrayList — unmanaged
var list: std.ArrayList(T) = .empty;
defer list.deinit(alloc);
try list.append(alloc, item);          // appendSlice, insert, orderedRemove — то же: alloc первым аргументом
list.items; list.last();               // нет getLast()!

// print в аллоцированную строку
const s = try alloc.print("{d} {s}", .{n, name});
defer alloc.free(s);

// HashMap — managed остался!
var map = std.AutoHashMap(K, V).init(alloc);   // std.StringHashMap(V) для строк
defer map.deinit();
try map.put(k, v); map.get(k); map.count();

// Аллокаторы
std.testing.allocator          // в тестах — ловит утечки
var gpa: std.heap.DebugAllocator(.{}) = .init;  // вне тестов
const alloc = gpa.allocator();
var arena = std.heap.ArenaAllocator.init(alloc); defer arena.deinit();
const a = arena.allocator();

// Тестирование
try std.testing.expect(cond);
try std.testing.expectEqual(expected, actual);       // expected ПЕРВЫМ
try std.testing.expectEqualSlices(T, expected, actual);
try std.testing.expectEqualStrings("a", got);
try std.testing.expectError(error.X, errorUnionValue);
try std.testing.expectApproxEqAbs(expected, actual, tol);

// std.Io в 0.17 (НЕ std.io!)
std.Io.Writer, std.Io.Reader
var w: std.Io.Writer = .fixed(&buf);  // запись в буфер

// Файлы/диры — std.Io.Dir (НЕ std.fs.Dir), io идёт ПЕРВЫМ аргументом:
const io = std.testing.io;                 // в тестах
const cwd = std.Io.Dir.cwd();
var f = try cwd.createFile(io, "/abs/path.txt", .{});   // путь может быть абсолютным
try f.writeStreamingAll(io, "data");
f.close(io);
const data = try cwd.readFileAlloc(io, "/abs/path.txt", alloc, .limited(1 << 20));
try cwd.deleteFile(io, "/abs/path.txt");
// В проде: pub fn main(init: std.process.Init) !void — init.io, init.gpa, init.arena
```

**ЗАПРЕЩЕНО** (устарело/удалено в 0.17): `std.io.*`, `std.fmt.allocPrint`, `ArrayList.init(alloc)` managed-стиль, `list.append(x)` без аллокатора, `getLast()`, `std.mem.indexOf*` (используй `std.mem.find*`), `std.ArrayHashMap`/`StringArrayHashMap` (используй `std.array_hash_map.*` или `AutoHashMap`), `@Type`, `std.builtin.OptimizeMode`, оператор `**` (повторение массива/строки — удалён, собирай вручную циклом/`@memset`/`appendNTimes`), `ArrayList.writer()` (нет — строки через `std.Io.Writer.Allocating` или `appendSlice`/`appendNTimes`).

## Проверка (обязательно для автора)

В каталоге kata:
```
cp reference.zig solution.zig && zig test tests.zig   # ВСЕ тесты OK
git checkout solution.zig 2>/dev/null || true         # вернуть стаб
```
Также прогнать `zig ast-check solution.zig` (стаб должен компилироваться до момента вызова — заглушка `unreachable` допустима, но лучше `return` нейтрального значения, чтобы компилилось).

## Тон

Русский, живой, без канцелярита. Объясняй «почему», а не только «как». Zig-мемы уместны в меру. Сложность внутри модуля нарастает.
