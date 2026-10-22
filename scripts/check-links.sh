#!/usr/bin/env bash
# 检查 Markdown 文档里的外链能否访问
# 用法：bash scripts/check-links.sh                 # 检查仓库内所有 .md
#       bash scripts/check-links.sh docs/xxx.md     # 只检查指定文件
#
# 结果分四类，别混为一谈：
#   正常    2xx / 3xx
#   失效    404 / 410，链接确实没了
#   反爬    403 / 429，服务器拒绝自动请求，不代表链接无效
#   连不上  000 或 5xx，本机网络、DNS、代理拦截导致，换环境再试
#
# 退出码：0 无失效；1 有失效链接

set -uo pipefail

cd "$(git rev-parse --show-toplevel 2>/dev/null)" || {
  printf '当前目录不在 git 仓库内\n' >&2
  exit 1
}

# 临时文件放 .git 下，避免 Windows 临时目录的路径问题
gitdir=$(git rev-parse --git-dir)
tmp_urls="$gitdir/link-check-urls.$$"
tmp_res="$gitdir/link-check-results.$$"
cleanup() { rm -f "$tmp_urls" "$tmp_res"; }
trap cleanup EXIT

files=("$@")
if [ ${#files[@]} -eq 0 ]; then
  while IFS= read -r f; do
    files+=("$f")
  done < <(git ls-files '*.md')
fi

if [ ${#files[@]} -eq 0 ]; then
  printf '没有找到 Markdown 文件\n'
  exit 0
fi

for f in "${files[@]}"; do
  [ -f "$f" ] || continue
  grep -oE 'https?://[^ ()<>"`]+' "$f" 2>/dev/null || true
done | sed -E 's/[.,;:!?]+$//' | sort -u > "$tmp_urls"

total=$(wc -l < "$tmp_urls" | tr -d '[:space:]')
printf '检查 %d 个文档，去重后 %s 个链接\n\n' "${#files[@]}" "$total"

check_one() {
  local url="$1" code
  code=$(curl -sS -o /dev/null -w '%{http_code}' -L --max-time 12 \
    -A 'Mozilla/5.0 (compatible; link-check)' "$url" 2>/dev/null) || code=000
  [ -n "$code" ] || code=000
  printf '%s\t%s\n' "$code" "$url"
}
export -f check_one

# 并发 8 路检查
xargs -I{} -P 8 bash -c 'check_one "$@"' _ {} < "$tmp_urls" > "$tmp_res" 2>/dev/null

ok=0
broken=0
blocked=0
unreachable=0

while IFS=$'\t' read -r code url; do
  [ -n "${code:-}" ] || continue
  case "$code" in
    2??|3??)
      ok=$((ok + 1))
      ;;
    404|410)
      broken=$((broken + 1))
      printf '\033[31m[%s] 失效：%s\033[0m\n' "$code" "$url"
      ;;
    403|429)
      blocked=$((blocked + 1))
      printf '\033[33m[%s] 反爬/限流：%s\033[0m\n' "$code" "$url"
      ;;
    *)
      unreachable=$((unreachable + 1))
      printf '\033[90m[%s] 连不上：%s\033[0m\n' "$code" "$url"
      ;;
  esac
done < "$tmp_res"

printf '\n共 %s 个：正常 %d，失效 %d，反爬 %d，连不上 %d\n' \
  "$total" "$ok" "$broken" "$blocked" "$unreachable"

if [ "$unreachable" -gt 0 ]; then
  printf '\033[33m提示：连不上的属于本机网络问题（代理白名单、DNS、防火墙），不是链接本身失效。\033[0m\n'
  printf '\033[33m换到能直连外网的环境重跑，或手动确认后忽略。\033[0m\n'
fi

if [ "$broken" -gt 0 ]; then
  exit 1
fi
exit 0
