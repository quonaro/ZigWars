# ZigWars — правила для агентов

Локальный Codewars-подобный тренажёр по **Zig 0.17.x**: теория на русском + kata с реальным `zig test`. Не git-репозиторий. Порт **7100**.

## Запуск / проверка

- `lota dev` — сервер + открыть браузер (под `node --watch`: правки `server.mjs`/`runner.mjs` рестартят сервер). `lota run` — только сервер.
- Hot-reload встроен: `fs.watch` + SSE `/api/dev-events`. `public/*.css` → обновление css без reload, остальной `public/` → reload страницы, `content/**` → перечитать модули/kata без reload (черновик в редакторе сохраняется).
- `lota verify` — **обязательно после любых изменений контента**: прогоняет все 48 kata (reference против `tests.zig` + `zig ast-check` стабов). Должно быть `failures: 0`.
- Рестарт сервера: pid ищем через `ss -tlnp | grep :7100` (pkill матчит сам себя), затем `nohup node server.mjs > /tmp/zigwars.log 2>&1 &`.

## Архитектура

- `server.mjs` — чистый `node:http`, без зависимостей. API: `/api/modules`, `/api/kata`, `/api/reference`, `/api/run`, `/api/progress-export`. **`/api/run` берёт `tests.zig` только с диска** — поле `tests` в payload игнорируется (тесты read-only для пользователя).
- Прогресс пользователя — в **IndexedDB** на клиенте (`public/db.mjs`, БД `zigwars`): drafts, solvedAt, attempts. Сервер о нём ничего не знает; `/api/progress-export` отдаёт legacy `progress.json` один раз для миграции.
- `runner.mjs` — `zig test` во временном `/tmp/zigwars-*`, таймаут 20с. **`zig test` пишет прогресс в stderr, не stdout**; статус FAIL печатается на строке ПОСЛЕ `expected X, found Y` — парсер построчный.
- `public/` — SPA без сборки. CodeMirror 6 через esm.sh CDN + кастомный `zig-lang.mjs` (StreamLanguage). Подсветка — свой `zwHighlight` (НЕ oneDark — он тянет чужую палитру).
- `content/mNN/SS-slug/` — kata; контракт файлов и чит-лист Zig 0.17 API — в `CONTENT_SPEC.md`. **Читай его перед добавлением/правкой kata.**
- `progress.json` — legacy-файл прогресса (до миграции в IndexedDB). **Не трогать** — служит бэкапом для импорта.
- `PROGRESS.md` — журнал разработки; дописывать значимые изменения в «Лог сессий».

## Жёсткие правила

- Тесты не редактируются пользователем: в UI `edTests` read-only (`EditorState.readOnly` + `editable.of(false)`), на сервере — дисковый `tests.zig`. Не возвращать эту возможность.
- Страница НЕ скроллится целиком — скроллятся только панели. Любой новый grid/flex-элемент с прокручиваемым потомком → `min-height: 0` (иначе дети распирают родителя до высоты контента). `overflow: hidden` на `html, body` — намеренно.
- Тема «field manual»: сине-графитовый фон `#1b1f27` (Codewars-подобный, НЕ почти чёрный — глаза устают), акцент — приглушённое золото `#e0a458`. IBM Plex Mono — хром, Golos Text — теория, JetBrains Mono — код.
- Весь UI-текст и контент — на русском.

## Грабли, которые уже пойманы

- esm.sh: `tags` — из `@lezer/highlight@1`, `HighlightStyle` — из `@codemirror/language@6`. `tags.builtin` НЕ существует → `t.standard(t.variableName)`.
- CodeMirror внутри flex: `.cm-editor { height: 100% }` + `overflow: hidden` на контейнере — скролл даёт `.cm-scroller` (overflow: auto встроен).
- Стаб kata обязан компилироваться: неиспользуемые параметры — ошибка Zig, сбрасывать `_ = x;` (но не если параметр в `@TypeOf` сигнатуры — pointless discard).
- Zig 0.17: `std.Io` (не `std.io`), `std.Io.Dir` (не `std.fs.Dir`), io — первым аргументом; ArrayList unmanaged (`append(alloc, …)`, `.empty`, нет `getLast()`); FBA → `error.OutOfMemory`; `"x"**1000` без пробелов. Полный список — `CONTENT_SPEC.md` + `PROGRESS.md`.
- yaml в lota: `desc` с двоеточием внутри — только в кавычках.
