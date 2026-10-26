# Agent-Reach 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/Panniantong/Agent-Reach#快速上手
# 更新日期：2026-10-26
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) { powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex" }
$env:Path = "$env:USERPROFILE\.local\bin;$env:Path" ; uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip
agent-reach setup

Write-Host ''

Write-Host '安装完成：先跑 agent-reach channels 看渠道，再试 agent-reach bilibili search “大模型”；要小红书等渠道用 agent-reach add <渠道>'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/Panniantong/Agent-Reach#快速上手'
