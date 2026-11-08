---
name: ZigWars
description: Разработка ZigWars — локального Codewars-подобного тренажёра по Zig. Загружать при добавлении новых kata, правке контента, обновлении тренажёра под новую версию Zig, а также при изменениях сервера (server.mjs, runner.mjs) или UI (public/).
---

# ZigWars — разработка тренажёра

## Обязательное перед началом

1. Прочитай `AGENTS.md` (корень проекта) — правила проекта и пойманные грабли.
2. Для работы с kata прочитай `CONTENT_SPEC.md` — контракт файлов и актуальный чит-лист API целевой версии Zig.
3. Не трогай `progress.json` — legacy-бэкап для миграции прогресса в IndexedDB.

## Жёсткие правила проекта

- `tests.zig` для ученика **read-only**: `/api/run` берёт тесты только с диска (поле `tests` в payload игнорируется), в UI редактор тестов `EditorState.readOnly`. Не возвращать возможность правки.
- Страница не скроллится целиком — скроллятся только панели. Новый grid/flex-элемент с прокручиваемым потомком → обязательно `min-height: 0`. `overflow: hidden` на `html, body` — намеренно.
- Тема «field manual»: фон `#1b1f27` (НЕ почти чёрный), акцент `#e0a458`. Подсветка кода — свой `zwHighlight` в `public/zig-lang.mjs`, НЕ oneDark.
- Весь UI-текст и контент — на русском.
- Значимые изменения дописывать в «Лог сессий» в `PROGRESS.md`.

## Запуск и проверка

- `lota dev` — сервер (`node --watch`) + открыть браузер; `lota run` — только сервер. Порт **7100**.
- `lota verify` — **ОБЯЗАТЕЛЬНО после любых изменений `content/**`**: прогоняет все kata (reference против `tests.zig` и `tests_hidden.zig` + `zig ast-check` стабов). Должно быть `failures: 0`.
- Проверка одной kata вручную: бэкап `solution.zig` → `cp reference.zig solution.zig` → `zig test tests.zig` → вернуть стаб.
- Hot-reload встроен: `public/*.css` → css без reload; остальной `public/` → reload страницы; `content/**` → перечитать без reload. `server.mjs`/`runner.mjs` рестартятся `node --watch`.
- Рестарт сервера: pid через `ss -tlnp | grep :7100` (pkill матчит сам себя), затем `nohup node server.mjs > /tmp/zigwars.log 2>&1 &`.
- `zig test` пишет прогресс в **stderr, не stdout**; строка FAIL идёт ПОСЛЕ `expected X, found Y` — парсер в `runner.mjs` построчный, учитывай при правках.

## Новая kata

Директория `content/mNN/SS-slug/` (NN — номер модуля, SS — порядковый номер, slug — kebab-case). Файлы:

- `meta.json` — `{"id":"mNN-SS","title":"…","kyu":N,"tags":[…],"theory_minutes":M}` (kyu 8 = самая простая)
- `theory.md` — русский markdown, 300–800 слов, рабочие примеры кода, в конце — ссылки на разделы ziglang.org для целевой версии
- `task.md` — условие: что реализовать, сигнатуры, примеры вход/выход, ограничения
- `solution.zig` — стаб, ОБЯЗАН компилироваться (`zig ast-check`): неиспользуемые параметры — ошибка Zig, сбрасывать `_ = имя;` в начале тела (но не если параметр в `@TypeOf` сигнатуры — pointless discard)
- `reference.zig` — эталон: те же `pub fn`, полностью рабочие
- `tests.zig` — `const sol = @import("solution.zig");` + 3–8 русскоязычных `test "…"` с `std.testing.*`. Варьируй входы — тесты не должны обходиться хардкодом констант
- `hint.md` — 1–3 подсказки нарастающей конкретности через `---`
- `tests_hidden.zig` — опционально: скрытые тесты на краевые случаи и анти-хардкод (генерируемые входы, оракулы), не дублируют видимые

## Обновление под новую версию Zig

1. Поставь новый `zig` в PATH и проверь `zig version`.
2. Обнови упоминания версии: `public/index.html` (бейдж `zig x.y`), `README.md`, `AGENTS.md`, `CONTENT_SPEC.md` (целевая версия + ссылки на доки + чит-лист API).
3. `lota verify` → собери ошибки компиляции и тестов по всем kata.
4. Правь `reference.zig`, `tests.zig`, `tests_hidden.zig`, `solution.zig` под новое API; при необходимости — примеры в `theory.md`.
5. Повторяй `lota verify` до `failures: 0`.
6. Актуализируй чит-лист в `CONTENT_SPEC.md`, грабли — в `AGENTS.md` и этот скилл, запись — в `PROGRESS.md`.

## Грабли Zig 0.17 (актуально сейчас)

- `std.Io` (не `std.io`), `std.Io.Dir` (не `std.fs.Dir`); io — первым аргументом
- `ArrayList` unmanaged: `append(alloc, …)`, `.empty`, `last()` (нет `getLast()`)
- FBA → `error.OutOfMemory`; `"x"**1000` без пробелов
- `std.heap.DebugAllocator(.{}) = .init` вне тестов; `std.testing.allocator` в тестах (ловит утечки)
- `expectEqual(expected, actual)` — expected ПЕРВЫМ
- Полный список — `CONTENT_SPEC.md`; новые грабли новых версий дописывай туда и сюда
