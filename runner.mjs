import { spawn } from "node:child_process";
import { mkdtemp, writeFile, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";

const TIMEOUT_MS = 20000;

// Запускает zig test на паре solution+tests, затем (если есть) скрытые тесты.
// Скрытые прогоняются в том же каталоге/кэше — ученик их не видит,
// но решение должно пройти и их тоже.
export async function runTests(solutionSrc, testsSrc, { keep = false, hiddenSrc = null } = {}) {
  const dir = await mkdtemp(path.join(tmpdir(), "zigwars-"));
  try {
    await writeFile(path.join(dir, "solution.zig"), solutionSrc, "utf8");
    await writeFile(path.join(dir, "tests.zig"), testsSrc, "utf8");

    const cacheDir = path.join(dir, ".zig-cache");
    const res = await exec("zig", ["test", "tests.zig", "--cache-dir", cacheDir, "--name", "zigwars_test"], dir, TIMEOUT_MS);
    const main = parseOutput(res);

    if (!main.ok || !hiddenSrc) return main;

    await writeFile(path.join(dir, "tests_hidden.zig"), hiddenSrc, "utf8");
    const hres = await exec("zig", ["test", "tests_hidden.zig", "--cache-dir", cacheDir, "--name", "zigwars_hidden"], dir, TIMEOUT_MS);
    const hidden = parseOutput(hres);
    for (const t of hidden.tests) t.hidden = true;

    return {
      ok: hidden.ok,
      kind: hidden.kind === "compile" || hidden.kind === "timeout" ? hidden.kind : "tests",
      tests: [...main.tests, ...hidden.tests],
      passed: main.passed + hidden.passed,
      failed: main.failed + hidden.failed,
      summary: hidden.summary || main.summary,
      stdout: main.stdout + (hidden.stdout ? "\n" + hidden.stdout : ""),
      stderr: main.stderr + (hidden.stderr ? "\n" + hidden.stderr : ""),
      exitCode: hidden.exitCode,
      timedOut: hidden.timedOut,
      hiddenCount: hidden.tests.length,
    };
  } finally {
    if (!keep) await rm(dir, { recursive: true, force: true }).catch(() => {});
  }
}

function exec(cmd, args, cwd, timeout) {
  return new Promise((resolve) => {
    const child = spawn(cmd, args, { cwd });
    let stdout = "", stderr = "", killed = false;
    const timer = setTimeout(() => { killed = true; child.kill("SIGKILL"); }, timeout);
    child.stdout.on("data", (d) => { stdout += d; if (stdout.length > 1e6) child.kill("SIGKILL"); });
    child.stderr.on("data", (d) => { stderr += d; if (stderr.length > 1e6) child.kill("SIGKILL"); });
    child.on("close", (code) => { clearTimeout(timer); resolve({ code, stdout, stderr, killed }); });
    child.on("error", (e) => { clearTimeout(timer); resolve({ code: -1, stdout, stderr: String(e), killed: false }); });
  });
}

function parseOutput({ code, stdout, stderr, killed }) {
  // zig test пишет прогресс тестов и итог в stderr
  const combined = stderr + "\n" + stdout;
  const tests = [];
  // OK/SKIP идут в той же строке ("1/3 name...OK"), а при провале zig печатает
  // "...expected X, found Y\nFAIL (TestExpectedEqual)" — статус на следующей строке.
  const lines = combined.split("\n");
  // имя теста может содержать пробелы (русские имена) — берём всё до "..."
  const headRe = /^(\d+)\/(\d+)\s+(.+?)\.\.\.(.*)$/;
  for (let i = 0; i < lines.length; i++) {
    const m = headRe.exec(lines[i]);
    if (!m) continue;
    const short = m[3].replace(/^(solution|tests|tests_hidden)\.test\./, "");
    const tail = m[4];
    let status = /^(OK|SKIP|FAIL)\b/.exec(tail)?.[1];
    if (!status) {
      for (let j = i + 1; j < Math.min(i + 4, lines.length); j++) {
        const s = /^(OK|FAIL|SKIP)\b/.exec(lines[j])?.[1];
        if (s) { status = s; break; }
        if (headRe.test(lines[j])) break; // следующий тест — статус не найден
      }
    }
    if (!status) status = "FAIL";
    tests.push({ n: +m[1], of: +m[2], name: short, status });
  }
  const passed = tests.filter((t) => t.status === "OK").length;
  const failed = tests.filter((t) => t.status === "FAIL").length;

  let summary = "";
  const sm = /(\d+ passed;.*|All \d+ tests passed\.|0 passed;.*)/.exec(combined);
  if (sm) summary = sm[0];

  const compileError = /error(\(compile errors\))?:/.test(stderr) && tests.length === 0;

  return {
    ok: code === 0 && failed === 0 && !killed,
    kind: killed ? "timeout" : compileError ? "compile" : tests.length ? "tests" : "error",
    tests, passed, failed, summary,
    stdout: stdout.trimEnd(), stderr: stderr.trimEnd(), exitCode: code, timedOut: killed,
  };
}
