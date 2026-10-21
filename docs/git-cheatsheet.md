# Git 常用操作速查

按"我现在想干什么"来查，不用背命令。

## 日常流程

```bash
git status                 # 看当前状态，先看这个再操作
git add -A                 # 把所有改动加入暂存区
git add -p                 # 逐块选择要暂存的内容，适合一次提交只包含一个主题
git commit -m "文档: 说明改了什么"
git push                   # 推到远端
git pull --rebase          # 拉取远端并把本地提交挪到后面，历史更干净
```

## 查看

```bash
git log --oneline --graph --all    # 图形化看分支结构
git log -p --follow -- 文件名      # 看某个文件的完整改动历史，含重命名
git diff                           # 工作区 vs 暂存区
git diff --staged                  # 暂存区 vs 最后一次提交
git diff main...feature            # 两个分支的差异，... 只看 feature 侧新增
git show 提交号                    # 看某次提交的具体内容
git blame 文件名                   # 逐行看是谁、哪次提交改的
git log -S "关键字" --oneline      # 搜索哪次提交增删了这个字符串
```

## 撤销

工作区的改动不要了：

```bash
git restore 文件名          # 丢弃单个文件的未暂存改动
git restore .               # 丢弃所有未暂存改动
```

已经 `git add` 但想撤回暂存：

```bash
git restore --staged 文件名
```

最近一次提交写错了，还没推送：

```bash
git commit --amend -m "新的说明"     # 只改说明
git commit --amend --no-edit        # 把新暂存的内容并进上一次提交，说明不变
```

退回若干次提交，还没推送：

```bash
git reset --soft HEAD~1    # 撤销提交，改动留在暂存区
git reset --mixed HEAD~1   # 撤销提交，改动留在工作区（默认）
git reset --hard HEAD~1    # 撤销提交并丢弃改动，危险
```

已经推送了，用反向提交而不是改历史：

```bash
git revert 提交号          # 生成一个抵消该提交的新提交，安全
```

## 找回丢失的提交

`reset --hard` 之后后悔了：

```bash
git reflog                 # 列出 HEAD 移动记录，找到目标提交号
git reset --hard 提交号    # 回去
```

`reflog` 默认保留 90 天，未推送的提交基本都能找回来。

## 分支

```bash
git switch -c 新分支名      # 新建并切换
git switch main            # 切换分支
git branch -d 分支名        # 删除已合并分支
git branch -D 分支名        # 强制删除未合并分支
git branch -vv             # 看本地分支与远端的跟踪关系
git push -u origin 分支名   # 首次推送并建立跟踪
```

## 暂存

改到一半需要切分支：

```bash
git stash push -m "半成品说明"
git stash list
git stash pop              # 恢复并删除该暂存
git stash apply            # 恢复但保留暂存记录
```

## 远端

```bash
git remote -v                                   # 查看远端地址
git remote set-url origin 新地址                # 换地址，比如仓库改名后
git fetch --prune                              # 拉取并清理已删除的远端分支引用
git push origin --delete 分支名                # 删除远端分支
```

## 标签

```bash
git tag -a v1.0.0 -m "首个版本"
git push origin v1.0.0
git push origin --tags
```

## 常见报错

**`Permission denied (publickey)`**
SSH 密钥没被 GitHub 认到。先自检：

```bash
ssh -T git@github.com
```

返回 `Hi 用户名!` 才正常。否则检查 `~/.ssh/id_ed25519.pub` 是否已加到 GitHub 的 Settings → SSH keys。

**`Updates were rejected because the remote contains work you do not have`**
远端有你本地没有的提交。先 `git pull --rebase`，解决冲突后再 `git push`。不要用 `--force`。

**`fatal: not a git repository`**
当前目录不在仓库里，`cd` 到项目根目录，或者确认 `.git` 是否还在。

**提交后文件显示全量修改（整个文件都变了）**
换行符不一致。Windows 上设置一次即可：

```bash
git config --global core.autocrlf true
```

仓库里已有大量 CRLF 文件时要谨慎，可能需要 `git add --renormalize .` 统一一次。

**`warning: LF will be replaced by CRLF`**
只是提示，不是错误，说明 `core.autocrlf` 生效了。
