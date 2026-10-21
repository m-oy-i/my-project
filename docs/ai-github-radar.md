# GitHub AI 资源雷达

数据抓取时间：2026-10-21。star 数取 GitHub trending / topic 页面当日显示值，仅供参考，会随时间变化。

用途：想找「别人已经做好的 skill / 提示词 / 小工具」时，从这里入手，不用重新搜一遍。

## 一、Agent Skills —— 当前最热的赛道

过去一年 GitHub 的 AI 热榜几乎被 Agent Skills 占满：把一段可复用的指令 + 脚本打包成文件夹（核心是 `SKILL.md`），让编码 agent 在特定任务上表现稳定。现在已经是跨工具事实标准，Claude Code、Codex、Cursor、Gemini CLI、OpenCode 都能读。

| 仓库 | 约 star | 说明 |
| --- | --- | --- |
| [anthropics/skills](https://github.com/anthropics/skills) | 183k | 官方仓库。含 docx / pdf / pptx / xlsx 生产级实现、`spec/` 规范、`template/` 模板 |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | 43.5k | 官方插件目录，本周涨 5.6k |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | 109k | Addy Osmani 出的工程级 skills |
| [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | 53.5k | 177 个科研 skill，覆盖生物、化学、医学、药物发现 |
| [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill) | 35.3k | 多阶段安全审计，输出可机器读的结论 |
| [android/skills](https://github.com/android/skills) | 9.1k | 官方 Android 开发 skill |
| [wshobson/agents](https://github.com/wshobson/agents) | 41.4k | 跨平台插件市场，一套内容多端可用 |
| [cursor/plugins](https://github.com/cursor/plugins) | 13.3k | Cursor 插件规范与官方插件 |

索引类（找 skill 先翻这两个）：

| 仓库 | 约 star | 说明 |
| --- | --- | --- |
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | 77.6k | 精选清单 |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | 56.2k | 资源大合集，含状态栏、工具链 |
| [VoltAgent/awesome-openclaw-skills](https://github.com/VoltAgent/awesome-openclaw-skills) | 53.3k | 5400+ skill 分类整理 |
| [sickn33/agentic-awesome-skills](https://github.com/sickn33/agentic-awesome-skills) | 48.2k | 2600+ skill，带本地 CLI 检索 |

**怎么写自己的 skill**：官方仓库的 `template/` 是最小骨架。frontmatter 只需要两个字段：

```yaml
---
name: my-skill-name          # 小写，连字符分隔
description: 这个 skill 做什么、什么时候该用它
---
```

正文写指令、示例、约束。描述字段很关键，agent 靠它判断要不要加载。

## 二、提示词库

| 仓库 | 约 star | 说明 |
| --- | --- | --- |
| [f/prompts.chat](https://github.com/f/prompts.chat) | 143k+ | 原名 Awesome ChatGPT Prompts，最大的开源提示词库。有 CLI：`npx prompts.chat`；也能当 Claude 插件装 |
| [x1xhlol/system-prompts-and-models-of-ai-tools](https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools) | 144k | 各家 AI 产品（Cursor、Windsurf、v0、Devin 等）真实系统提示词，学"生产级 prompt 怎么搭骨架" |
| [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) | 162k | 一堆 AI 角色人格，各有语气和工作流 |
| [PlexPt/awesome-chatgpt-prompts-zh](https://github.com/PlexPt/awesome-chatgpt-prompts-zh) | 63.8k | 中文提示词合集，覆盖几十种角色场景 |
| [Leey21/awesome-ai-research-writing](https://github.com/Leey21/awesome-ai-research-writing) | 35k | 学术写作提示词 + skill，专门做润色、翻译、去 AI 味 |
| [freestylefly/awesome-gpt-image-2](https://github.com/freestylefly/awesome-gpt-image-2) | 34.8k | 544 个反推生图案例 + 工业级模板 |
| [jnMetaCode/agency-agents-zh](https://github.com/jnMetaCode/agency-agents-zh) | 21.5k | 上面 agency-agents 的中文版，277 个角色 |
| [2025Emma/vibe-coding-cn](https://github.com/2025Emma/vibe-coding-cn) | 23.1k | 中文 vibe coding 方法论，从想法到上线 |
| [yihui-dev/awesome-opus5-5-videos](https://github.com/yihui-dev/awesome-opus5-5-videos) | 6.8k | 爆款视频 + 作者原始提示词，一对一对齐 |
| [promptfoo/promptfoo](https://github.com/promptfoo/promptfoo) | 26.2k | 提示词评测与红队测试框架，把 prompt 当代码测 |

**看系统提示词的用法**：不是抄。重点看结构——怎么分节、怎么设输出格式约束、怎么处理拒绝和兜底。这比背模板有用。

## 三、小玩法（装完就能玩出东西）

| 仓库 | 约 star | 玩法 |
| --- | --- | --- |
| [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | 171k | 一个 prompt 让 agent 变成"屋里最懒的资深工程师"：能不写就不写，能少写绝不多写（YAGNI） |
| [yang0/handraw-style](https://github.com/yang0/handraw-style) | 5.9k | 365 种手绘风格 + 167 种排版 + 36 种主题色的编号库，中文，选编号直接出中英双语生图提示词 |
| [tt-a1i/archify](https://github.com/tt-a1i/archify) | 86.8k | 把想法、方案或代码库变成可交互的架构图 |
| [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | 131k | 代码库 + 文档 + SQL + PDF 变成可查询的知识图谱，本地 AST 解析，不靠向量库 |
| [earthtojake/text-to-cad](https://github.com/earthtojake/text-to-cad) | 22.2k | 给 agent 装上 CAD 能力，用自然语言改模型 |
| [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | 68.9k | 写 HTML 直接渲染成视频，为 agent 设计 |
| [debpalash/VoiceStudio](https://github.com/debpalash/VoiceStudio) | 79.9k | 全本地 ElevenLabs 替代：克隆音色、配音、转录、有声书，646 种语言 |
| [blader/humanizer](https://github.com/blader/humanizer) | 59.1k | 去掉文本里的 AI 味 |
| [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | 100k | 给编码 agent 装审美：美术指导 + 参考图 + 浏览器实拍校验，专治"一眼 AI 生成页" |
| [cathrynlavery/diagram-design](https://github.com/cathrynlavery/diagram-design) | 59.3k | 44 种图表类型，纯 HTML + SVG 输出，不用 Mermaid |
| [MadsLorentzen/ai-job-search](https://github.com/MadsLorentzen/ai-job-search) | 62.5k | 求职全套：评估岗位、改简历、写求职信、模拟面试，全在本机跑 |

**ponytail 的实际用法**（最能体现"一个 prompt 有多大威力"）：

```text
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```

常用命令：`/ponytail lite|full|ultra|off` 调强度，`/ponytail-review` 用"半夜被叫起来修 bug 的资深工程师"视角审当前 diff，`/ponytail-debt` 把代码里 `shortcut:` 注释收集成待办账本。

## 四、上下文与记忆（工程向，省 token）

| 仓库 | 约 star | 说明 |
| --- | --- | --- |
| [headroomlabs-ai/headroom](https://github.com/headroomlabs-ai/headroom) | 77k | 在内容进 LLM 前压缩工具输出、日志、JSON，声称 JSON 场景省 60–95% token |
| [mksglu/context-mode](https://github.com/mksglu/context-mode) | 31.6k | 把工具输出沙箱化（减 98%），持久化会话记忆，MCP + hooks 实现 |
| [akitaonrails/ai-memory](https://github.com/akitaonrails/ai-memory) | 12.1k | 给编码 CLI 做长期记忆，方便在不同厂商的 agent 之间交接 |
| [stablyai/orca](https://github.com/stablyai/orca) | 101k | 管理一队 agent，用自己的订阅跑，桌面/移动/远程都有 |

## 五、如果只挑几个

1. **[anthropics/skills](https://github.com/anthropics/skills)** —— 想自己写 skill 就先读这个，有规范有模板有生产案例。
2. **[f/prompts.chat](https://github.com/f/prompts.chat)** —— 提示词起步库，`npx prompts.chat` 就能本地跑。
3. **[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)** —— 成本最低的一次体验升级，一个 prompt 就改变 agent 的行为方式。
4. **[yang0/handraw-style](https://github.com/yang0/handraw-style)** —— 中文场景、生图、玩法强，做封面和插图很省事。
5. **[Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) 或 [tt-a1i/archify](https://github.com/tt-a1i/archify)** —— 接手陌生代码库时，先让它把结构画出来。

## 六、注意事项

- **star 不等于质量**。榜单上的星数有短期爆发成分，装之前看最后提交时间、issue 响应、README 有没有写清边界。
- **skill 是能执行代码的**。装第三方 skill 等于让它运行别人写的脚本，尤其是带 hooks 的插件，先读一遍再装。
- **系统提示词类仓库**属于研究/透明度性质，学结构可以，直接商用抄用要看清许可。
- **提示词类项目许可各异**，MIT、Apache 2.0、署名要求、仅限个人使用都有，二次分发前确认。
