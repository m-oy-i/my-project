# GitHub 工作流

个人仓库不需要复杂流程，但有些习惯值得从第一天就养成。

## 分支策略怎么选

| 场景 | 做法 |
| --- | --- |
| 只有自己用，改动小 | 直接提交 `main`，不建分支 |
| 做实验、可能半途放弃 | 建 `feature/xxx` 或 `try/xxx` 分支 |
| 多人协作 | 功能分支 + Pull Request，`main` 受保护 |
| 需要长期维护两个版本 | `main` 加 `release/x.y` 分支 |

分支名用英文短横线，一眼能看出干什么，例如 `fix/ssh-auth`、`docs/git-notes`。

## 提交信息的写法

一句能看懂的话，说明"改了什么"，而不是"改了一下"。

```text
类型: 简述

可选的正文，解释为什么这么改
```

类型用 `新增`、`修复`、`文档`、`维护`、`重构` 这类前缀，筛选历史时很有用。如果要自动化生成变更日志，也可以改用 Conventional Commits 的英文前缀（`feat:`、`fix:`、`docs:`）。

## Pull Request

即使只有自己，涉及"改一大片"的时候也可以走 PR，好处是能看到完整 diff 再合并。

流程：

```bash
git switch -c docs/rewrite-readme
# 改文件
git add -A
git commit -m "文档: 重写 README 索引"
git push -u origin docs/rewrite-readme
```

推完后 GitHub 页面会直接出现 **Compare & pull request** 按钮。写好标题和说明，点创建，自己 review 一遍 diff，再 **Squash and merge**。

## Issue 当待办清单

Issue 不只是给别人提问题，自己用更合适：

- 想到要做的事，开一个 Issue 记下来，不用立刻做。
- 用标签分类：`bug`、`enhancement`、`docs`、`idea`。
- 提交里写 `Closes #12`，合并后 Issue 自动关闭。
- 用 GitHub Projects 把 Issue 排成表格视图，比记在脑子里可靠。

## GitHub Actions 入门

在 `.github/workflows/` 下放一个 YAML 就生效。最小结构：

```yaml
name: 检查
on:
  push:
    branches: [main]
  workflow_dispatch:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "这里执行命令"
```

几个要点：

- `on` 决定触发时机，`workflow_dispatch` 表示可以在网页上手动点运行。
- 公开仓库的 Actions 免费，私有仓库每月有额度。
- 每个 `run` 步骤默认在仓库根目录执行。
- 敏感信息放 Settings → Secrets and variables → Actions，用 `${{ secrets.名字 }}` 引用，不要写进代码。

本仓库的 `lint.yml` 就是这种结构，作用是检查 Markdown 格式问题。

## Release 与标签

打标签并发布，让"某个时间点的状态"可回溯：

```bash
git tag -a v0.1.0 -m "第一版文档集合"
git push origin v0.1.0
```

然后在仓库右侧 **Releases** → **Draft a new release**，选择刚推的标签，写变更说明。附带的源码 zip 是 GitHub 自动生成的，不用手动传。

## .gitignore 什么时候加都不算晚

已经提交了本该忽略的文件：

```bash
git rm --cached 文件路径        # 只是从仓库移除，本地文件保留
git commit -m "维护: 移除误提交的环境文件"
```

如果这个文件曾经包含密钥，改 `.gitignore` 不够，必须去对应平台**作废该密钥**，因为历史记录里仍然能翻出来。

## 一些实用设置

- **默认分支改名**：Settings → General → Default branch，改完后本地执行 `git branch -m main` 和 `git remote set-url` 相应调整。
- **开启 Secret Scanning**：Settings → Code security，公开仓库免费，能在误推令牌时收到提醒。
- **仓库描述和 Topics**：填上之后自己的仓库列表更好搜。
- **README 里的徽章**：`https://img.shields.io/badge/文字-内容-颜色` 可以自己拼。
