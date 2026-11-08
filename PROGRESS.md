# ZigWars — журнал разработки

## Лог сессий

### 2026-11-08 — прогресс перенесён в IndexedDB
- `progress.json` больше не пишется сервером. Прогресс (draft, solvedAt, attempts) живёт в IndexedDB на клиенте: `public/db.mjs`, БД `zigwars`, store `katas` (key `"m01/01-slug"`) + store `meta` (флаг `migrated`).
- Клиент при старте один раз импортирует legacy `progress.json` через `/api/progress-export`; файл оставлен как бэкап, не трогать.
- Сервер: убраны `/api/draft` и `/api/reset`, из `/api/kata` убраны solved/draft/attempts/reference; эталон теперь отдаёт `/api/reference/<mod>/<kata>` (unlock — на клиенте, локальный тренажёр).
- `/api/run` только прогоняет `zig test` и больше не пишет на диск.
- `app.js`: draft-сохранение с debounce → `kataPatch`, сброс решения без сервера (`data.solution` уже в памяти), solved/attempts пишутся в IDB после прогона.
