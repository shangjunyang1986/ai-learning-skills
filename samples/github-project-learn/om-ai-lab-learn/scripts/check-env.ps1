<#
  check-env.ps1 — OmAgent 环境体检
  用法:  ./scripts/check-env.ps1
  作用:  只读检查，不安装任何东西。确认 Python>=3.10 / pip / git / (可选)Docker / Ollama 是否就绪。
#>

$ErrorActionPreference = 'SilentlyContinue'
function Line($s){ Write-Host $s }
function OK($s){ Write-Host "  [ OK ]  $s" -ForegroundColor Green }
function WARN($s){ Write-Host "  [WARN]  $s" -ForegroundColor Yellow }
function BAD($s){ Write-Host "  [FAIL]  $s" -ForegroundColor Red }

Line ""
Line "==================== OmAgent 环境体检 ===================="
Line ""

# --- Python ---
Line "Python (要求 >= 3.10):"
$py = Get-Command python -ErrorAction SilentlyContinue
if ($py) {
    $ver = (& python --version) 2>&1
    if ($ver -match '(\d+)\.(\d+)\.(\d+)') {
        $maj=[int]$Matches[1]; $min=[int]$Matches[2]
        if ($maj -gt 3 -or ($maj -eq 3 -and $min -ge 10)) { OK "$ver  @ $($py.Source)" }
        else { BAD "$ver 版本过低，OmAgent 需要 Python >= 3.10" }
    } else { WARN "检测到 python 但无法解析版本: $ver" }
} else { BAD "未找到 python，请先安装 Python 3.10+ (https://www.python.org/downloads/)" }

# --- pip ---
Line ""
Line "pip:"
if (Get-Command pip -ErrorAction SilentlyContinue) { OK ((& pip --version) 2>&1) }
else { BAD "未找到 pip" }

# --- git ---
Line ""
Line "git (克隆源码用):"
if (Get-Command git -ErrorAction SilentlyContinue) { OK ((& git --version) 2>&1) }
else { BAD "未找到 git，请安装 (https://git-scm.com/download/win)" }

# --- Docker (full 模式可选) ---
Line ""
Line "Docker (仅 full 分布式模式需要，lite 模式可忽略):"
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $d = (& docker --version) 2>&1
    OK $d
    $info = (& docker info) 2>&1
    if ($LASTEXITCODE -eq 0) { OK "Docker 守护进程在运行" } else { WARN "Docker 已安装但守护进程未运行（lite 模式不影响）" }
} else { WARN "未找到 Docker（lite 模式不需要；要跑 full 模式再装）" }

# --- Ollama (本地模型可选) ---
Line ""
Line "Ollama (可选，跑本地模型用):"
if (Get-Command ollama -ErrorAction SilentlyContinue) { OK ((& ollama --version) 2>&1) }
else { WARN "未找到 Ollama（用云端 API 则不需要）" }

# --- 磁盘 ---
Line ""
Line "当前盘剩余空间:"
$drive = (Get-Location).Drive
if ($drive) {
    $free = [math]::Round($drive.Free/1GB,1)
    if ($free -gt 10) { OK "$($drive.Name): 剩余 $free GB" } else { WARN "$($drive.Name): 仅剩 $free GB，建议预留 >10GB" }
}

Line ""
Line "========================================================="
Line "体检完成。若 Python/pip/git 均为 OK，即可运行:"
Line "    ./scripts/setup-omagent.ps1        # 预览将执行的动作"
Line "    ./scripts/setup-omagent.ps1 -Run   # 真正执行"
Line ""
