# ⚡ ZigWars

Локальный тренажёр для изучения **Zig 0.17.x** с нуля — аналог Codewars: теория на русском + задания (kata) с реальными тестами через `zig test`.

## Запуск

```bash
node server.mjs          # требуется zig 0.17 в PATH
# открыть http://localhost:7100
```

## Использование

- Слева — модули и kata (kyu = сложность).
- Центр — материал / задание / подсказка / эталонное решение (открывается после решения).
- Справа — редакторы `solution.zig` и `tests.zig`, кнопка **ТЕСТ** (или `Ctrl+Enter`) гоняет `zig test`, вывод — ниже.
- Прогресс и черновики — в `progress.json` (переживает перезапуск).

## Добавление kata

См. `CONTENT_SPEC.md`: `content/mNN/SS-slug/` с файлами meta.json / theory.md / task.md / solution.zig / reference.zig / tests.zig / hint.md. Проверка: `cp reference.zig solution.zig && zig test tests.zig` → зелёное; `zig ast-check` стаба → ок.
