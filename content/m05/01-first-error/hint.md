Структура та же, что у safeDiv: проверка `b == 0` и ранний возврат — только вместо `null` теперь `error.DivisionByZero`.

---

`return error.DivisionByZero;` — имя ошибки пишется с точкой, как поле.

---

Целиком: `if (b == 0) return error.DivisionByZero; return @divTrunc(a, b);`
