# my-project

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

个人项目库：把日常真正用得上的文档、脚本和约定集中放在一处，避免每次重新翻找。

## 内容索引

| 路径 | 说明 |
| --- | --- |
| [`docs/git-cheatsheet.md`](docs/git-cheatsheet.md) | Git 常用操作速查，含撤销、找回、改写历史、报错排查 |
| [`docs/github-workflow.md`](docs/github-workflow.md) | 分支策略、PR 流程、Issue、Actions 与 Release |
| [`docs/windows-dev-setup.md`](docs/windows-dev-setup.md) | Windows 下的开发环境、终端、SSH 与换行符配置 |
| [`docs/ai-github-radar.md`](docs/ai-github-radar.md) | GitHub 上的 AI 资源雷达：Agent Skills、提示词库、可玩工具（2026-10-21 快照） |
| [`docs/how-to-write-a-skill.md`](docs/how-to-write-a-skill.md) | 按官方规范写 Agent Skill：字段约束、加载机制、常见坑 |
| [`scripts/check-links.sh`](scripts/check-links.sh) | 扫描 Markdown 里的外链是否还能访问 |
| [`scripts/repo-check.sh`](scripts/repo-check.sh) | 仓库体检：未提交、未推送、大文件、敏感文件 |
| [`scripts/git-sync.sh`](scripts/git-sync.sh) | 一条命令完成 add / commit / push |
| [`CHANGELOG.md`](CHANGELOG.md) | 变更记录 |

## 快速开始

```bash
git clone git@github.com:m-oy-i/my-project.git
cd my-project
```

跑一次仓库体检，确认本地状态健康：

```bash
bash scripts/repo-check.sh
```

日常提交用同步脚本，省掉三步操作：

```bash
bash scripts/git-sync.sh "文档: 补充 Git 速查的撤销部分"
```

## 维护约定

- 主分支 `main` 保持可直接阅读和可用，改动直接提交到 `main`。
- 提交信息用中文，格式为 `类型: 简述`，类型取 `新增`、`修复`、`文档`、`维护` 之一。
- 新增内容后同步更新上面的索引表，并在 `CHANGELOG.md` 记一行。
- 内容以"以后自己真的会回来看"为标准，不写填充性质的文字。
- 令牌、私钥、`.env` 一律不进仓库，`.gitignore` 已拦截常见形式。

## 目录结构

```text
my-project/
├── .github/workflows/lint.yml   # Markdown 格式检查
├── docs/                        # 参考文档
├── scripts/                     # 命令行脚本
├── .gitignore
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## 许可

[MIT](LICENSE) © 2026 m-oy-i
