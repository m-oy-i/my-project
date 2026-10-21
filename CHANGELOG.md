# 变更记录

本文件记录仓库内容的变化，格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

## [未发布]

## [0.1.0] - 2026-10-21

### 新增

- 建立仓库基础结构：`README.md`、`.gitignore`、`LICENSE`
- `docs/git-cheatsheet.md`：Git 常用操作速查，覆盖撤销、找回、分支、报错排查
- `docs/github-workflow.md`：分支策略、PR、Issue、Actions 与 Release
- `docs/windows-dev-setup.md`：Windows 下的终端、SSH、换行符与开发环境配置
- `scripts/repo-check.sh`：仓库体检脚本，检查未提交改动、未推送提交、大文件、敏感文件
- `scripts/git-sync.sh`：一键完成 add / commit / push
- `.github/workflows/lint.yml`：Markdown 格式检查
