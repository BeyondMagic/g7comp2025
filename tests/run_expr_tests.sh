#!/usr/bin/env bash
set -euo pipefail

# Configurações
BIN={BIN:-./c2lua}            # Caminho do executável (padrão: ./c2lua)
TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
GRAY="\033[0;90m"
RESET="\033[0m"

pass_count=0
fail_count=0

function run_case() {
  local kind="$1"     # pass | fail-lex | fail-syn
  local file="$2"
  local rel="${file#${TEST_ROOT}/}"

  local out="$(mktemp)"
  local err="$(mktemp)"

  set +e
  ${BIN} < "$file" >"$out" 2>"$err"
  local code=$?
  set -e

  # Heurísticas de verificação:
  local has_syn_err
  local has_lex_err
  if grep -q "Erro sintático" "$err"; then has_syn_err=1; else has_syn_err=0; fi
  if grep -q "Caractere inválido" "$err"; then has_lex_err=1; else has_lex_err=0; fi

  if [[ "$kind" == "pass" ]]; then
    # Espera: código 0, sem mensagens de erro
    if [[ $code -eq 0 && $has_syn_err -eq 0 && $has_lex_err -eq 0 ]]; then
      # Se existir um .ast ao lado, comparar saída (normalizando espaços)
      local golden="{file%.*}.ast"
      if [[ -s "$golden" && ! $(grep -E "^// TODO" "$golden") ]]; then
        # Normalização básica: remover espaços extras
        sed 's/[[:space:]]\+/ /g' "$out" | sed 's/^ \+//; s/ \+$//' > "$out.norm"
        sed 's/[[:space:]]\+/ /g' "$golden" | sed 's/^ \+//; s/ \+$//' > "$golden.norm"
        if diff -u "$golden.norm" "$out.norm" >"$out.diff"; then
          echo -e "  ${GREEN}✔${RESET} PASS  $rel"
          ((pass_count++))
        else
          echo -e "  ${YELLOW}⚠${RESET} PASS (AST divergente)  $rel"
          echo -e "  ${GRAY}Veja diff em: $out.diff${RESET}"
          ((fail_count++))
        fi
      else
        echo -e "  ${GREEN}✔${RESET} PASS  $rel"
        ((pass_count++))
      fi
    else
      echo -e "  ${RED}✘${RESET} FAIL (esperava sucesso) $rel"
      echo -e "  ${GRAY}Exit: $code | stderr:${RESET}"
      sed 's/^/    /' "$err"
      ((fail_count++))
    fi
  elif [[ "$kind" == "fail-lex" ]]; then
    # Espera: erro léxico detectado (mensagem ou código != 0)
    if [[ $code -ne 0 || $has_lex_err -eq 1 ]]; then
      echo -e "  ${GREEN}✔${RESET} PASS (detectou erro léxico)  $rel"
      ((pass_count++))
    else
      echo -e "  ${RED}✘${RESET} FAIL (não detectou erro léxico) $rel"
      ((fail_count++))
    fi
  else # fail-syn
    # Espera: erro sintático detectado (mensagem ou código != 0)
    if [[ $code -ne 0 || $has_syn_err -eq 1 ]]; then
      echo -e "  ${GREEN}✔${RESET} PASS (detectou erro sintático)  $rel"
      ((pass_count++))
    else
      echo -e "  ${RED}✘${RESET} FAIL (não detectou erro sintático) $rel"
      ((fail_count++))
    fi
  fi

  rm -f "$out" "$err" "$out.norm" "$golden.norm" "$out.diff" 2>/dev/null || true
}

function run_suite() {
  local kind="$1"
  local dir="$TEST_ROOT/expr/$kind"
  [[ -d "$dir" ]] || return 0
  echo -e "\n==> Rodando casos: $kind"
  shopt -s nullglob
  for f in "$dir"/*.c; do
    run_case "$kind" "$f"
  done
}

echo "Usando binário: $BIN"
run_suite pass
run_suite fail-lex
run_suite fail-syn

echo -e "\nResuldado final: ${GREEN}$pass_count PASS${RESET}, ${RED}$fail_count FAIL${RESET}"
[[ $fail_count -eq 0 ]] || exit 1
