#!/usr/bin/env bash
set -euo pipefail

COMPILER_CMD="${COMPILER_CMD:-compiler --semantic}"

RED=$(printf '\033[31m')
GRN=$(printf '\033[32m')
YEL=$(printf '\033[33m')
RST=$(printf '\033[0m')

fail_count=0
pass_count=0

echo "== PASS cases =="
for f in tests/semantic/pass/*.c; do
  if [ ! -e "$f" ]; then continue; fi
  if $COMPILER_CMD "$f" >/dev/null 2>tmp.err; then
    echo -e "${GRN}PASS${RST} $f"
    pass_count=$((pass_count+1))
  else
    echo -e "${RED}FAIL (unexpected error)${RST} $f"
    cat tmp.err
    fail_count=$((fail_count+1))
  fi
done

echo ""
echo "== FAIL cases =="
for f in tests/semantic/fail/*.c; do
  base=$(basename "$f")
  golden="tests/golden/fail/${base}.golden"
  if $COMPILER_CMD "$f" >/dev/null 2>tmp.err; then
    echo -e "${RED}FAIL (expected error, got success)${RST} $f"
    fail_count+=1
  else
    if diff -u "$golden" tmp.err >/dev/null; then
      echo -e "${GRN}PASS (matched golden)${RST} $f"
      pass_count=$((pass_count+1))
    else
      echo -e "${YEL}MISMATCH${RST} $f"
      echo "Expected:"
      cat "$golden" || true
      echo "Got:"
      cat tmp.err
      fail_count=$((fail_count+1))
    fi
  fi
done

rm -f tmp.err || true

echo ""
echo "Summary: ${GRN}${pass_count} passed${RST}, ${RED}${fail_count} failed${RST}."
if [ "$fail_count" -ne 0 ]; then exit 1; fi
