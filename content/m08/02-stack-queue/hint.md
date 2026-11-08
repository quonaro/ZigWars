Стек — `std.ArrayList(i64)`: `append(alloc, v)` = push, `pop()` = pop (вернёт `?i64`, разверни через `orelse return error.InvalidExpression`).

---

Токен — оператор, если `tok.len == 1` и `tok[0]` один из `+-*/`. Иначе — `std.fmt.parseInt(i64, tok, 10)`.

---

Осторожно: первый снятый операнд — это `b`, второй — `a`. Выражение `"4","2","-"` считается как `a - b = 4 - 2`.
