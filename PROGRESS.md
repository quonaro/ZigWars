# ZigWars — прогресс разработки

Веб-апп для изучения Zig 0.17.x с нуля (аналог Codewars): теория на русском + задания (kata) с тестами через `zig test`. **Статус: РАБОТАЕТ, v1 готова.**

## Запуск

`node server.mjs` → http://localhost:7100 (нужен `zig` в PATH)
Или через lota: `lota dev` (сервер + открывает браузер), `lota run`, `lota verify` — прогон всех 48 kata.

## Архитектура

- `server.mjs` — Node 24, чистый `node:http`, без зависимостей. Порт 7100.
- `runner.mjs` — `zig test` на паре solution+tests во временной папке; парсинг вывода из **stderr** (zig пишет прогресс туда); таймаут 20с.
- `public/` — SPA: CodeMirror 6 (esm.sh CDN), marked, oneDark, кастомный zig-lang.mjs (StreamLanguage).
- `content/mNN/SS-slug/` — kata: meta.json, theory.md, task.md, solution.zig, reference.zig, tests.zig, hint.md. Контракт — `CONTENT_SPEC.md`.
- `progress.json` — solved + drafts (сервер).

## Чеклист

### Приложение
- [x] runner.mjs (парсит stderr — zig test пишет прогресс в stderr!)
- [x] server.mjs (api: /api/modules, /api/kata, /api/run, /api/draft, /api/reset)
- [x] public/ UI (sidebar, вкладки доков, 2 редактора, output, Ctrl+Enter)
- [x] e2e проверено через CDP: страница рендерится, прогресс считается

### Контент — 10 модулей, 48 kata, все верифицированы (reference → все тесты OK, стаб компилируется)
- [x] m01 Основы синтаксиса (5)
- [x] m02 Массивы, слайсы, указатели, sentinel (5)
- [x] m03 Строки и std.fmt (5)
- [x] m04 Optionals (4)
- [x] m05 Ошибки: error sets, try/catch, errdefer (5)
- [x] m06 Struct/enum/union, switch (5)
- [x] m07 Аллокаторы и память (5)
- [x] m08 Контейнеры std (5)
- [x] m09 Comptime и дженерики (5)
- [x] m10 std.Io, файлы, build.zig/ZON (4)

## Пойманные особенности 0.17 (важно при добавлении контента)

- `zig test` пишет `N/M name...OK` в **stderr**, не stdout.
- `comptime var` в цикле — только `inline while`; `comptime blk:` на container scope — redundant.
- `std.zon.parse.fromSlice(T, options-struct)` — новый API.
- FBA возвращает `error.OutOfMemory` (не NoSpaceLeft); `alloc.resize` на shrink у testing.allocator → `false` — надо `realloc` с fallback.
- Стаб обязан компилироваться: `_ = param;` для неиспользуемых параметров (но не если параметр фигурирует в `@TypeOf(param)` в сигнатуре — pointless discard).
- Оператор `**` (повторение массивов/строк) в 0.17.0 УДАЛЁН — `"x"**1000` и `[_]u8{1,2}**3` не компилируются. `++` (конкатенация) жив. `ArrayList.writer()` тоже нет — строки через `std.Io.Writer.Allocating` или `appendSlice`/`appendNTimes`.
- Имена тестов с пробелами: парсер runner обязан брать имя нежадно до `...` (`(.+?)\.\.\.`), `\S+` теряет такие тесты и ломает подсчёт.

## v2 — сделано

- [x] Подсветка ошибок компилятора в редакторе: `@codemirror/lint` (gutter + underline + тултип), парсинг `solution.zig:L:C: error:` из stderr.
- [x] Автоскролл sidebar к активной kata; клавиатурная навигация: `Alt+N`/`Alt+P` (работает и в русской раскладке — `т`/`з`), `Enter`/`Space` на сфокусированном item сайдбара (items focusable, `tabIndex=0`).
- [x] «Скрытые» тесты: `tests_hidden.zig` у всех 48 kata (~200 тестов). Гоняются после видимых, только если те зелёные; в выводе — бейдж «скрытый». `lota verify` проверяет и их. API: `hasHidden` в `/api/kata`.
- [x] Обзор пройденного: `progress.attempts[key]` считает прогоны; топбар показывает `попыток: N · решено ДД.ММ HH:MM · есть скрытые тесты`.
- [x] Мобильная вёрстка (≤720px): вертикальный стек sidebar(≤22vh) → docs(≤42vh) → work, тап-таргеты больше.

## Пойманные особенности 0.17 (важно при добавлении контента)

## Лог сессий

- Сессия 1: каркас + UI + 48 kata по всем 10 модулям, e2e через CDP. Запуск проверен.
- Сессия 2 (design pass, скилл frontend-design): тёплая «field manual» тема (графит #14110d + янтарь #f7a41d), IBM Plex Mono как голос интерфейса + Golos Text для теории, прогресс-бар в топбаре, счётчики модулей `n/m`, hashchange-роутер, автоскролл сайдбара, чистка stderr вывода (вырезаются стектрейсы/адреса/tmp-пути, подсветка `file:line:col`). Баг парсера runner: FAIL-статус zig печатает на СЛЕДУЮЩЕЙ строке после `...expected X, found Y` — парсер теперь построчный.
- Сессия 3: весь остаток v2 — lint-диагностика в редакторе (`setDiagnostics(ed.state, …)` — НЕ view!), хоткеи Alt+N/P + focusable сайдбар, скрытые тесты `tests_hidden.zig` на всех 48 kata (написаны двумя субагентами, каждый верифицирован на reference; `lota verify` расширен), счётчик попыток + «решено <дата>» в топбаре, мобильная вёрстка. Баг парсера runner №2: `\S+` в head-регекс терял тесты с пробелами в имени → `(.+?)`. e2e через CDP: маркеры ошибок, бейджи, Alt+N, мобильный вид 390px — всё проверено.
- Сессия 3: `lota.yml` (dev/run/verify; verify → 48 kata, 0 fails). Ребаланс темы: почти чёрный фон `#0a0a09`, акцент — пыльное золото `#c99e6a` (был кислотный #f7a41d); oneDark выкинут (тянул свою палитру), свой `zwHighlight` HighlightStyle. Фиксы: `tags.builtin` не существует (падала подсветка → `t.standard(t.variableName)`); `tags` импортируется из `@lezer/highlight`, `HighlightStyle` — из `@codemirror/language`. Скролл: `min-height:0` на grid/flex-элементах (`#work`, `#docs`, `.editor`, `#output`) + `overflow:hidden` на html/body — страница не прокручивается, скроллятся только панели. **Тесты read-only**: `mkEditor(el,doc,{readOnly})` → `EditorView.editable.of(false)`+`EditorState.readOnly.of(true)` для edTests; `/api/run` игнорирует `tests` из payload и читает `tests.zig` с диска; заголовок панели помечен `tests.zig · read-only`.
- Сессия 4 (fonts pass): код читался плохо → выделен `--code` (JetBrains Mono в приоритете). `.cm-editor`/`.cm-gutters`/`.cm-content`, `#output` и `markdown-body code` переведены на `--code` (IBM Plex Mono остаётся только хромом UI: табы, заголовки, кнопки). Редактор 13px→13.5px, вывод 12.5→13px + line-height 1.55.
- Сессия 5: hot-reload без зависимостей (Vite отвергнут — проект no-build, esm.sh CDN). `fs.watch(recursive)` на `public/` и `content/` → SSE `/api/dev-events`. События: `style` (css, без reload — подмена href с `?t=`), `page` (js/html/mjs → `location.reload()`), `content` (перечитать модули + текущую kata, черновик редактора сохраняется), `hello`+bootId (при reconnect после `node --watch`-рестарта → reload). `lota dev` теперь `node --watch server.mjs` — правки `server.mjs`/`runner.mjs` рестартят сервер. Дебаунс 500мс на событие.
