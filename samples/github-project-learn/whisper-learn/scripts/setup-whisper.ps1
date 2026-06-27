<#
  setup-whisper.ps1 — 在本地建好 Whisper 的运行环境
  用法:
      ./scripts/setup-whisper.ps1          # DRY-RUN，只打印将要执行的命令，不改动任何东西
      ./scripts/setup-whisper.ps1 -Run     # 真正执行：建 venv + 安装 openai-whisper + 跑一次自带样例

  设计为安全默认：不加 -Run 绝不动手。
  说明：Whisper 直接从 PyPI 安装（pip install -U openai-whisper），无需克隆源码即可使用 CLI。
#>
param(
    [switch]$Run,                                          # 不加 = dry-run
    [string]$Dest = (Join-Path (Get-Location) "whisper-env")
)

$ErrorActionPreference = 'Stop'
$mode = if ($Run) { "执行模式 (-Run)" } else { "DRY-RUN 预览（加 -Run 才真正执行）" }

Write-Host ""
Write-Host "==================== Whisper 安装脚本 ====================" -ForegroundColor Cyan
Write-Host "  模式 : $mode"
Write-Host "  venv : $Dest"
Write-Host "  来源 : PyPI (openai-whisper)"
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""

$pyExe = Join-Path $Dest "Scripts/python.exe"

# 将要执行的步骤
$steps = @(
    @{ desc = "创建虚拟环境 (.venv)";            cmd = "python -m venv `"$Dest`"" },
    @{ desc = "升级 pip";                         cmd = "& `"$pyExe`" -m pip install -U pip" },
    @{ desc = "安装 openai-whisper（含 torch 等依赖）"; cmd = "& `"$pyExe`" -m pip install -U openai-whisper" },
    @{ desc = "用自带样例 jfk.flac 跑一次转写（首次会下载 turbo 权重）";
       cmd = "& `"$pyExe`" -m whisper --model turbo --output_dir whisper-out (Resolve-Path .)/tests/jfk.flac" }
)

$i = 0
foreach ($s in $steps) {
    $i++
    Write-Host "[$i/$($steps.Count)] $($s.desc)" -ForegroundColor Yellow
    Write-Host "      $ $($s.cmd)" -ForegroundColor DarkGray

    if ($Run) {
        try {
            Invoke-Expression $s.cmd
            Write-Host "      ✓ 完成" -ForegroundColor Green
        } catch {
            Write-Host "      ✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "      停止。请把上面的报错回填到学习手册第 8 节『踩坑日志』。" -ForegroundColor Red
            Write-Host "      常见原因：未装 ffmpeg / 无网络下载模型权重 / tiktoken 需要 Rust。" -ForegroundColor Red
            exit 1
        }
    }
    Write-Host ""
}

Write-Host "=========================================================" -ForegroundColor Cyan
if ($Run) {
    Write-Host "安装完成。常用命令：" -ForegroundColor Green
} else {
    Write-Host "以上为预览。确认无误后执行：  ./scripts/setup-whisper.ps1 -Run" -ForegroundColor Green
}
Write-Host @"
    # CLI：转写任意音频（默认 turbo 模型）
    & "$pyExe" -m whisper audio.mp3 --model turbo

    # 转写非英语并翻译成英文（turbo 不支持翻译，用 medium/large）
    & "$pyExe" -m whisper japanese.wav --model medium --language Japanese --task translate

    # Python 里调用
    # import whisper; m = whisper.load_model("turbo"); print(m.transcribe("audio.mp3")["text"])
"@
Write-Host ""
