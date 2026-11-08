// Прогресс пользователя в IndexedDB (БД "zigwars", v1):
//   store "katas": key "m01/02-slug" → { draft, solvedAt, attempts }
//   store "meta":  служебные флаги (напр. migrated)
// Сервер ничего не знает о прогрессе — только контент и zig test.

const DB = "zigwars";

const rp = (r) => new Promise((res, rej) => { r.onsuccess = () => res(r.result); r.onerror = () => rej(r.error); });
const done = (t) => new Promise((res, rej) => { t.oncomplete = res; t.onerror = () => rej(t.error); });

let _db;
function db() {
  return (_db ??= new Promise((res, rej) => {
    const r = indexedDB.open(DB, 1);
    r.onupgradeneeded = () => {
      const d = r.result;
      if (!d.objectStoreNames.contains("katas")) d.createObjectStore("katas");
      if (!d.objectStoreNames.contains("meta")) d.createObjectStore("meta");
    };
    r.onsuccess = () => res(r.result);
    r.onerror = () => rej(r.error);
  }));
}

export async function kataGet(key) {
  return (await rp((await db()).transaction("katas").objectStore("katas").get(key))) || {};
}

export async function kataPatch(key, patch) {
  const t = (await db()).transaction("katas", "readwrite");
  const s = t.objectStore("katas");
  const cur = (await rp(s.get(key))) || {};
  s.put({ ...cur, ...patch }, key);
  await done(t);
}

// key → { draft, solvedAt, attempts } для всех kata разом
export async function katasAll() {
  const t = (await db()).transaction("katas");
  const s = t.objectStore("katas");
  const [keys, vals] = await Promise.all([rp(s.getAllKeys()), rp(s.getAll())]);
  return Object.fromEntries(keys.map((k, i) => [k, vals[i]]));
}

export const metaGet = async (k) => rp((await db()).transaction("meta").objectStore("meta").get(k));
export async function metaSet(k, v) {
  const t = (await db()).transaction("meta", "readwrite");
  t.objectStore("meta").put(v, k);
  await done(t);
}
