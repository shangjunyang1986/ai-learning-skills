<#
  check-env.ps1 — Qwen-Agent 环境体检
  用法:  ./scripts/check-env.ps1
  作用:  只读检查，不安装任何东西。确认 Python>=3.10 / pip / git / (可选)Docker / Node.js 是否就绪。
         Qwen-Agent 的 [code_interpreter] 用 Docker 起沙箱；[mcp] 的若干 server 用 npx (Node.js)。
#>

$ErrorActionPreference = 'SilentlyContinue'
function Line($s){ Write-Host $s }
function OK($s){ Write-Host "  [ OK ]  $s" -ForegroundColor Green }
function WARN($s){ Write-Host "  [WARN]  $s" -ForegroundColor Yellow }
function BAD($s){ Write-Host "  [FAIL]  $s" -ForegroundColor Red }

Line ""
Line "==================== Qwen-Agent 环境体检 ===================="
Line ""

# --- Python ---
Line "Python (GUI 需要 >= 3.10):"
$py = Get-Command python -ErrorAction SilentlyContinue
if ($py) {
    $ver = (& python --version) 2>&1
    if ($ver -match '(\d+)\.(\d+)\.(\d+)') {
        $maj=[int]$Matches[1]; $min=[int]$Matches[2]
        if ($maj -gt 3 -or ($maj -eq 3 -and $min -ge 10)) { OK "$ver  @ $($py.Source)" }
        else { WARN "$ver 偏低：纯 Function Calling 可用，但 [gui] (Gradio 5) 需要 Python >= 3.10" }
    } else { WARN "检测到 python 但无法解析版本: $ver" }
} else { BAD "未找到 python，请先安装 Python 3.10+ (https://www.python.org/downloads/)" }

# --- pip ---
Line ""
Line "pip:"
if (Get-Command pip -ErrorAction SilentlyContinue) { OK ((& pip --version) 2>&1) }
else { BAD "未找到 pip" }

# --- git ---
Line ""
Line "git (源码安装用):"
if (Get-Command git -ErrorAction SilentlyContinue) { OK ((& git --version) 2>&1) }
else { BAD "未找到 git，请安装 (https://git-scm.com/download/win)" }

# --- Docker (code_interpreter 可选) ---
Line ""
Line "Docker (仅 [code_interpreter] 沙箱需要，function calling/RAG 可忽略):"
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $d = (& docker --version) 2>&1
    OK $d
    $info = (& docker info) 2>&1
    if ($LASTEXITCODE -eq 0) { OK "Docker 守护进程在运行" } else { WARN "Docker 已安装但守护进程未运行（不跑代码解释器则不影响）" }
} else { WARN "未找到 Docker（只跑 function calling / RAG 则不需要）" }

# --- Node.js (MCP 可选) ---
Line ""
Line "Node.js / npx (仅 [mcp] 的部分 server 需要，可选):"
if (Get-Command node -ErrorAction SilentlyContinue) { OK ((& node --version) 2>&1) }
else { WARN "未找到 Node.js（不接 MCP 则不需要）" }

# --- DASHSCOPE_API_KEY ---
Line ""
Line "DASHSCOPE_API_KEY (用阿里云 DashScope 模型服务时需要):"
if ($env:DASHSCOPE_API_KEY) { OK "已设置环境变量 DASHSCOPE_API_KEY" }
else { WARN "未设置 DASHSCOPE_API_KEY（也可改用 vLLM/Ollama 的 OpenAI 兼容端点）" }

# --- 磁盘 ---
Line ""
Line "当前盘剩余空间:"
$drive = (Get-Location).Drive
if ($drive) {
    $free = [math]::Round($drive.Free/1GB,1)
    if ($free -gt 5) { OK "$($drive.Name): 剩余 $free GB" } else { WARN "$($drive.Name): 仅剩 $free GB" }
}

Line ""
Line "==========================================================="
Line "体检完成。若 Python/pip 均为 OK，即可运行:"
Line "    ./scripts/setup-qwen-agent.ps1        # 预览将执行的动作"
Line "    ./scripts/setup-qwen-agent.ps1 -Run   # 真正执行"
Line ""
