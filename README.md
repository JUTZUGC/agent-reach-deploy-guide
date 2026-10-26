# Agent-Reach 一键部署指南

> 第三方部署指南 · 非 Agent-Reach 官方仓库。官方项目：[Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach)
> 内容来自官方文档（2026-10-26）。项目迭代快，请以[官方文档](https://github.com/Panniantong/Agent-Reach#快速上手)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用一个个配工具，让百度搭子装好 uv 和 Agent-Reach，之后一句话就能读 B站、小红书。

⚠️ 装的是命令行工具 + Agent 技能，需要 uv。部分渠道要登录（小红书、雪球热帖、Boss），首次使用会把 Chrome 里对应网站的登录状态复制一份到它自己的浏览器；建议用小号。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/agent-reach-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会先装好 uv（没有的话），再从官方 Release 装 agent-reach，最后跑一次 setup 开启默认渠道，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## Agent-Reach 是什么？

Agent-Reach 是开源的给 Agent 补上视频、登录页和中文平台数据的 CLI（协议：MIT，<img src="https://img.shields.io/github/stars/Panniantong/Agent-Reach?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

给 Agent 补上它自己够不着的数据：视频字幕、要登录的页面、中文平台（B站 / 小红书 / V2EX / 雪球 / Boss），一条命令拿到结构化结果，还能按链接自动选渠道。

- 默认渠道：bilibili、v2ex、github、youtube、web
- 可选渠道：xiaohongshu、xueqiu、boss（需登录）
- 视频内容：B站 / YouTube 字幕，音视频可转文字（需 Groq 或 OpenAI Key）
- 结构化输出：每条命令返回一个 JSON 对象，Agent 好解析

（来源：[官方仓库](https://github.com/Panniantong/Agent-Reach)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 102.9k stars | MIT 开源，增长很快 |
| 补齐 Agent 盲区 | 视频字幕、登录页、中文平台 |
| 一条命令拿数据 | 返回结构化 JSON，Agent 好接 |
| 渠道可插拔 | 默认 5 个渠道，按需再加 |
| 本地自持 | 登录态与数据都在本机目录 |

| 需要注意 | 说明 |
|---|---|
| 要登录的平台有账号风险 | 复制 Chrome 登录态，建议用小号 |
| 依赖平台页面 | 对方改版就可能失效 |
| 需要 uv | 没有 uv 要额外装一步 |
| 部分能力要 Key | 音视频转文字需 Groq / OpenAI |
| 合规要看用途 | 抓取他人内容要遵守平台条款与法律 |

> 以上基于官方文档与社区反馈整理（2026-10-26），以官方最新文档为准。

## 快速部署（官方方式）

```bash
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH" ; uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip
agent-reach setup
```

部署步骤来源：[https://github.com/Panniantong/Agent-Reach/blob/main/docs/install.md](https://github.com/Panniantong/Agent-Reach/blob/main/docs/install.md)

## 验证状态

| 场景 | 状态 |
|---|---|
| uv tool install 从官方 Release zip 安装成功（v1.6.0，隔离目录） | 已验证 2026-10-26 |
| agent-reach version 返回 JSON 且 ok 为 true | 已验证 2026-10-26 |
| 未执行 agent-reach setup（会复制登录态并装渠道工具） | 已核对 2026-10-26 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-26 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-26 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

它不是 MCP server，而是 CLI + 安装到客户端的技能，Agent 通过执行命令取数据。本仓库的 MCP 只提供安装步骤、登录说明与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-26）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\agent-reach-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装完成后：怎么用

```bash
agent-reach channels                      # 看有哪些渠道
agent-reach bilibili search "大模型"       # agent-reach <渠道> <动作> [参数]
agent-reach read https://www.v2ex.com/t/123   # 按链接自动选渠道
```

### 加渠道与登录

- 加小红书：`agent-reach add xiaohongshu`，按提示扫码或复制登录态
- 加雪球：`agent-reach add xueqiu`（行情不需要登录）
- 加 Boss：`agent-reach add boss`
- 转文字：`agent-reach configure groq-key`

> 所有数据与登录态都在 `~/.agent-reach/`，升级和卸载都只影响这个目录。
> **注意**：PyPI 上同名的 `agent-reach` 不是这个项目，不要从 PyPI 安装。

## 常见坑

- 别从 PyPI 装：同名 `agent-reach` 不是本项目，只用官方 Release 的 zip 地址
- 装完命令找不到：`uv tool update-shell` 后开新终端，或手动把 `~/.local/bin` 加进 PATH
- 要登录的渠道失败：先用小号在它自己的浏览器里登录，别用主账号
- 平台改版导致失败：先 `agent-reach update`，仍不行看 troubleshooting 文档
- 转文字没有结果：要 `agent-reach configure groq-key` 配 Key
- 只在有授权的范围内使用，不要拿它做大规模爬取

## 免责声明

本仓库为第三方指南，与 Agent-Reach 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-26），项目迭代快，请以[官方文档](https://github.com/Panniantong/Agent-Reach#快速上手)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
