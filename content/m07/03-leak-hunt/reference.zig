const std = @import("std");

fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

/// Отсортированная копия xs без подряд идущих дубликатов.
/// ВНИМАНИЕ: в этой версии есть утечки — найди и почини их
/// с помощью defer/errdefer, не меняя алгоритм.
pub fn dedupCopy(alloc: std.mem.Allocator, xs: []const i32) ![]i32 {
    const tmp = try alloc.dupe(i32, xs); // сортировать будем копию — xs же const
    defer alloc.free(tmp); // tmp — временный: умрёт при любом выходе
    std.mem.sort(i32, tmp, {}, lessThan);

    var w: usize = 0;
    for (tmp) |v| {
        if (w == 0 or tmp[w - 1] != v) {
            tmp[w] = v;
            w += 1;
        }
    }

    const out = try alloc.dupe(i32, tmp[0..w]);
    // out уходит вызывающему — errdefer не нужен: после аллокации падающих операций нет
    return out;
}
