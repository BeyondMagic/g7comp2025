#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/lib/test_utils.sh"

PASS_DIR="$ROOT_DIR/semantic/pass"
FAIL_DIR="$ROOT_DIR/semantic/fail"
TMP_DIR="${TMP_DIR:-$ROOT_DIR/../build/test-tmp}"
mkdir -p "$TMP_DIR"

pass_count=0
fail_count=0

echo "[Semantic] Rodando PASS (C -> Lua -> exec) ..."
for cfile in "$PASS_DIR"/*.c; do
  [ -e "$cfile" ] || continue
  base="$(basename "$cfile" .c)"
  luafile="$PASS_DIR/$base.lua"
  outlua="$TMP_DIR/$base.out.lua"
  outlog="$TMP_DIR/$base.run.log"

  # Compila C->Lua
  "$C2LUA" "$cfile" > "$outlua"

  # Checa sintaxe Lua
  check_lua_syntax "$outlua"

  # Executa Lua
  if ! "$LUA_BIN" "$outlua" > "$outlog" 2>&1; then
    echo "FAIL (exec): $base"
    cat "$outlog"
    ((fail_count++)) || true
    continue
  fi

  # Compara com Lua esperado (semântica igual)
  if ! diff_golden "$outlua" "$luafile"; then
    echo "FAIL (lua mismatch): $base"
    ((fail_count++)) || true
    continue
  fi

  echo "PASS: $base"
  ((pass_count++)) || true
done

echo
echo "[Semantic] Rodando FAIL (erros devem coincidir com golden .err) ..."
for cfile in "$FAIL_DIR"/*.c; do
  [ -e "$cfile" ] || continue
  base="$(basename "$cfile" .c)"
  errfile="$FAIL_DIR/$base.err"
  goterr="$TMP_DIR/$base.got.err"

  # Espera falha: captura stderr e stdout
  set +e
  "$C2LUA" "$cfile" > /dev/null 2> "$goterr.raw"
  status=$?
  set -e

  if [ $status -eq 0 ]; then
    echo "FAIL (esperava erro, compilou com sucesso): $base"
    ((fail_count++)) || true
    continue
  fi

  normalize_err < "$goterr.raw" > "$goterr"

  if ! diff_golden "$goterr" "$errfile"; then
    echo "FAIL (mensagem diferente): $base"
    ((fail_count++)) || true
    continue
  fi

  echo "PASS (erro): $base"
  ((pass_count++)) || true
done

echo
echo "Resumo: $pass_count PASS, $fail_count FAIL"
exit $([ $fail_count -eq 0 ])
