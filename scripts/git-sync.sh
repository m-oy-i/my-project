#!/usr/bin/env bash
# 一条命令完成 add / commit / push
# 用法：bash scripts/git-sync.sh "文档: 补充说明"
#       bash scripts/git-sync.sh          # 交互式输入提交说明

set -euo pipefail

cd "$(git rev-parse --show-toplevel 2>/dev/null)" || {
  printf '当前目录不在 git 仓库内\n' >&2
  exit 1
}

msg="${1:-}"
if [ -z "$msg" ]; then
  printf '提交说明: '
  read -r msg
fi

if [ -z "$msg" ]; then
  printf '提交说明不能为空\n' >&2
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  printf '没有需要提交的改动\n'
else
  git commit -m "$msg"
fi

branch=$(git rev-parse --abbrev-ref HEAD)
upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)

if [ -z "$upstream" ]; then
  printf '首次推送，建立上游跟踪…\n'
  git push -u origin "$branch"
else
  ahead=$(git rev-list --count "@{u}..HEAD" 2>/dev/null || echo 0)
  if [ "$ahead" -eq 0 ]; then
    printf '本地与远端已同步，无需推送\n'
  else
    git push
  fi
fi

printf '\n当前状态：\n'
git log --oneline -3
