# Windows 开发环境笔记

在 Windows 上做开发，坑主要来自三处：终端、路径、换行符。这份笔记记录已经踩过并解决的部分。

## 终端选择

| 终端 | 适合 |
| --- | --- |
| Git Bash | 跑 bash 脚本、grep、ssh，和 Linux 命令最接近 |
| PowerShell | 系统管理、注册表、Windows 服务 |
| Windows Terminal | 外皮，可以同时开上面两个 |

Git Bash 里跑 shell 脚本时注意：路径用 `/c/Users/名字/` 这种形式，`C:\Users\` 反斜杠会被当成转义。

## SSH 密钥

```bash
ssh-keygen -t ed25519 -C "备注" -f ~/.ssh/id_ed25519 -N ""
cat ~/.ssh/id_ed25519.pub
```

把输出的整行贴到 GitHub → Settings → SSH and GPG keys。

自检：

```bash
ssh -T git@github.com
```

期望输出 `Hi 用户名! You've successfully authenticated`。

如果提示 `Permission denied (publickey)`：

1. 确认公钥贴的是 `.pub` 结尾那个文件的内容，不是私钥。
2. `ssh -vT git@github.com` 看用了哪个密钥文件。
3. 密钥文件名不是默认名字时，在 `~/.ssh/config` 里指定：

```text
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/自定义名字
```

## 换行符

Windows 用 CRLF，Linux/macOS 用 LF。混用会让 diff 显示整个文件都变了。

```bash
git config --global core.autocrlf true
```

含义：提交时 CRLF 转 LF，检出时 LF 转 CRLF。仓库里存储统一为 LF。

纯 Windows 项目可以用 `false`，只写前端/后端跨平台代码建议用 `input`。

仓库根目录放 `.gitattributes` 更可靠，不依赖每个人的本地配置：

```text
* text=auto
*.sh text eol=lf
```

## 路径与权限

- Git Bash 里 `chmod +x` 对 Windows 文件系统是模拟的，不一定被记录。要让脚本在仓库里保留可执行位：`git add --chmod=+x scripts/xxx.sh`。
- 路径含空格时加引号，`cd "C:/Program Files/xxx"`。
- 超长路径报错时，管理员权限执行：

```bash
git config --system core.longpaths true
```

## PowerShell 执行策略

脚本报 `无法加载文件，因为在此系统上禁止运行脚本`：

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

`RemoteSigned` 表示本地写的脚本可跑，从网上下载的需要签名。

## 开发工具

```bash
node --version
python --version
git --version
```

版本不一致时，优先用版本管理工具（如 nvm-windows、pyenv-win）而不是改系统 PATH，避免多个项目互相干扰。

装依赖时放在项目内的虚拟环境或本地目录，不要装到全局：

```bash
python -m venv .venv
source .venv/Scripts/activate     # Git Bash
.venv\Scripts\activate            # PowerShell
```

## 常见小问题

**中文乱码**
Git Bash 执行 `chcp.com 65001`，或在 Windows Terminal 设置里把编码设为 UTF-8。

**文件名大小写**
Windows 不区分大小写，`README.md` 改成 `readme.md` 时 git 可能识别不到：

```bash
git mv README.md readme.md
```

**文件被占用无法删除**
常见于 node_modules，先关掉占用进程（编辑器、`node` 进程），再删。

**换行导致脚本报 `bad interpreter`**
脚本文件本身被存成了 CRLF。用编辑器转成 LF，或执行：

```bash
sed -i 's/\r$//' scripts/xxx.sh
```
