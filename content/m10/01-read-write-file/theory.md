# std.Io — весь ввод-вывод через один интерфейс

В Zig 0.17 вся блокирующая работа с I/O проходит через объект `std.Io`. Это **интерфейс**: одна и та же функция может работать с потоковым I/O (`Io.Threaded` — обычная блокировка на ОС), асинхронным рантаймом или тестовым стабом — реализацию выбирает вызывающий, а не библиотека.

```zig
pub fn process(io: std.Io, alloc: std.mem.Allocator) !void {
    // работаем через io — что внутри, нас не касается
}
```

В продакшн-программе `io` приходит из `pub fn main(init: std.process.Init) !void` — там `init.io`. В тестах — `std.testing.io`, синхронная реализация без сюрпризов.

## Файлы и каталоги

Работа с путями — через `std.Io.Dir`. Текущий каталог: `std.Io.Dir.cwd()`. Абсолютные пути он принимает напрямую — для тренажёра это удобно: `/tmp/...` всегда работает.

```zig
const io = std.testing.io;
const cwd = std.Io.Dir.cwd();

// запись (перезапишет существующий)
var f = try cwd.createFile(io, "/tmp/data.txt", .{});
try f.writeStreamingAll(io, "hello");
f.close(io);

// чтение целиком в память
const data = try cwd.readFileAlloc(io, "/tmp/data.txt", alloc, .limited(1 << 20));
defer alloc.free(data);

// удаление
try cwd.deleteFile(io, "/tmp/data.txt");
```

Обрати внимание на порядок аргументов 0.17: **`io` всегда первый**, путь второй. `createFile` возвращает `File`, у которого `close(io)` — тоже с `io`.

## `.limited(n)` — защита от бесконечных файлов

`readFileAlloc` читает весь файл в память. Чтобы злонамеренный `/dev/urandom` не съел всю оперативку, четвёртым аргументом идёт лимит: `.limited(1 << 20)` — максимум мегабайт. Превысил — `error.FileTooBig`. Всегда указывай разумный предел.

## Ошибки

Файловые операции возвращают error union:

- `error.FileNotFound` — файла нет;
- `error.AccessDenied` — нет прав;
- `error.FileTooBig` — лимит `.limited`;
- `error.OutOfMemory` — от `readFileAlloc`.

В тестах `try` поднимает ошибку наверх и роняет тест — для ожидаемых ошибок используй `expectError`.

## `writeStreamingAll` vs `print`

`File` — это streaming-запись: `writeStreamingAll(io, bytes)` записывает сырые байты. Для форматированного вывода есть `f.writer(io, &.{})` → `Writer`, но простой `writeStreamingAll` часто удобнее — особенно когда строку уже собрали через `alloc.print`.

## Что почитать

- [std.Io](https://ziglang.org/documentation/0.17.1/std/#std.Io)
- [std.Io.Dir](https://ziglang.org/documentation/0.17.1/std/#std.Io.Dir)
- [Zig Language Reference 0.17.1 — main](https://ziglang.org/documentation/0.17.1/#main)
