#!/usr/bin/env bash
set -euo pipefail
# Agent-Reach 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/Panniantong/Agent-Reach#快速上手
# 更新日期：2026-10-26
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }

mkdir -p .download
cd .download

command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH" ; uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip
agent-reach setup

echo ""

echo "安装完成：先跑 agent-reach channels 看渠道，再试 agent-reach bilibili search “大模型”；要小红书等渠道用 agent-reach add <渠道>"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/Panniantong/Agent-Reach#快速上手"
