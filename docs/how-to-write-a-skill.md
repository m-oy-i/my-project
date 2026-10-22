# 怎么写一个 Agent Skill

依据 [Agent Skills 官方规范](https://agentskills.io/specification) 整理，对应当前主流 agent（Claude Code、Codex、Cursor、Gemini CLI、OpenCode 等）通用格式。

## 一句话说清是什么

一个 skill 就是一个文件夹，里面至少有一个 `SKILL.md`。文件开头是 YAML 元数据，下面是给 agent 看的指令。就这么简单，不需要框架、不需要编译。

```text
my-skill/
├── SKILL.md          # 必需：元数据 + 指令
├── scripts/          # 可选：可执行代码
├── references/       # 可选：参考资料
├── assets/           # 可选：模板、图片、数据
└── ...               # 其他任何文件
```

## 加载机制：为什么不能把所有东西塞进一个文件

Agent 分三层加载，理解这点才能写好：

| 阶段 | 加载内容 | 成本 |
| --- | --- | --- |
| 发现 | 只有 `name` 和 `description` | 约 100 token / 每个 skill |
| 激活 | 完整的 `SKILL.md` 正文 | 建议 5000 token 以内 |
| 执行 | `scripts/`、`references/`、`assets/` 里的文件 | 按需，用到才读 |

所以：**描述决定它会不会被用上，正文决定用得对不对，附属文件决定能省多少上下文。** 正文控制在 500 行以内，详细资料拆到 `references/`。

## frontmatter 字段

只有两个是必需的。

| 字段 | 必需 | 约束 |
| --- | --- | --- |
| `name` | 是 | 1–64 字符，只能小写字母、数字、连字符，不能以连字符开头或结尾，不能连续连字符，**必须与父目录同名** |
| `description` | 是 | 1–1024 字符，非空，要同时说清「做什么」和「什么时候用」 |
| `license` | 否 | 许可证名称，或指向附带许可文件的引用 |
| `compatibility` | 否 | 1–500 字符，环境要求（目标产品、系统依赖、网络需求） |
| `metadata` | 否 | 键值对，键和值都是字符串，建议键名加前缀避免冲突 |
| `allowed-tools` | 否 | 空格分隔的预授权工具列表，实验性，各实现支持不一 |

最小可用版本：

```yaml
---
name: my-skill
description: 说明这个 skill 做什么，以及在什么情况下该用它。
---
```

## 两个最容易写坏的字段

### `name`

合法：`pdf-processing`、`data-analysis`、`code-review`

非法：`PDF-Processing`（大写）、`-pdf`（连字符开头）、`pdf--processing`（连续连字符）

还有一个硬约束：文件夹名必须和 `name` 完全一致。改名字要连目录一起改。

另外，上架到 Marketplace 或作为自定义 skill 上传时，部分平台不允许名字里出现 `claude`、`anthropic` 这类保留词。

### `description`

这是**唯一**决定 agent 要不要加载你的 skill 的信息，值得反复打磨。要点：写清动作、写清触发场景、把用户可能会说的关键词塞进去。

差：

```yaml
description: 帮助处理 PDF。
```

好：

```yaml
description: 从 PDF 中提取文本和表格、填写 PDF 表单、合并多个 PDF。处理 PDF 文档、表单或需要提取文档内容时使用，用户提到 PDF、表单、文档提取时也应触发。
```

## 正文怎么写

规范不限制格式，但有三类内容值得写：

1. **分步指令** —— agent 该按什么顺序做什么
2. **输入输出示例** —— 给一组真实的前后对照，比形容词有效
3. **边界情况** —— 遇到什么该停下、该问人、该走兜底

不要写的东西：agent 已经知道的常识、宣传性描述、"你是一个专业的……"这类角色扮演开场。

## 附属目录的约定

`scripts/` —— agent 会执行这里的代码。要求：自包含或写清依赖、报错信息能看懂、边界情况不崩。语言看宿主支持，Python / Bash / JavaScript 最常见。

`references/` —— 按需读取的文档。常见命名 `REFERENCE.md`（技术细节）、`FORMS.md`（表单或数据结构）、按领域拆（`finance.md`、`legal.md`）。文件要小要聚焦，因为每读一个都吃上下文。

`assets/` —— 静态资源：文档模板、配置模板、示意图、查找表、schema。

## 文件引用

用相对路径，从 skill 根目录算起，**只往下引用一层**，不要套娃：

```markdown
细节见 [参考文档](references/REFERENCE.md)。

执行提取脚本：
scripts/extract.py
```

## 上手顺序（建议）

1. 先写 `description`，用一句话回答「用户说什么话的时候，这个 skill 该被想起来」。
2. 再写正文的 3–5 个步骤，用命令式动词，不用「你可以……」。
3. 找一次真实任务跑一遍，把 agent 做错的地方补进「边界情况」。
4. 发现正文超过 300 行，就把细节挪进 `references/`。
5. 最后用官方校验工具检查命名和前言：

```bash
skills-ref validate ./my-skill
```

## 一个完整的小例子

```text
commit-helper/
├── SKILL.md
└── references/
    └── TYPES.md
```

```yaml
---
name: commit-helper
description: 为当前仓库的改动生成符合约定的中文提交信息，并检查是否混入了密钥或大文件。需要写 git commit、整理提交说明、或在提交前做自检时使用。
license: MIT
metadata:
  author: m-oy-i
  version: "1.0"
---

# 生成提交信息

## 步骤

1. 运行 `git diff --staged --stat` 看这次改动的范围。
2. 运行 `git diff --staged` 读具体内容，不要只看文件名猜。
3. 按 `references/TYPES.md` 选择类型前缀。
4. 输出格式为 `类型: 简述`，简述不超过 30 字，说清改了什么而不是"改了一下"。

## 边界情况

- 暂存区为空：提示先 `git add`，不要自己加。
- 改动里出现 `.env`、`*.key`、`*.pem`：先警告，不要直接提交。
- 单次改动超过 20 个文件：建议拆成多次提交，并给出拆分方案。
```

## 常见坑

- **目录名和 `name` 不一致** —— 校验直接失败，改名字要连目录改。
- **description 写得太抽象** —— "提升代码质量"这种描述，agent 永远匹配不上具体任务。
- **正文塞满参考资料** —— 一旦激活就全量吃进上下文，把长篇内容放 `references/`。
- **scripts 里依赖没写清** —— 换台机器就跑不起来，报错还看不懂。
- **一个 skill 想干太多事** —— 拆成多个，用 description 区分触发场景，比塞进一个大 skill 有效。
