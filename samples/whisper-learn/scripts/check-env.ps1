<#
  check-env.ps1 — Whisper 环境体检
  用法:  ./scripts/check-env.ps1
  作用:  只读检查，不安装任何东西。确认 Python 3.8-3.11 / pip / git / ffmpeg(必需) / (可选)Rust / GPU 是否就绪。
#>

$ErrorActionPreference = 'SilentlyContinue'
function Line($s){ Write-Host $s }
function OK($s){ Write-Host "  [ OK ]  $s" -ForegroundColor Green }
function WARN($s){ Write-Host "  [WARN]  $s" -ForegroundColor Yellow }
function BAD($s){ Write-Host "  [FAIL]  $s" -ForegroundColor Red }

Line ""
Line "==================== Whisper 环境体检 ===================="
Line ""

# --- Python ---
Line "Python (官方在 3.8-3.11 上测试；3.12/3.13 也已在 pyproject 声明支持):"
$py = Get-Command python -ErrorAction SilentlyContinue
if ($py) {
    $ver = (& python --version) 2>&1
    if ($ver -match '(\d+)\.(\d+)\.(\d+)') {
        $maj=[int]$Matches[1]; $min=[int]$Matches[2]
        if ($maj -eq 3 -and $min -ge 8) { OK "$ver  @ $($py.Source)" }
        else { BAD "$ver 版本不合适，Whisper 需要 Python >= 3.8" }
    } else { WARN "检测到 python 但无法解析版本: $ver" }
} else { BAD "未找到 python，请先安装 Python 3.8+ (https://www.python.org/downloads/)" }

# --- pip ---
Line ""
Line "pip:"
if (Get-Command pip -ErrorAction SilentlyContinue) { OK ((& pip --version) 2>&1) }
else { BAD "未找到 pip" }

# --- git ---
Line ""
Line "git (从源码安装 / 克隆用):"
if (Get-Command git -ErrorAction SilentlyContinue) { OK ((& git --version) 2>&1) }
else { WARN "未找到 git（从 PyPI 装 openai-whisper 不需要；装最新提交才需要）" }

# --- ffmpeg (必需) ---
Line ""
Line "ffmpeg (必需 —— Whisper 用它读取/重采样音频):"
if (Get-Command ffmpeg -ErrorAction SilentlyContinue) {
    $f = ((& ffmpeg -version) 2>&1 | Select-Object -First 1)
    OK $f
} else { BAD "未找到 ffmpeg。Windows 可用:  choco install ffmpeg  或  scoop install ffmpeg" }

# --- Rust (可选) ---
Line ""
Line "Rust (可选 —— 仅当 tiktoken 没有你平台的预编译 wheel 时才需要):"
if (Get-Command rustc -ErrorAction SilentlyContinue) { OK ((& rustc --version) 2>&1) }
else { WARN "未找到 Rust（多数平台 tiktoken 有 wheel，无需 Rust；若 pip 装报错再装 https://rustup.rs/）" }

# --- GPU / CUDA (可选) ---
Line ""
Line "NVIDIA GPU (可选 —— 有 CUDA 显卡可大幅加速；纯 CPU 也能跑小模型):"
if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
    $g = ((& nvidia-smi --query-gpu=name,memory.total --format=csv,noheader) 2>&1 | Select-Object -First 1)
    OK "检测到 GPU: $g"
} else { WARN "未检测到 NVIDIA GPU（CPU 也能跑 tiny/base/small，large/turbo 会较慢）" }

# --- 磁盘 ---
Line ""
Line "当前盘剩余空间 (large 模型权重约 3GB，turbo 约 1.5GB):"
$drive = (Get-Location).Drive
if ($drive) {
    $free = [math]::Round($drive.Free/1GB,1)
    if ($free -gt 5) { OK "$($drive.Name): 剩余 $free GB" } else { WARN "$($drive.Name): 仅剩 $free GB，建议预留 >5GB 放模型权重" }
}

Line ""
Line "========================================================="
Line "体检完成。若 Python/pip/ffmpeg 均为 OK，即可运行:"
Line "    ./scripts/setup-whisper.ps1        # 预览将执行的动作"
Line "    ./scripts/setup-whisper.ps1 -Run   # 真正执行"
Line ""
