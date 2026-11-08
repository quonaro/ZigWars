Нужен не `defer`, а `errdefer` — иначе счётчик будет расти и на успехе.

---

`errdefer rollbacks += 1;` — объяви в начале функции, до проверки `fail`.

---

Полная функция: `errdefer rollbacks += 1; if (fail) return error.SimulatedFailure;`
