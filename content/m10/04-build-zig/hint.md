`std.zon.parse.fromSlice(Config, options)` принимает одну options-структуру с полями `gpa`, `arena`, `source`, `diagnostics`.

---

```zig
var diagnostics: std.zon.parse.Diagnostics = undefined;
return std.zon.parse.fromSlice(Config, .{
    .gpa = arena,
    .arena = arena,
    .source = text,
    .diagnostics = &diagnostics,
});
```
