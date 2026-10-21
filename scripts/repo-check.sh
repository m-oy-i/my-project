#!/usr/bin/env bash
# 仓库体检：检查本地状态、未推送提交、大文件与敏感文件
# 用法：bash scripts/repo-check.sh

set -uo pipefail

cd "$(git rev-parse --show-toplevel 2>/dev/null)" || {
  printf '当前目录不在 git 仓库内\n' >&2
  exit 1
}

green() { printf '\033[32m%s\033[0m\n' "$1"; }
red()   { printf '\033[31m%s\033[0m\n' "$1"; }
warn()  { printf '\033[33m%s\033[0m\n' "$1"; }
section()  { printf '\n\033[1;36m== %s ==\033[0m\n' "$1"; }

issues=0

section "仓库"
printf '路径: %s\n' "$PWD"
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '未知')
printf '分支: %s\n' "$branch"

upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)
if [ -n "$upstream" ]; then
  printf '上游: %s\n' "$upstream"
else
  warn '未设置上游分支，首次推送需要 git push -u origin 分支名'
fi

section "未提交改动"
if git diff --quiet && git diff --cached --quiet; then
  green '工作区干净'
else
  git status --short
  issues=$((issues + 1))
fi

section "未推送提交"
if [ -n "$upstream" ]; then
  ahead=$(git rev-list --count "@{u}..HEAD" 2>/dev/null || echo 0)
  if [ "$ahead" -eq 0 ]; then
    green '已全部同步到远端'
  else
    red "有 $ahead 个提交还没推送"
    issues=$((issues + 1))
  fi
else
  warn '无上游分支，跳过检查'
fi

section "大文件（超过 1MB）"
big=0
while IFS= read -r -d '' f; do
  [ -f "$f" ] || continue
  size=$(wc -c < "$f" 2>/dev/null | tr -d '[:space:]')
  size=${size:-0}
  if [ "$size" -gt 1048576 ]; then
    printf '%s KB  %s\n' "$((size / 1024))" "$f"
    big=$((big + 1))
  fi
done < <(git ls-files -z)
if [ "$big" -eq 0 ]; then
  green '没有大文件'
else
  warn "发现 $big 个大文件，确认是否真的需要纳入版本控制"
fi

section "敏感文件"
sensitive=$(git ls-files | grep -Ei '(^|/)(\.env(\..*)?|.*\.pem|.*\.key|id_rsa|id_ed25519|.*\.p12)$' || true)
if [ -z "$sensitive" ]; then
  green '未发现明显的密钥或环境文件'
else
  red '以下文件已被纳入版本控制，确认是否误提交：'
  printf '%s\n' "$sensitive"
  issues=$((issues + 1))
fi

section "结果"
if [ "$issues" -eq 0 ]; then
  green '体检通过，可以正常提交'
  exit 0
fi

red "有 $issues 项需要处理"
exit 1
